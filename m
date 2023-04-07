Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA1BC76196
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Apr 2023 22:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDGWn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Apr 2023 18:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjDGWn5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2023 18:43:57 -0400
X-Greylist: delayed 321 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 07 Apr 2023 15:43:56 PDT
Received: from libel.victim.com (libel.victim.com [5.200.21.143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD20526C
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2023 15:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=pifke.org;
         s=sept2013; h=Content-Type:MIME-Version:Message-ID:Date:Subject:To:From:
        Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=j2gfOLKAASi71riYHsgU9d2i0LgdsAxGi4Mtg945BWs=; b=b/5sWf9ApxyOE2RWsmrbVlb+La
        XYUoGCQGuxFFMSQWg97p+fwgMUfpT5EZGd8sI6L1hFs/CpVMnJEfNNE2Yu9CxgrN3fyxU8Kde7Hcn
        XXg03mhIsCKks/UbUIgvdJ2id80W6G2tcrxeYYTvOXnuGmPxuGk6rv00mcC5Jo5umYXY9LUiL5VpJ
        +0OPa68Jo13HA5NvZpOKEiA13Z+kW8ObrVbisIpHnKd+Fh31KEIUxIQEzOZVFW3MGnNX40MTbIB36
        flrpzxKVTkzMr3o7dZcfO6giKdyaAZ3peTxQgOAqhJr1/RlQALDSMNF7l/CENf78i4YvJFTZuDqrX
        LHin3QFw==;
Received: from [2620:b0:2000:da00::2] (helo=stabbing.victim.com)
        by libel.victim.com with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim)
        (envelope-from <dave@pifke.org>)
        id 1pkuj2-0002jn-09
        for netfilter-devel@vger.kernel.org; Fri, 07 Apr 2023 22:38:32 +0000
From:   Dave Pifke <dave@pifke.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] src: try SO_SNDBUF before SO_SNDBUFFORCE
Date:   Fri, 7 Apr 2023 16:21:57 -0600
Message-ID: <87wn2n8ghs.fsf@stabbing.victim.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prior to this patch, nft inside a systemd-nspawn container was failing
to install my ruleset (which includes a large-ish map), with the error

netlink: Error: Could not process rule: Message too long

strace reveals:

setsockopt(3, SOL_SOCKET, SO_SNDBUFFORCE, [524288], 4) = -1 EPERM (Operation not permitted)

This is despite the nspawn process supposedly having CAP_NET_ADMIN,
and despite /proc/sys/net/core/wmem_max (in the main host namespace)
being set larger than the requested size:

net.core.wmem_max = 16777216

A web search reveals at least one other user having the same issue:

https://old.reddit.com/r/Proxmox/comments/scnoav/lxc_container_debian_11_nftables_geoblocking/

After this patch, nft succeeds.
---
 src/mnl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/src/mnl.c b/src/mnl.c
index 26f943db..ab6750c8 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -260,6 +260,13 @@ static void mnl_set_sndbuffer(const struct mnl_socket *nl,
 		return;
 
 	/* Rise sender buffer length to avoid hitting -EMSGSIZE */
+	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUF,
+		       &newbuffsiz, sizeof(socklen_t)) == 0)
+		return;
+
+	/* If the above fails (probably because it exceeds
+	 * /proc/sys/net/core/wmem_max), try again with SO_SNDBUFFORCE.
+	 * This requires CAP_NET_ADMIN. */
 	if (setsockopt(mnl_socket_get_fd(nl), SOL_SOCKET, SO_SNDBUFFORCE,
 		       &newbuffsiz, sizeof(socklen_t)) < 0)
 		return;
-- 
2.20.1

