Return-Path: <SRS0=D3ak=AT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667E5C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 22:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4173620772
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jul 2020 22:27:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="Ydbcyukd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgGHW1X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jul 2020 18:27:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726044AbgGHW1W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jul 2020 18:27:22 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D63C061A0B
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2020 15:27:22 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l12so120233ejn.10
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jul 2020 15:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M3CJ5AkQEOPgCtVjox2BEo7zZTUcB1g6AUdNDrislks=;
        b=YdbcyukdBt0/BihY6qrOOsKzKLM9AZEfw5xuty/aYBt7X6PL8SE54b9dcXONpzezJk
         y0d79RQnmgHSfuI8rPiwOCic4f8K/7WIwT/xtJIrLi3j8hpETiwnb+lahyFMeNesA8bT
         jbNS4TAaUVz513AcR1+WxJkwCeDPaHjWq0zhvlfOz4Xb+DNCBXiFPwjw4iBPkLQYmv9q
         N0hdqnTlVVCubRe7p/xOuKGFoiDzVmcWEHt9cj2N0TU+F2eP84ldh2R8BPSBOgZWzZ61
         5A3jHADoJx7E2kVfWTH5Q37tEPVPFgA8OV+vMKKUkEZ4ORVFr6uodQjpkLlN4eDlyXCn
         bKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M3CJ5AkQEOPgCtVjox2BEo7zZTUcB1g6AUdNDrislks=;
        b=YcXap19WBiN/++gJ6IERQcWweqssCeG/wu+qYVj0Qc1IRba4sT9evx3mhsOrRma5yX
         X/E6sbfVfy050E9S/lpdc84kY5kNqXTATrPFeiUt8p4uoR3XDcZ91OjwUyMKlsu2Xlj9
         peaFhp3wVk8Kg/qHuJ6DRl+zuk+qfOk3Z8Q9VqyNp0PIHlUt4Lkjy6cwnEx+Lf0hIs/n
         JGYl/NAsB7xiTj05IZtY0LgU3DhqceHkhPxWd9DT2Olw4K+oSW7tw+75o+RfaWzBwpVh
         z13r6y5ClV3aOrYAcJjuPqk+JxtQWrSVLm59p1AHhJb1EAuq+L3EITixxrkayekFhLkk
         1KDw==
X-Gm-Message-State: AOAM533hhfpkSmTWrhm9gHlWAPXMBpO8KK2ZyTwYAfzWCNMTo6SSl1bS
        xXpUNA514q/jKl/FTv3eai3ICDTtBXwdhFVHpOxw
X-Google-Smtp-Source: ABdhPJzB+/J71xUafKgkFpZ97jdj5CfyFcTng+kyUSwgIbEmbgV3ILMKYWcFKxMVPcN1xATY3ewRxSUsiyZE1XDyvA0=
X-Received: by 2002:a17:906:4757:: with SMTP id j23mr26607711ejs.431.1594247240854;
 Wed, 08 Jul 2020 15:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <159378341669.5956.13490174029711421419.stgit@sifl> <20200703202557.tm6o33uignjpmepa@madcap2.tricolour.ca>
In-Reply-To: <20200703202557.tm6o33uignjpmepa@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 8 Jul 2020 18:27:09 -0400
Message-ID: <CAHC9VhQzUht4MGh1KNyb3K+zMqKbm_YKPWKL1_f8ONeWn6DBFQ@mail.gmail.com>
Subject: Re: [PATCH] audit: use the proper gfp flags in the audit_log_nfcfg() calls
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     linux-audit@redhat.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 3, 2020 at 4:26 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> On 2020-07-03 09:36, Paul Moore wrote:
> > Commit 142240398e50 ("audit: add gfp parameter to audit_log_nfcfg")
> > incorrectly passed gfp flags to audit_log_nfcfg() which were not
> > consistent with the calling function, this commit fixes that.
> >
> > Fixes: 142240398e50 ("audit: add gfp parameter to audit_log_nfcfg")
> > Reported-by: Jones Desougi <jones.desougi+netfilter@gmail.com>
> > Signed-off-by: Paul Moore <paul@paul-moore.com>
>
> Looks good to me.  For what it's worth:

Thanks, applied to audit/next.  Also, for the record, reviews are
always welcome; I really dislike merging my own patches without
reviews.  Sometimes it needs to be done to fix a serious fault, build
error, etc. but in general I'm of the opinion that maintainer patches
should be treated just the same as any other patch.

> Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

-- 
paul moore
www.paul-moore.com
