From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Fw: [Bug 17622] New: snmp trap ALG issue
Date: Thu, 2 Sep 2010 07:45:03 -0700
Message-ID: <20100902074503.1a469d52@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751108Ab0IBOpY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:45:24 -0400
Received: from nehalam (pool-74-107-135-205.ptldor.fios.verizon.net [74.107.135.205])
	(authenticated bits=0)
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id o82Ej8pQ013570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 2 Sep 2010 07:45:23 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Begin forwarded message:

Date: Thu, 2 Sep 2010 09:25:14 GMT
From: bugzilla-daemon@bugzilla.kernel.org
To: shemminger@linux-foundation.org
Subject: [Bug 17622] New: snmp trap ALG issue


https://bugzilla.kernel.org/show_bug.cgi?id=17622

           Summary: snmp trap ALG issue
           Product: Networking
           Version: 2.5
    Kernel Version: 2.6.35.4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
        AssignedTo: shemminger@linux-foundation.org
        ReportedBy: wtweeker@163.com
        Regression: No


Symptom:
SNMP manager can't show trap when SNMP agent set trap message to  version1.

steps to reproduce:
(1)SNMP agent-----linux device(NAT)-----SNMP manager.
(2)Set SNMP agent trap message to version 1, destination IP as SNMP   manger's
IP.
(3)Do some operation to generate trap message, such as make one port of SNMP
agent up and down. But SNMP manger can't accept trap message.

I have capured the packet by Ethereal software, and check the SNMP trap packet,
found that the UDP checksum is incorrect. 
I think that the function fast_csum()(nf_nat_snmp_basic.c) have some problem.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.


-- 
