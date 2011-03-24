From: Jan Viktorin <xvikto03@stud.fit.vutbr.cz>
Subject: hardware specific extension to netfilter, xilinx microblaze, how
 to start
Date: Thu, 24 Mar 2011 01:26:50 +0100
Message-ID: <1300926410.3280.26.camel@jvarch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from eva.fit.vutbr.cz ([147.229.176.14]:51388 "EHLO eva.fit.vutbr.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406Ab1CXAim (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Mar 2011 20:38:42 -0400
Received: from [10.0.11.52] (ip4-95-82-189-228.cust.nbox.cz [95.82.189.228])
	(authenticated user=xvikto03 mech=PLAIN bits=0)
	by eva.fit.vutbr.cz (envelope-from xvikto03@stud.fit.vutbr.cz) (8.14.4/8.14.4) with ESMTP id p2O0Nokk004783
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Mar 2011 01:23:50 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am working on my bachelor thesis 'Implementation of the Network
Traffic Filter by Microblaze in FPGA' and I decided to use Linux with
netfilter for that. The aim is to profit from FPGA chip which offers to
add a custom hardware component to the Microblaze soft processor to
speed up something.

So I would like to add some hardware acceleration to the netfilter, eg.
ip address matching. This is accomplished using the processor specific
instructions that communicate with the custom hardware piece. 

I have read the "Writing Netfilter modules" (from xtables-addons page),
looked at some code, but I'm still not sure where to start. 

Do you thing that it is sufficient to write my own match module that
will do the job?

Where can I find current x_tables' IP address matching code? When is it
called and how can I avoid it or replace it...?

Thank you very much for any hint.

--
Jan Viktorin

Microblaze: http://www.xilinx.com/tools/microblaze.htm
FPGA: http://en.wikipedia.org/wiki/Field-programmable_gate_array

