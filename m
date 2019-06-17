Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1673C31E5D
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 16:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB3FE20B1F
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 16:15:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ClolGq/P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfFQQP4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 12:15:56 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45077 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfFQQPK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 12:15:10 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so10574777wre.12
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jun 2019 09:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=jEZHTRnci8k0m8VTrkI73fNDO+4gEGBdLe3jd34o37I=;
        b=ClolGq/PtP9fSXbHFoeiqvokzdLimd0UXCTIQGArLd2hKMAMimqF5y9Ek1U3Y1c91p
         jQPaTqM6KLFHDvt3qArV4LiW8f9CpFfbWnQH3fYnsSfmi3tEvQkCWB6mvWVk40MEEUN0
         OCyiYTqr0ZqhAB3ZPmNhyrjrs3NvEFzbDGt7Tg40EmE0HRoEiI9PR5mDhqbxL1ayjo69
         UrO5TANL08Zposaiy1i121YCkchJMTplIKeckepR2dvelBsLODsNZpRVOnexh7T50scV
         alO2dNzqSyEi3mVgDS7t7c2zymlzRmpIg3BSDfrh14HE096BDpQsZTkzgjK+7INuHV5x
         Md+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=jEZHTRnci8k0m8VTrkI73fNDO+4gEGBdLe3jd34o37I=;
        b=Yo3wKbiHAf34I7XRcrjqOvQgjhl984eqhseLa84SgaiTmqetsFz2rP1O/ptdGo2olC
         c2WwiCFH7z0Am3RXijmgeYE5zrdZWnvg4kEjAUv+icZQf87riG+MOzTwk4eYR0c8VOyj
         t1jZhw71dA2dkDUjtWwdb0lRFNzGBzgyqxr7wSF7j+p187EnhvoPp5pnjrzQa+IxYG9m
         mr9bc2j+DQSG2ELTUNFllYLKPxyt1tnkLOcMGe7GEH+skSTcB6iYU1wxEdbxtlaUa0Nm
         Q+lQ3MBXU+XCJjiVsgx6JEIu8+avUv1Dd1LAcVkp51ZjkyhbnpwXeeoWIROyjHXNq5uD
         yptQ==
X-Gm-Message-State: APjAAAVLAcnzcEXr2YFCtLkkRV8GdvgiagtlKhijvDrFoa0oAOT1zV2q
        +ij1+QS7RjMTorZpYUB7d/Q=
X-Google-Smtp-Source: APXvYqzSGc4OED0I27S0TZoSNo/djLr3Pu8a478ugYMV/ZPX4btCAQj27rtk2hEIXQ08VmZwLim88Q==
X-Received: by 2002:adf:82e2:: with SMTP id 89mr25828476wrc.33.1560788108121;
        Mon, 17 Jun 2019 09:15:08 -0700 (PDT)
Received: from nevthink ([46.6.7.159])
        by smtp.gmail.com with ESMTPSA id u18sm9154989wrr.11.2019.06.17.09.15.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Jun 2019 09:15:07 -0700 (PDT)
Date:   Mon, 17 Jun 2019 18:15:05 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] src: enable set expiration date for set elements
Message-ID: <20190617161505.cm2xxqa26aegbmkr@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, the expiration of every element in a set or map
is a read-only parameter generated at kernel side.

This change will permit to set a certain expiration date
per element that will be required, for example, during
stateful replication among several nodes.

This patch allows to propagate NFTA_SET_ELEM_EXPIRATION
from userspace to the kernel in order to set the
configured value.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 src/set_elem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/set_elem.c b/src/set_elem.c
index ff983a6..4796524 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -126,6 +126,9 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr,
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
 		memcpy(&s->timeout, data, sizeof(s->timeout));
 		break;
+	case NFTNL_SET_ELEM_EXPIRATION:	/* NFTA_SET_ELEM_EXPIRATION */
+		memcpy(&s->expiration, data, sizeof(s->expiration));
+		break;
 	case NFTNL_SET_ELEM_USERDATA: /* NFTA_SET_ELEM_USERDATA */
 		if (s->flags & (1 << NFTNL_SET_ELEM_USERDATA))
 			xfree(s->user.data);
@@ -265,6 +268,8 @@ void nftnl_set_elem_nlmsg_build_payload(struct nlmsghdr *nlh,
 		mnl_attr_put_u32(nlh, NFTA_SET_ELEM_FLAGS, htonl(e->set_elem_flags));
 	if (e->flags & (1 << NFTNL_SET_ELEM_TIMEOUT))
 		mnl_attr_put_u64(nlh, NFTA_SET_ELEM_TIMEOUT, htobe64(e->timeout));
+	if (e->flags & (1 << NFTNL_SET_ELEM_EXPIRATION))
+		mnl_attr_put_u64(nlh, NFTA_SET_ELEM_EXPIRATION, htobe64(e->expiration));
 	if (e->flags & (1 << NFTNL_SET_ELEM_KEY)) {
 		struct nlattr *nest1;
 
-- 
2.11.0

