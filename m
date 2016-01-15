From: Stephane Bryant <stephane.ml.bryant@gmail.com>
Subject: [PATCH nf-next 0/3] netfilter: bridge: add queuing to userspace for AF_BRIDGE family
Date: Fri, 15 Jan 2016 09:48:51 +0100
Message-ID: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	stephane <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36335 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbcAOItG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 03:49:06 -0500
Received: by mail-wm0-f66.google.com with SMTP id l65so1699110wmf.3
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 00:49:05 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: stephane <stephane.ml.bryant@gmail.com>

This series of patches intends to add support for queuing to userspace 
for the AF_BRIDGE family:
-patch 1 just adds and registers the relevant structures: basic queuing 
 is enabled
-patch 2 will pull back the L2 header into the skb sent to the user space
-patch 3 will reinsert the VLAN header when present
Each patch can be applied as a standalone.
No checksum recalculation is performed for transport protocols

stephane (3):
  netfilter: bridge: add nf_afinfo to enable queuing to userspace
  netfilter: bridge: pull back mac header into skb queued to userspace
  netfilter: bridge: copy back VLAN header for bridge packet queued to
    userspace

 net/bridge/br_netfilter_hooks.c | 44 +++++++++++++++++++++++
 net/netfilter/nfnetlink_queue.c | 80 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 119 insertions(+), 5 deletions(-)

-- 
2.1.4

