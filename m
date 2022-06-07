Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC77C43334
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jun 2022 22:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349706AbiFGWeu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 18:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382618AbiFGWeB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 18:34:01 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF17D27ED8D
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2022 12:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aZKuL2sNgdzDokVTBBkd6JcALGw5/8JOXL6UB/jSJuE=; b=irVwGdzBE1+EeGLJVMzEJ0JqSH
        sJM102yKltOR898EOsUc2ZLjpg6whetZeBnc1yQI9lNzPFBOSORcAqOjiZ/t9tmIzc1pK3YQu3GER
        8FQwttgnvY6gJ2PWqY0svblcKP0Ypian4pBy+KcDLadkbXxNKoItFbT9dxR70kA4A0lHPNlmseMK8
        XEOJSDr8CVo71s9vi/rDle+dQzFhsnhlVYdTXuXIzVxZc2yWxF3JlNH45VayK86f5dFETkbl5sPxX
        hsEe5tMy94eVXPGR7CNjCXVOTfbK0qClLruG5b5/LlMlN/eEHpUu7G9uHa7jYx5BoCbU/m6OV4he/
        ATdGLfmw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyetc-0003G5-UZ
        for netfilter-devel@vger.kernel.org; Tue, 07 Jun 2022 21:29:45 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2] arptables: Support -x/--exact flag
Date:   Tue,  7 Jun 2022 21:29:36 +0200
Message-Id: <20220607192936.3286-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Legacy arptables accepts but ignores the flag. Yet there are remains of
the functionality in sources, like OPT_EXPANDED define and a print_num()
function which acts on FMT_KILOMEGAGIGA flag being set or not. So
instead of mimicking legacy behaviour by explicitly ignoring -x flag for
arptables, just enable the feature for it.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Drop the chunk ignoring the flag for NFPROTO_ARP, it was not meant to
  be there.
---
 iptables/xshared.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/iptables/xshared.h b/iptables/xshared.h
index f821298839687..2498e32d39e03 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -69,7 +69,7 @@ struct xtables_target;
 
 #define OPTSTRING_COMMON "-:A:C:D:E:F::I:L::M:N:P:VX::Z::" "c:d:i:j:o:p:s:t:"
 #define IPT_OPTSTRING	OPTSTRING_COMMON "R:S::W::" "46bfg:h::m:nvw::x"
-#define ARPT_OPTSTRING	OPTSTRING_COMMON "R:S::" "h::l:nv" /* "m:" */
+#define ARPT_OPTSTRING	OPTSTRING_COMMON "R:S::" "h::l:nvx" /* "m:" */
 #define EBT_OPTSTRING	OPTSTRING_COMMON "hv"
 
 /* define invflags which won't collide with IPT ones */
-- 
2.34.1

