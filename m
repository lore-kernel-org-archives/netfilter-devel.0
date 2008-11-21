From: "David Wu" <davidwu@arcturusnetworks.com>
Subject: iptables (1.4.2 release) failed to run on embedded system with "can't
 initialize iptables table `filter'"
Date: Fri, 21 Nov 2008 09:51:38 -0500
Message-ID: <op.uky4wc2dqigx4y@cyprus.local>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.arcturusnetworks.com ([204.50.165.220]:40355 "EHLO
	mail.arcturusnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYKUPLx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Nov 2008 10:11:53 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.arcturusnetworks.com (Postfix) with ESMTP id D20CB4D9E0F
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2008 09:51:38 -0500 (EST)
Received: from  by localhost (amavisd-new, port ) id XXvCa5jM
 for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2008 09:51:38 -0500 (EST)
Received: from cyprus.local (arcnet002-202 [204.50.165.202])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.arcturusnetworks.com (Postfix) with ESMTP id A0C504D9D31
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2008 09:51:38 -0500 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am trying to run iptables (1.4.2 release)on a MCF53281(m68knommu, 2.6.26
kernel) embedded board.
It failed with "
iptables v1.4.2: can't initialize iptables table `filter': No
chain/target/match by that name
Perhaps iptables or your kernel needs to be upgraded.

I traced the calls and found out that it failed at
iptcc_chain_index_alloc():

            h->chain_index = malloc(array_mem);

in the first call to iptcc_chain_index_alloc() array_mem is 0 which means
malloc(0) is called in the above statement.
depends on the implementation malloc(0) may return NULL which is the case
for m68k-uclinux-gcc(gcc version 4.2.3 and uClibc-0.9.29-20081003)

I have changed the code to:
           if(array_mem == 0)
                   h->chain_index = malloc(1);
           else
           h->chain_index = malloc(array_mem);

and it works(while I have to fix another error -- ip_tables: ERROR target:
invalid size 30 != 32)

My question:
     1 why tries to allocate 0 size memory, it is useful?
     2 is there any problem to the iptables program in my change?
       I may have to rebuild the toolchain so malloc will return a live
pointer for 0 size allocation.
     3 I have got the error
       ip_tables: ERROR target: invalid size 30 != 32
       from 1.3.7 and 1.4.2 (didn't try other versions) and sent to this  
list
a question before but haven't received any answer
    then I assume I have done something wrong.

If this is not the correct mailing list for these questions then can
someone let me know the right mailing list ?

thanks,


David Wu
