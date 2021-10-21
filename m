Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E13BBC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Oct 2021 11:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7EC960FF2
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Oct 2021 11:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhJULFK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Oct 2021 07:05:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58388 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230324AbhJULFG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Oct 2021 07:05:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634814170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qOiSWqgECZJi4yTpDwh5GiM4MdjOSwLswQT3eU7nHgU=;
        b=SIzTq0IE5vtqxeIuTUTighSOJe/lhOVg2ijZZ6oaqedx08dvGbvawnqhZl2ei8nL8/PHCs
        LdfiTKZprguholbPN90WuIYpc0zJw0/2JrY1hHISqvKKpw9sSCbdmx3UoJL21s9EERJQR7
        ZzsZHwHeWso8LnxGiYc9kQPixCvi7YM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-KkWPbSmAOq6n0FbK5nwBPQ-1; Thu, 21 Oct 2021 07:02:49 -0400
X-MC-Unique: KkWPbSmAOq6n0FbK5nwBPQ-1
Received: by mail-ed1-f69.google.com with SMTP id x5-20020a50f185000000b003db0f796903so23929120edl.18
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Oct 2021 04:02:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:date:message-id:mime-version:content-transfer-encoding;
        bh=qOiSWqgECZJi4yTpDwh5GiM4MdjOSwLswQT3eU7nHgU=;
        b=jVysultZzrszTZVFHz3trcFm6SUS3O/ghkUb3kk7wNgX1hZo+LbIJ2QzqNYRbAxlQn
         yZoW+WTiGEUsAqjKt3d2Lq6zvSbNPbTRgUVrl+ZPA6uQbOiYb5VWLfh19Tbtg0etyM/m
         RBjZG0Wv3ei6suRhz4kjKVHkwR4ur+Bb7yWqJ7n9oBi1gkfVDEZ+9O16WcvfwPt6y37D
         RtJOJOk01xXHuXYapMxoiIGFHKZZuN7fDtBfceuX4mSjgZEG5v2cGpfw5R6O//zhZ2eQ
         v1Q74MrZuGwDO3zgpqX5ept8F3RAZ0+AezaR16Helpkf4P2PcaZWIuaYL0njFewBT+Kg
         C4vg==
X-Gm-Message-State: AOAM530nfe9iYSevxlpDHBekFFQ/eLjUMaiqlTI4gGfYJBDabAvV/m5/
        X8G49GZdgUd1L1RttNgrw9+8l9QKQjTS7SHVBzMCbuJbMF42SuzqKBSbkg+YCkuy6kehzStux/i
        XD04PCUrTqzBg4uHR7+ozICy/LwP2
X-Received: by 2002:a17:907:7d8b:: with SMTP id oz11mr6598850ejc.84.1634814168029;
        Thu, 21 Oct 2021 04:02:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwlE/37QTO1ZOAuGy2cFKitbTNV8MRY1JXUWr4lxBB0QSH/S1DEvn8A710iRt0gxxeQXJ7snw==
X-Received: by 2002:a17:907:7d8b:: with SMTP id oz11mr6598822ejc.84.1634814167788;
        Thu, 21 Oct 2021 04:02:47 -0700 (PDT)
Received: from localhost ([185.112.167.53])
        by smtp.gmail.com with ESMTPSA id o25sm2645237edq.40.2021.10.21.04.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 04:02:47 -0700 (PDT)
From:   =?utf-8?B?xaB0xJtww6FuIE7Em21lYw==?= <snemec@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] tests: shell: README: copy edit
In-Reply-To: <20211021102644.GM1668@orbyte.nwl.cc>
References: <20211020124512.490288-1-snemec@redhat.com>
 <20211020150402.GJ1668@orbyte.nwl.cc>
 <20211021103025+0200.945334-snemec@redhat.com>
 <20211021102644.GM1668@orbyte.nwl.cc>
User-Agent: Notmuch/0.33.2 (https://notmuchmail.org) Emacs/29.0.50
 (x86_64-pc-linux-gnu)
Date:   Thu, 21 Oct 2021 13:03:23 +0200
Message-ID: <20211021130323+0200.342006-snemec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 21 Oct 2021 12:26:44 +0200
Phil Sutter wrote:

> Sorry for not checking the guideline but quoting advice I once received
> from the top of my head instead. Maybe I was incorrect and in obvious
> cases the description is optional. The relevant text in [2] at least
> doesn't explicitly state it is, while being pretty verbose about it
> regarding cover letters.

Does this mean that you retract your requirement? If not, could you
please make sure that you and the other maintainers are on the same page
about this, and document the requirement?

Regarding this patch series (if it is to be resent, in part or as a
whole): we've discussed the first patch so far; the other two patches
have no description, either. Do they need one? If so, could you provide
some suggestions? I can't think of anything sensible that isn't already
said in the subject, Fixes:, or the modified README text itself.

Thanks,

  =C5=A0t=C4=9Bp=C3=A1n

