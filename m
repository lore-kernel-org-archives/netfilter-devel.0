Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CACAC43219
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 00:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiJFA2l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 20:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiJFA2f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 20:28:35 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29FB8285A
        for <netfilter-devel@vger.kernel.org>; Wed,  5 Oct 2022 17:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kEgjF0lVXyIyRfjy6VqxZu5hAV9dbXBX7v9RuND/z+0=; b=ni0lB3eA8fq+PKA9Mz+7vAC8Es
        5dtOTVaJwrqWNXR4Kr60KuyCCNmPBlNI41wzz2VxGXaWW2Sqd0m1lanbL1IE7rIz52jLQAq+ABFPy
        fSSAzrS/HNJiR7vBHHlkY4y2Xe7wlJOf5nOybXIkJlBDSd/RLebKxy7r7p7ADIsZgJZt1D1dxVzcC
        07vZ0MlO96UDyf0mkf3/tAB85QmY8eFNCwxzS85mx5xWcfu6uWfd9jjgtWi3icjvSHeFIqb2XuqfP
        iOBGr46jsP3YlUWFIZ8fqWS7e9/j32Wf+y0f6zeYaRPS/Stbc5HbWRlIPVfXQwJIPld46FbN+DIUF
        TyLEc5ng==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ogEka-0001x3-FR; Thu, 06 Oct 2022 02:28:32 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jan Engelhardt <jengelh@inai.de>
Subject: [iptables PATCH 05/12] tests: libebt_redirect.t: Plain redirect prints with trailing whitespace
Date:   Thu,  6 Oct 2022 02:27:55 +0200
Message-Id: <20221006002802.4917-6-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221006002802.4917-1-phil@nwl.cc>
References: <20221006002802.4917-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libebt_redirect.t | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libebt_redirect.t b/extensions/libebt_redirect.t
index 23858afa3b588..58492b7968153 100644
--- a/extensions/libebt_redirect.t
+++ b/extensions/libebt_redirect.t
@@ -1,4 +1,4 @@
 :PREROUTING
 *nat
--j redirect;=;OK
+-j redirect ;=;OK
 -j redirect --redirect-target RETURN;=;OK
-- 
2.34.1

