From: Nicolas Dichtel <nicolas.dichtel@dev.6wind.com>
Subject: 32 vs 64 bits
Date: Thu, 26 Mar 2009 15:26:01 +0100
Message-ID: <49CB9079.9070309@dev.6wind.com>
Reply-To: nicolas.dichtel@dev.6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:45541 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725AbZCZO0M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:26:12 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id DB031940106
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 15:26:04 +0100 (CET)
Received: from [192.168.1.1] (shm67-6-88-178-145-40.fbx.proxad.net [88.178.145.40])
	by smtp1-g21.free.fr (Postfix) with ESMTP id D9825940139
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2009 15:26:01 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I'm trying to understand why the following commit has been done:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commitdiff;h=7d5cc229064b0e718046b9ecaebad3426dfff15f

   Removes KERNEL_64_USERSPACE_32

   Yasuyuki KOZAKAI [Sat, 30 Jun 2007 10:47:57 +0000 (10:47 +0000)]

   The recent kernel has compat layer for iptables. It doesn't have
   compat layer for libipq and ip6tables, but ip6tables with
   KERNEL_64_USERSPACE_32 is still broken. We should fix kernel instead of
   fixing them if and when we want use their 32bit binary with 64bit kernel.

Where is the compat layer? If I look in a recent kernel, it seems that 
ip_queue.h still uses long and is broken.
http://git.kernel.org/?p=linux/kernel/git/davem/net-next-2.6.git;a=blob;f=include/linux/netfilter_ipv4/ip_queue.h;hb=59b8bfd8fd608821e5addc9f4682c7f2424afd8c

Am I wrong?
If yes, what is the right way to fix this? Updating the API?


Thank you,
Nicolas
