From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: netfilter: BUG: sleeping function called from invalid context
Date: Wed, 10 Jun 2009 16:19:35 +0200
Message-ID: <20090610161935.0f8b1949@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Maran Pakkirisamy <maranpsamy@in.ibm.com>,
	Andreas Krebbel <krebbel1@de.ibm.com>,
	<linux-kernel@vger.kernel.org>, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:34286 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757634AbZFJOTp convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 10:19:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Maran reported the bug below (vanilla 2.6.30-rc8):

BUG: sleeping function called from invalid context at /mnt/s390test/lin=
ux-2.6-tip/arch/s390/include/asm/uaccess.h:234=20
in_atomic(): 1, irqs_disabled(): 0, pid: 3245, name: sysctl=20
CPU: 1 Not tainted 2.6.30-rc8-tipjun10-02053-g39ae214 #1=20
Process sysctl (pid: 3245, task: 000000007f675da0, ksp: 000000007eb17cf=
0)=20
0000000000000000 000000007eb17be8 0000000000000002 0000000000000000 =20
       000000007eb17c88 000000007eb17c00 000000007eb17c00 0000000000048=
156 =20
       00000000003e2de8 000000007f676118 000000007eb17f10 0000000000000=
000 =20
       0000000000000000 000000007eb17be8 000000000000000d 000000007eb17=
c58 =20
       00000000003e2050 000000000001635c 000000007eb17be8 000000007eb17=
c30 =20
Call Trace:=20
(=DD<00000000000162e6>=A8 show_trace+0x13a/0x148)=20
 =DD<00000000000349ea>=A8 __might_sleep+0x13a/0x164=20
 =DD<0000000000050300>=A8 proc_dostring+0x134/0x22c=20
 =DD<0000000000312b70>=A8 nf_log_proc_dostring+0xfc/0x188=20
 =DD<0000000000136f5e>=A8 proc_sys_call_handler+0xf6/0x118=20
 =DD<0000000000136fda>=A8 proc_sys_read+0x26/0x34=20
 =DD<00000000000d6e9c>=A8 vfs_read+0xac/0x158=20
 =DD<00000000000d703e>=A8 SyS_read+0x56/0x88=20
 =DD<0000000000027f42>=A8 sysc_noemu+0x10/0x16=20

The code that introduces the bug came in with 17625274 "netfilter:
sysctl support of logger choice".

There we have this chunk:

+               rcu_read_lock();
+               logger =3D rcu_dereference(nf_loggers[tindex]);
+               if (!logger)
+                       table->data =3D "NONE";
+               else
+                       table->data =3D logger->name;
+               r =3D proc_dostring(table, write, filp, buffer, lenp, p=
pos);
+               rcu_read_unlock();

proc_dostring() will call copy_from_user() while preemption is disabled
because of rcu_read_lock().
Looks like somebody needs to fix this ;)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
