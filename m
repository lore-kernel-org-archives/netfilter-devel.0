From: Donovan <doohara@cisco.com>
Subject: additional conntrack feature
Date: Thu, 17 Apr 2014 17:25:45 -0400
Message-ID: <535046D9.3020602@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from alln-iport-2.cisco.com ([173.37.142.89]:55949 "EHLO
	alln-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaDQVXl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:23:41 -0400
Received: from [161.44.64.164] (dhcp-161-44-64-164.cisco.com [161.44.64.164])
	by alln-core-9.cisco.com (8.14.5/8.14.5) with ESMTP id s3HLNeTc021427
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Apr 2014 21:23:40 GMT
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

We are writing Proof Of Concept (POC) code to export (send) enhanced 
NetFlow based on conntrack events. We've added some new minimal 
functionality to the kernel socket and netfilter-conntrack code. This 
provides new information in the events as can be viewed by the conntrack 
program.

We would like to send NetFlow based on the conntrack events and were 
wondering where to place such functionality. We would like such NetFlow 
to be sent by a service or daemon and we would like for this 
functionality to become open source. We have some questions:

- Would it be acceptable to enhance conntrack-tools to send this NetFlow?
- Like for instance placing it in the conntrackd daemon?
- Or would it be OK to provide a new program alongside conntrack and 
conntrackd or the conntrack-tools to do this?

Getting the kernel changes committed is one matter but they are 
pointless without a user-space program to make use of the conntrack 
events and send the NetFlow which is our final aim. We did also think of 
potentially adding such code to the existing flow-tools suite 
(http://www.splintered.net/sw/flow-tools/docs/flow-tools.html)  but it 
feels odd that such flow-tool code will rely on conntrack events.

Thanks
Donovan
