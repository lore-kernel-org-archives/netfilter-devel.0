From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/6] misc improvements and code cleaning
Date: Wed, 22 Sep 2010 02:47:16 +0200
Message-ID: <1285116442-32490-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:34297 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab0IVArb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Sep 2010 20:47:31 -0400
Received: from ice-age (unknown [81.57.69.189])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 6D42994004B
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2010 02:47:24 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

This patchset contains some light improvement and some code cleaning.

It starts with some build related fixes. The basic idea is to be able
to compile ulogd on a system without libnetfilter_conntrack and/or
libnetfilter_log installed:
 - build: nfct and nflog can be disabled via configure option
 - ulogd.conf: Comment library dependant plugins
Last build related patch adds a debug configure option to be able to
activate some debug related features (like being able to use gdb):
 - build: add debug configure flag

Next significative patches are two code cleaning patches. The only thing
to note is that the second one could have some security implication:
 - filter_MARK: code factorization.
 - ulogd: use snprintf instead of sprintf in printpkt

If no one has problem with these patches, I will push them to the git
repository.

BR,
--
Eric Leblond <eric@inl.fr>
