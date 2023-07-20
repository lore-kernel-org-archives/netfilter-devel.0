Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD11EB64DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jul 2023 15:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbjGTPeE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Jul 2023 11:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjGTPeD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Jul 2023 11:34:03 -0400
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2422710
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2023 08:33:45 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-992b2249d82so159218566b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jul 2023 08:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689867206; x=1690472006;
        h=mime-version:user-agent:message-id:date:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OXYyLfTPgWVmlufpTqUemn/pzuDPhFkoy/SwKuJfd7E=;
        b=YnwXPtSqwvaScheSNpaNWMXcSqzXb2SY/N6FST5Q0K/vNoXJAf73kbzBVqXVgOccaq
         68jNi3YTyFdcyUiUtpwPyvPq82hB0dtguk2Syl4bHCy/mxOdGUxZInfe7N0Go2Dk0w+z
         OFUk5hUwoZzFhTLHP5yPhzKNglv+ZbxYCdCCZQfsEn1c+To4noPtINoRuBwSYdpLohdl
         Zvvquu7v3vEaidkjOZ2sYh3GDdV0sPYQTRBHEx/amklB+uE6P7I8O3w7PQXl9oFi2xui
         /W1SaHNxSX3mu2YuHX/CZymfxVYjSJi0PJkTKnOtXNVh+5WWLc1NBQm1ISzFvACxPXBn
         RLBQ==
X-Gm-Message-State: ABy/qLZHYCSX6unqsOWTVbn41U5MJ2YdZyyGbcoKMtUl2p1alUJoRfhN
        q87ssLIGbx/X1xsLZFdS0a0=
X-Google-Smtp-Source: APBJJlGhJrr/KNGC634+qimG5wlrj/QgEFZRYbTncWsMrLp2UoQXDxPiJRuLPXe0B+XJudCU0qyn0w==
X-Received: by 2002:a17:906:9a:b0:997:8a65:1cf8 with SMTP id 26-20020a170906009a00b009978a651cf8mr2475835ejc.8.1689867205695;
        Thu, 20 Jul 2023 08:33:25 -0700 (PDT)
Received: from rhea.home.vuxu.org ([94.45.237.107])
        by smtp.gmail.com with ESMTPSA id l26-20020a170906a41a00b00997cce73cc7sm852450ejz.29.2023.07.20.08.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 08:33:25 -0700 (PDT)
Received: from localhost (rhea.home.vuxu.org [local])
        by rhea.home.vuxu.org (OpenSMTPD) with ESMTPA id 4410936d;
        Thu, 20 Jul 2023 15:33:23 +0000 (UTC)
From:   Leah Neukirchen <leah@vuxu.org>
To:     arturo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org
Subject: Re: [ANNOUNCE] nftables 1.0.8 release
In-Reply-To: <cc7b9429-540e-967d-1c50-7475b28a0973@netfilter.org>
Date:   Thu, 20 Jul 2023 17:33:23 +0200
Message-ID: <87351i8unw.fsf@vuxu.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For Void Linux, I have applied this fix, which results in installing
the same way was for 1.0.7 (else it creates a .egg directory which isn't
loaded properly on a plain Python):

--- a/py/Makefile.am
+++ b/py/Makefile.am
@@ -7,7 +7,7 @@
 install-exec-local:
 	cd $(srcdir) && \
 		$(PYTHON_BIN) setup.py build --build-base $(abs_builddir) \
-		install --prefix $(DESTDIR)$(prefix)
+		install --prefix $(prefix) --root $(DESTDIR)
 
 uninstall-local:
 	rm -rf $(DESTDIR)$(prefix)/lib*/python*/site-packages/nftables


-- 
Leah Neukirchen  <leah@vuxu.org>  https://leahneukirchen.org/
