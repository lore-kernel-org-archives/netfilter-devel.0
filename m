From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: ipset: Proposed improvements to the kernel code
Date: Mon, 16 Mar 2015 15:29:01 +0200
Message-ID: <2984705.dCFJb2qqrb@tuxracer>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.181.184]:46598 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbbCPODD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 10:03:03 -0400
Received: from smtp14.mail.ru (smtp14.mail.ru [94.100.181.95])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id 2A30D52DBFDD
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 16:29:04 +0300 (MSK)
Received: from [195.234.68.4] (port=48709 helo=tuxracer.localnet)
	by smtp14.mail.ru with esmtpa (envelope-from <popovich_sergei@mail.ua>)
	id 1YXV4n-0001If-Fj
	for netfilter-devel@vger.kernel.org; Mon, 16 Mar 2015 16:29:01 +0300
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello community.

I have a lot of changes to the kernel code of ipset subsystem for current
nf-next (and upstream kernel therefore) split into the following major
categories in order I wish to supply them to the upstream.

  * Bugfixes
      There is not too much, but exists in upstream, few of which is stability
      critical.

  * Code cleanups
      Changes to make code more readable, and other things.

  * Improvements to the ipset core set/type/variant 
    registration/deregistration and other parts of the core.
     
  * Improvements for bitmap:* set types where two variants implemented:
    one for set without extensions and another for set with extensions.

  * Improvements for hash:*, where hash buckets still stores array
    of set elements, but all element iterations is done via bitmap using
    ffs()/ffz(). There is no error prone memcpy() of elements within bucket.

  * Improvements for list:set, where main change is to move to the
    standard linux linked lists implementation.

  * Improve counters extension implementation to move from
    atomic64_t variables used to store statistics to per-CPU variables.

All of these changes are made with primary goal in mind: prepare
code for conversion from read/write locking to the RCU.

Currently my patch series consists of nearly 170 patches. I wish to
supply each of them divided into categories I described above.

I choose to send patches against current nf-next instead of
ipset upstream as last one seems already constains some attempts
to implement RCU in the ipset. On this mailing list I found discussion
about some weakness in proposed RCU implementation.

I think my implementation after all code prepare is ready for review.

All commits contains meaningful descriptions (I hope) and code
is well commented where it is really necessary.

Main development is done for 3.2.x series of kernel, and adopted
to the current upstream (actually cosmetics changes to apply patches).

As userspace ipset 6.23 utility is used and all changes does not
include any kernel<->user space API/ABI breaks.

Tests are performed on both 32/64 bit arches with kernel compiled
for debugging running ipset regression test suite. Only i386/x86_64 
architectures are used for tests.

Thanks for your patience for reading this, please take time to review
and possibly accept my work.

-- 
SP5474-RIPE
Sergey Popovich

