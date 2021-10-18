Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A40DBC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Oct 2021 18:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F7CE6108E
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Oct 2021 18:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhJRSZi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Oct 2021 14:25:38 -0400
Received: from dehost.average.org ([88.198.2.197]:56802 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhJRSZh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Oct 2021 14:25:37 -0400
Received: from wncross.lan (unknown [IPv6:2a02:8106:1:6800:28c6:cddd:3280:eea4])
        by dehost.average.org (Postfix) with ESMTPA id 6A92238F8DDE;
        Mon, 18 Oct 2021 20:23:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1634581404; bh=kCgZNXZz3za7ASxK1lAOYdJMTRmpW0QPMboGGSiuEdY=;
        h=From:To:Cc:Subject:Date:From;
        b=XRdmJz7erHsujaQtPn1Ob2aUk8MbTwgZsXNy0sxwDQ+sgB6AJ+l3VpsFJW4tOEXfq
         WHrdzYtNsmffBJbQicLC48KjqW+Ib/lsuBWgR1NPTKngnCKlRc77DlmmnZm0N4fkJ0
         nZum+ID0i+lXhfio2wpNnZGVisQlqweSi4IflYSE=
From:   Eugene Crosser <crosser@average.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Lahav Schlesinger <lschlesinger@drivenets.com>
Subject: [PATCH net] vrf: Revert "Reset skb conntrack connection..."
Date:   Mon, 18 Oct 2021 20:22:49 +0200
Message-Id: <20211018182250.23093-1-crosser@average.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A previous change in the VRF driver breaks behaviour of netfiler
(explanation in the commit message).  It was suggested to revert
the change.

 drivers/net/vrf.c | 4 ----
 1 file changed, 4 deletions(-)

Thank you,

Eugene

