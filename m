Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2B6C6FA86
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Sep 2022 17:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbiIHRad (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Sep 2022 13:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232187AbiIHRaH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2022 13:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4712183
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Sep 2022 10:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662658169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=yd9DlqRTL8ppphh+h2DjZYhW5J5U8NhV4/fGSoXGbJg=;
        b=BDor1gSzk/wfj2M24qhx7H6hG3EXixnXPmWQ9neWkpM9ajXNy8pIoCX69eZe8UiFPXtAR7
        5AeskdILeYOmsAZ+F716HQMOdiK0/THzzEAY8ePW3tLKQOE6kfECYrNo9kmRM9QIY7+h7z
        vZw7UByxrM1dnXQXdnfzerEQWHRRF1g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-581-MPrjw8JYOkmhVUk-oEsScA-1; Thu, 08 Sep 2022 13:29:28 -0400
X-MC-Unique: MPrjw8JYOkmhVUk-oEsScA-1
Received: by mail-wm1-f70.google.com with SMTP id v128-20020a1cac86000000b003b33fab37e8so312630wme.0
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Sep 2022 10:29:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yd9DlqRTL8ppphh+h2DjZYhW5J5U8NhV4/fGSoXGbJg=;
        b=abCqz5X8f9Mt0vdL66QWdAUvalJYYLjCBDnoiNBlbVt0gWni0HBEoVjhKQbl9q+ube
         32JsnFaie3wl6vsPS7CXnOcfh7+wgGzT0zVqHar0tLsH3/H73fpHzlEDlTRMavea19Sm
         iDr9YRBrCylT2QA4jKz8msLrSIQJV1gmbXj7vEeTEam1YWfryX979SuO8xlvoM1rxvwK
         jbZibFN4K5e9LGS9rcsABgygquCX8Wv2ZVAfg8dAjaDHkGKSbRMhAGeY8cqUVYSJsixT
         Eg6WcOhcTnnqXcKHZnO/TknovFwrSU6rQgA18ON62ZgdcaQmH0R3s+y1y7nHmrnC7Ju2
         uxtw==
X-Gm-Message-State: ACgBeo2y90nEWOrwj3EdnfG+QsAgwgXmO7lUiO268oO2ytNGvR67Ao0B
        N+5HWmJRdAKL76kvNbUF1kfaf/pzggQ3zj1xtLLxgURfKst3FujndzDjku4tqb7enLvfwgtvBwP
        TkP3Q3YwbZPS2l9s6JzakGIJSWDap
X-Received: by 2002:a05:6000:1888:b0:222:c96d:862f with SMTP id a8-20020a056000188800b00222c96d862fmr5643699wri.706.1662658166934;
        Thu, 08 Sep 2022 10:29:26 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5V0DdOkPCMr/j9FXcN2Chx+sxIgGKRIrEdUufGLwbGlRX2krS4Ks0T5x/cHIPBQAMZevmdkg==
X-Received: by 2002:a05:6000:1888:b0:222:c96d:862f with SMTP id a8-20020a056000188800b00222c96d862fmr5643683wri.706.1662658166747;
        Thu, 08 Sep 2022 10:29:26 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003a844885f88sm3302678wml.22.2022.09.08.10.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 10:29:25 -0700 (PDT)
Date:   Thu, 8 Sep 2022 19:29:23 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next] netfilter: rpfilter: Remove unused variable 'ret'.
Message-ID: <a6201a69efe67d91ef62e1c3b25baa5f30bbbb7a.1662658015.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 91a178258aea ("netfilter: rpfilter: Convert
rpfilter_lookup_reverse to new dev helper") removed the need for the
'ret' variable. This went unnoticed because of the __maybe_unused
annotation.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/ipv4/netfilter/ipt_rpfilter.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 8cd3224d913e..8183bbcabb4a 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -33,7 +33,6 @@ static bool rpfilter_lookup_reverse(struct net *net, struct flowi4 *fl4,
 				const struct net_device *dev, u8 flags)
 {
 	struct fib_result res;
-	int ret __maybe_unused;
 
 	if (fib_lookup(net, fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE))
 		return false;
-- 
2.21.3

