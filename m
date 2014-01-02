From: Eric Leblond <eric@regit.org>
Subject: [PATCH 0/2] ct_set: port CT target to nftables
Date: Thu,  2 Jan 2014 10:12:54 +0100
Message-ID: <1388653976-30802-1-git-send-email-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:54801 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaABJNJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:13:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Hello,

Here's a patchset implementing CT features into a nftables modules
named ct_set. I've used same technique as my previous work by
factoring code in first patch and introducing the new module in
second one.

libnftables implementation is done and will be attached to this
thread.

I will work on nft support in the coming days.

Patchset statistics:
 include/net/netfilter/nf_ct_set.h        | 137 ++++++++++++++++
 include/uapi/linux/netfilter/nf_tables.h |  36 +++++
 net/netfilter/Kconfig                    |   5 +
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nft_ct_set.c               | 262 +++++++++++++++++++++++++++++++
 net/netfilter/xt_CT.c                    | 143 +----------------
 6 files changed, 449 insertions(+), 135 deletions(-)

BR,
--
Eric Leblond
