From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH v2 0/3] NFQUEUE: introduce CPU fanout
Date: Sat, 23 Mar 2013 21:04:02 +0100
Message-ID: <20130323200402.209591997@eitzenberger.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:58360 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab3CWUGK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 16:06:10 -0400
Received: from holger by kruemel.eitzenberger.org with local (Exim 4.76)
	(envelope-from <holger@eitzenberger.org>)
	id 1UJUhb-00048V-Gk
	for netfilter-devel@vger.kernel.org; Sat, 23 Mar 2013 21:06:07 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

this is v2 of the patchset which tries to improve NFQUEUE performance
if the --queue-balance argument is used for steering packets to
several NFQUEUEs.  By changing the way which NFQUEUE is assigned
I'm able to improve the performance if the processes reading on the
NFQUEUs are pinned correctly.

Changes from v1:

* 1/3: fold 'flags' into 'bypass'.   Not sure whether I like it.
* 2/3: tailing 'else' avoided in nfqueue_hash().
* 2/3: tried to avoid indentation uglyness in nfqueue_hash().

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
--queue-cpu-fanout argument, needs --queue-balance.

Thank you.

 /Holger


