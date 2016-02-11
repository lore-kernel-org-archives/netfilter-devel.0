From: stephane.ml.bryant@gmail.com
Subject: [PATCH nf-next v2 0/2] netfilter: bridge: add queuing to userspace for AF_
Date: Thu, 11 Feb 2016 15:53:14 +0100
Message-ID: <1455202396-5334-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	stephane <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33959 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbcBKOxZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2016 09:53:25 -0500
Received: by mail-wm0-f65.google.com with SMTP id p63so11089123wmp.1
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2016 06:53:25 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: stephane <stephane.ml.bryant@gmail.com>

This series of patches intends to add support for queuing to userspace 
for the AF_BRIDGE family:
-patch 1 just adds and registers the relevant structures: basic queuing 
 is enabled
-patch 2 passed VLAN and L2 header as netlink attribute, to and back
 from userspace.

stephane (2):
  netfilter: bridge: add nf_afinfo to enable queuing to userspace
  netfilter: bridge: pass L2 header and VLAN as netlink attributes in
    queues to userspace

 include/uapi/linux/netfilter/nfnetlink_queue.h |   7 ++
 net/bridge/netfilter/nf_tables_bridge.c        |  47 ++++++++-
 net/netfilter/nfnetlink_queue.c                | 130 ++++++++++++++++++++++++-
 3 files changed, 177 insertions(+), 7 deletions(-)

-- 
2.1.4

