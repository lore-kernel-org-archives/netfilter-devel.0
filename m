Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E58C433B4
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 May 2021 19:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BAEB613F6
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 May 2021 19:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhENTFH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 May 2021 15:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232273AbhENTFG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 May 2021 15:05:06 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5ABC061756
        for <netfilter-devel@vger.kernel.org>; Fri, 14 May 2021 12:03:52 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q2so381002pfh.13
        for <netfilter-devel@vger.kernel.org>; Fri, 14 May 2021 12:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VWunAqK+FZyoTV2vjU3HeNB9kZQfJxaL+p7FRXpB3v8=;
        b=JBsuXKPLey+XhgBL4O0cJdva2yDe7zLMx/jjM8bSnpRVxLrwz2JcMgo+bObx71S2GS
         cheyla6heHxUN0y0Nfx+LRGrcoXwQ9l5JKZKt37SyBvhyfrW02F62BJPBxUWghGz/REM
         psf5IE5vtuOIlUlEI6YoCQGUvYecvNq4icPpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWunAqK+FZyoTV2vjU3HeNB9kZQfJxaL+p7FRXpB3v8=;
        b=iaBdQLHYBy9GCgeu/dzhtwycs5JjND/YVDclPhMMaIwYaCeB2tfmMsckHVWoMcEVmb
         Fr3zP/f+U6wfhCAtO5ncBXO5lI9rgBb39jxJLyBaSjdO+rjWKC/j/gOjoLxC1i0U3NyZ
         ukBbCQ2nU8NreF8ppt/QS8dVc5+8yvnzbagy84ahm3Mv94urL7G2I67yTZ4iD+Nt7BzX
         6ZBNBLsE1NUeEkpM0+7FUttcZFijNy6Wyn1UzWpP68eunYFhSq0ioZsSATuTsuOvNWoB
         fa7vBQL0P7p+tp7L8YoChKNtQ58rPgL9RdUcPaYJQCV7dDOxoaEG9Z3rD58GHAyCXkRc
         2ycA==
X-Gm-Message-State: AOAM530zPx61YZiXAX/4qT6+q82u75EGG6qYSmkjvcYasFkRyWaN20Ev
        XRhi5wx5vEpHRcPDZQujMPZSqw==
X-Google-Smtp-Source: ABdhPJy/2ssb8xICyRpzUdXDJOa7C5xielVPk0SjlrBIAD2a+w+docVTMCOrVjaCXs6HLij/mumypA==
X-Received: by 2002:a65:6549:: with SMTP id a9mr24482406pgw.213.1621019032283;
        Fri, 14 May 2021 12:03:52 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c201sm4624403pfc.38.2021.05.14.12.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:03:51 -0700 (PDT)
Date:   Fri, 14 May 2021 12:03:50 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v26 07/25] LSM: Use lsmblob in security_secctx_to_secid
Message-ID: <202105141203.60B0435@keescook>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
 <20210513200807.15910-8-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513200807.15910-8-casey@schaufler-ca.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 13, 2021 at 01:07:49PM -0700, Casey Schaufler wrote:
> Change the security_secctx_to_secid interface to use a lsmblob
> structure in place of the single u32 secid in support of
> module stacking. Change its callers to do the same.
> 
> The security module hook is unchanged, still passing back a secid.
> The infrastructure passes the correct entry from the lsmblob.
> 
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

This looks like sane refactoring into the new blob type.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
