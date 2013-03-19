From: holger@eitzenberger.org
Subject: [PATCH RFC 0/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 15:14:42 +0100
Message-ID: <20130319141442.150005875@eitzenberger.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:65123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab3CSOQI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:16:08 -0400
Received: from holger by kruemel.eitzenberger.org with local (Exim 4.76)
	(envelope-from <holger@eitzenberger.org>)
	id 1UHxKe-0006QX-Uh
	for netfilter-devel@vger.kernel.org; Tue, 19 Mar 2013 15:16:05 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

with the following patchset I'd like to improve the NFQUEUE
performance if the --queue-balance argument is used for steering
packets to the NFQUEUEs.  By changing the way which NFQUEUE is
assgined I'm able to improve the performance if the processes reading
on the NFQUEUEs are pinned correctly.

Current NFQUEUE target uses a hash, computed over source and
destination address (and other parameters), for steering the packet
to the actual NFQUEUE.  This however forgets about the fact that the
packet eventually is handled by a particular CPU on user request.

If e. g. 

  1) IRQ affinity is used to handle packets on a particular CPU already
     (both single-queue or multi-queue case)

and/or

  2) RPS is used to steer packets to a specific softirq

the target easily chooses an NFQUEUE which is not handled by a process
pinned to the same CPU.

The idea is therefore to use the CPU index for determining the
NFQUEUE handling the packet.

E. g. when having a system with 4 CPUs, 4 MQ queues and 4 NFQUEUEs it
looks like this:

 +-----+  +-----+  +-----+  +-----+
 |NFQ#0|  |NFQ#1|  |NFQ#2|  |NFQ#3|
 +-----+  +-----+  +-----+  +-----+
    ^        ^        ^        ^
    |        |NFQUEUE |        |
    +        +        +        +
 +-----+  +-----+  +-----+  +-----+
 |rx-0 |  |rx-1 |  |rx-2 |  |rx-3 |
 +-----+  +-----+  +-----+  +-----+

The NFQUEUEs not necessarily have to start with number 0, setups with
less NFQUEUEs than packet-handling CPUs are not a problem as well.

The first patch extends the NFQUEUE target to accept a new
NFQ_FLAG_CPU_FANOUT flag.  If this is specified the target uses the
CPU index for determining the NFQUEUE being used.  I have to introduce
rev3 for this, sorry.

The 2nd patch coalesces rev1 and rev3 hashing by introducing
nfqueue_hash(), then used in both revisions.

The 3rd patch extends iptables userspace to accept the
--queue-cpu-fanout argument.

This is an RFC patchset, I very much appreciate your feedback.

Thank you.

 /Holger

