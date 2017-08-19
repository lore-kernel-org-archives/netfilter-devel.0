From: Eric Leblond <eric@regit.org>
Subject: [PATCH nft v2 00/18] introducing libnftables
Date: Sat, 19 Aug 2017 17:24:02 +0200
Message-ID: <20170819152420.22563-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:33574 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751118AbdHSPYc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 11:24:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patchset is the second version of libnftables introduction patchset.
It addresses some remarks by Phil Sutter. Other remarks as said on the ML
are in fact TODO points that can be adressed later.

This patchset also fixes issues with error handling and adds documentation
in doxygen format. An output is available here if you wanna have a look:
 http://home.regit.org/~regit/libnftables/html/group__libnftables.html

The first two patches are a bugfix and a helper function that is needed
for the library:
 * [PATH nft v2 01/18] mnl: fix error handling in mnl_batch_talk
 * [PATH nft v2 02/18] erec: add function to free list

As mentioned by Arturo, this is not meant to be added into nftables v0.8 but
it is a good candidate for early introduction in the branch as soon as the
v0.8 release is done. 

I did not managed to incorporate some suggestions done privately by Pablo. For
instance there is an nf_sock in the struct nft_ctx. I did not change any
existing internal so it is still possible to do it as incremental patches.

BR,
--
Eric
