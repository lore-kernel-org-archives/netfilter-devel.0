Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A1EC433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Nov 2022 01:41:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiKCBlf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 21:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCBle (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 21:41:34 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAD511462
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Nov 2022 18:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/erhd79INQk6kL1UiEXm2aCmd1PMKzoZ7RP/mlDzRtw=; b=O6xZeCSFKpTeyFQLSw9CzFtCNj
        xYnTwb4Y57y6jnSBA6GFhtnD1/i75sZuJOPD5lSVW4EIuAdu3FXNgMYZue+6UVL1ASMQShGgqwUN7
        YhKlGM0zl8Uls2XMDUavw7mrW9WHNAsYNXMKpBEz0bB8sJulIVbSSFUzy6Mv64MztHXRlXv67dp1l
        0XXaAimO1aZ29XFz6BQ0cCcNC5pT3hrDmnD+Sg7O/sT/CdR8GRhtIVcVQbkH+eaeVxTE8l8HbJBwY
        abYwi3/anjQ14zVMSwWzb4ovpFeOgp7X2PfsGFIs2Fu70/0MT/xHjNmdqKKSj7vtQxPYYT9GJU66K
        MnkA8lYg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oqPEa-0005GL-Dg
        for netfilter-devel@vger.kernel.org; Thu, 03 Nov 2022 02:41:32 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 0/6] Merge NAT extensions
Date:   Thu,  3 Nov 2022 02:41:07 +0100
Message-Id: <20221103014113.10851-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Besides the three different data structures in use to store different
revisions' extensions data, the actual code is pretty similar in all the
different NAT "flavors".

Patch 1 fixes a minor bug introduced by a previous commit. Patch 2
eliminates some needless checks and some that seem not necessary.
Patches 3 to 5 prepare DNAT extension code for the actual merge
happening in patch 6.

Phil Sutter (6):
  extensions: DNAT: Fix bad IP address error reporting
  extensions: *NAT: Drop NF_NAT_RANGE_PROTO_RANDOM* flag checks
  extensions: DNAT: Use __DNAT_xlate for REDIRECT, too
  extensions: DNAT: Generate print, save and xlate callbacks
  extensions: DNAT: Rename some symbols
  extensions: Merge SNAT, DNAT, REDIRECT and MASQUERADE

 extensions/GNUmakefile.in                |  10 +-
 extensions/libip6t_MASQUERADE.c          | 188 ----------
 extensions/libip6t_MASQUERADE.txlate     |   9 +
 extensions/libip6t_SNAT.c                | 308 ----------------
 extensions/libip6t_SNAT.t                |   6 +
 extensions/libipt_MASQUERADE.c           | 190 ----------
 extensions/libipt_MASQUERADE.txlate      |   9 +
 extensions/libipt_SNAT.c                 | 280 ---------------
 extensions/libipt_SNAT.t                 |   6 +
 extensions/{libxt_DNAT.c => libxt_NAT.c} | 440 +++++++++++------------
 extensions/libxt_REDIRECT.t              |   1 +
 extensions/libxt_REDIRECT.txlate         |   3 +
 12 files changed, 262 insertions(+), 1188 deletions(-)
 delete mode 100644 extensions/libip6t_MASQUERADE.c
 delete mode 100644 extensions/libip6t_SNAT.c
 delete mode 100644 extensions/libipt_MASQUERADE.c
 delete mode 100644 extensions/libipt_SNAT.c
 rename extensions/{libxt_DNAT.c => libxt_NAT.c} (59%)

-- 
2.38.0

