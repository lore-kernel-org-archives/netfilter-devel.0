From: Daniel Borkmann <dborkman@redhat.com>
Subject: Fwd: [Bug 88841] New: Kernel crash after a few minutes
Date: Mon, 24 Nov 2014 22:15:08 +0100
Message-ID: <54739FDC.1020101@redhat.com>
References: <bug-88841-65011@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: jp.pozzi@izzop.net, bill bonaparte <programme110@gmail.com>,
	Jesper Dangaard Brouer <brouer@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747AbaKXVPW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 16:15:22 -0500
In-Reply-To: <bug-88841-65011@https.bugzilla.kernel.org/>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I think commit 5195c14c8b27c ("netfilter: conntrack: fix race in __nf_conntrack_confirm
against get_next_corpse") seems to be causing the issue.

-------- Original Message --------
Subject: [Bug 88841] New: Kernel crash after a few minutes
Date: Mon, 24 Nov 2014 18:03:13 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: dborkman@redhat.com

https://bugzilla.kernel.org/show_bug.cgi?id=88841

             Bug ID: 88841
            Summary: Kernel crash after a few minutes
            Product: Networking
            Version: 2.5
     Kernel Version: 3.18-rc6
           Hardware: x86-64
                 OS: Linux
               Tree: Mainline
             Status: NEW
           Severity: high
           Priority: P1
          Component: Netfilter/Iptables
           Assignee: networking_netfilter-iptables@kernel-bugs.osdl.org
           Reporter: jp.pozzi@izzop.net
         Regression: No

Created attachment 158701
   --> https://bugzilla.kernel.org/attachment.cgi?id=158701&action=edit
.config file

Hello,

I compile 3.18-rc6 and I get a kernel crash after a few minutes.
The system is running Suricata, Squid as a test machine.
I didn't see any things in the logs ... so I took a photo of the screen.

Machine :
CPU         Core I3 3220 3,30Ghz
RAM         8G
Mother card Asus P8H77-I
Some disks ...
Distrib.    Debian 7.4

All is working with 3.18-rc5, only rc6 crashes.

Regards

JP P

I enclose the .config and the screen's photo.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.


