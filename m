From: Patrick McHardy <kaber@trash.net>
Subject: [Fwd: [Bug 10768] New: Got oops with :ip_tables:get_counters during
 boot]
Date: Wed, 21 May 2008 19:25:28 +0200
Message-ID: <48345B08.5040107@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46907 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935793AbYEURZ3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 13:25:29 -0400
Received: from [192.168.0.100] (unknown [78.42.204.165])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by stinky.trash.net (Postfix) with ESMTP id 251E2948A2
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2008 19:25:28 +0200 (MEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case someone is interested in some bug hunting - more
information in the bug entry.

-------- Original Message --------
Subject: [Bug 10768] New: Got oops with :ip_tables:get_counters during boot
Date: Wed, 21 May 2008 03:35:24 -0700 (PDT)
From: bugme-daemon@bugzilla.kernel.org
To: kaber@trash.net

http://bugzilla.kernel.org/show_bug.cgi?id=10768

            Summary: Got oops with :ip_tables:get_counters during boot
            Product: Networking
            Version: 2.5
      KernelVersion: 2.6.26-rc3
           Platform: All
         OS/Version: Linux
               Tree: Mainline
             Status: NEW
           Severity: normal
           Priority: P1
          Component: Netfilter/Iptables
         AssignedTo: networking_netfilter-iptables@kernel-bugs.osdl.org
         ReportedBy: zdenek.kabelac@gmail.com


Latest working kernel version:
Earliest failing kernel version:
Distribution:
Hardware Environment: T61
Software Environment: Fedora rawhide (kernel build from Linus tree)
Problem Description:

Iptable generated an oops on the screen once during the boot - I've had 
digital
cammera - so I've taken a snapshot  - see the attachement
(Kernel has this git commit number:  ec772ac1f415ca0d)


Steps to reproduce:
Happend only once during boot - and I have only digicatal camera snapshot
So I've no idea how to reproduce or check whether its been fixed.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.

