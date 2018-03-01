/*
 * Copyright (C) 2014 Robotics, Brain and Cognitive Sciences - Istituto Italiano di Tecnologia
 * Author: Naveen Kuppuswamy
 * E-mail: naveen.kuppuswamy@iit.it
 *
 * Modified by: Martin Neururer
 * E-mail:      martin.neururer@student.tuwien.ac.at / martin.neururer@gmail.com
 * Date:        June, 2016 & January, 2017
 *
 * The development of this software was supported by the FP7 EU project
 * CoDyCo (No. 600716 ICT 2011.2.1 Cognitive Systems and Robotics (b)),
 * <http://www.codyco.eu>.
 *
 * Permission is granted to copy, distribute, and/or modify this program
 * under the terms of the GNU General Public License, version 2 or any
 * later version published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * A copy of the GNU General Public License can be found along with
 * the source library. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef MODELGENERALIZEDBIASFORCES_H
#define MODELGENERALIZEDBIASFORCES_H

// global includes

// library includes

// local includes
#include "modelcomponent.h"

namespace mexWBIComponent
{
  class ModelGeneralizedBiasForces : public ModelComponent
  {
    public:
      static ModelGeneralizedBiasForces *getInstance();

      /**
       * Delete the (static) instance of this component,
       * and set the instance pointer to 0.
       */
      static void deleteInstance();

      virtual bool allocateReturnSpace(int nlhs, mxArray **plhs);
      virtual bool compute(int nrhs, const mxArray **prhs);
      virtual bool computeFast(int nrhs, const mxArray **prhs);

      virtual ~ModelGeneralizedBiasForces();

    private:
      ModelGeneralizedBiasForces();
      static bool processArguments(int nrhs, const mxArray **prhs);

      static ModelGeneralizedBiasForces *modelGeneralizedBiasForces;

      // inputs:
      static double *qj;
      static double *qj_dot;
      static double *vb;
      static double *g;
      // output:
      static double *c_qv; // generalized bias forces C(q,dq)
      // For further details see:
      //  [1] Rigid Body Dynamics Algorithms, Roy Featherstone, Springer, 2008, p. 40.
    };

}

#endif // MODELGENERALIZEDBIASFORCES_H