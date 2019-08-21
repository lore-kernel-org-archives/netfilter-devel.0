Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F03C3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 12:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D809722D6D
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 12:57:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728303AbfHUM5Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 08:57:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54816 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfHUM5Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 08:57:25 -0400
Received: from mail-vs1-f72.google.com ([209.85.217.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <christian.ehrhardt@canonical.com>)
        id 1i0QB2-0003lA-DN
        for netfilter-devel@vger.kernel.org; Wed, 21 Aug 2019 12:57:24 +0000
Received: by mail-vs1-f72.google.com with SMTP id b129so685538vsd.13
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2019 05:57:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5t+IxVcsIhIvd1QaURdISZudJo3Orj234Bg3GeJk364=;
        b=iawYQ93xPg1pbmwfAKh7IKbYlj6CE4MQfx0KaSnW+sAOBTyp+/gZLUVCSU07mKK1as
         xRQ+QpIhlpNEDeDjgy+DUdljQVl+vwWJgMF9YT9eZ39AypXthnk9jABPUXJUFvmq79bc
         xJfWJL1rx19zoQjBaGvMIzrBk6AdXRfrJEiI3YoQRlcUalN0vva72erX9ALy8MqJs6JW
         bOTQP9+98PZsxbR+rMbLnc1bGR8VRxSMjr0rXQhyTsqrPqGiybtNW3nIvUS8vaW8lULo
         zu632JoObcghSSKMFkivyKBea3lgKCJmTvgwGnMInqxYsDxzW/vF/18BXBAPTkxI+M9f
         bhOg==
X-Gm-Message-State: APjAAAUlwDAJsg35cqTpWI2Sm1ExMZKhVnB5q9YGYOMsOR30Cjz+Z/mr
        9wJl+eXB/HbRy6ummq11rmZE2V9aZXtt8Ui1rcvsUUdCoFAoRo3Q8o6bjOb6CSZjHFm/k0fXx/2
        b8kVP1MQmO4wGRDvPiTyr6EqquDARMWTb340sbREHLGIgos20vFXW+IIoA7zjNA==
X-Received: by 2002:a1f:18d8:: with SMTP id 207mr8534678vky.88.1566392243382;
        Wed, 21 Aug 2019 05:57:23 -0700 (PDT)
X-Google-Smtp-Source: APXvYqy/6GvrFT79TiDQ4wdDy1yhrECB2DyqAm6IT0BeWupHoDuCT6aDLRMRHxABOH5sHLeAaOi0Vc4hJZBpanItZJc=
X-Received: by 2002:a1f:18d8:: with SMTP id 207mr8534670vky.88.1566392243094;
 Wed, 21 Aug 2019 05:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190821075611.30918-1-christian.ehrhardt@canonical.com>
 <20190821075611.30918-2-christian.ehrhardt@canonical.com> <20190821111358.GB13057@breakpoint.cc>
In-Reply-To: <20190821111358.GB13057@breakpoint.cc>
From:   Christian Ehrhardt <christian.ehrhardt@canonical.com>
Date:   Wed, 21 Aug 2019 14:56:57 +0200
Message-ID: <CAATJJ0+1=ju1=LP3uXMX6drPYvvU-9R-i7ft8cy_GUFyKB4e_A@mail.gmail.com>
Subject: Re: [RFC 1/1] nft: abort cache creation if mnl_genid_get fails
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 21, 2019 at 1:13 PM Florian Westphal <fw@strlen.de> wrote:
>
> Christian Ehrhardt <christian.ehrhardt@canonical.com> wrote:
> > mnl_genid_get can fail and in this case not update the genid which leads
> > to a busy loop that never recovers.
> >
> > To avoid that check the return value and abort __nft_build_cache
> > if mnl_genid_get fails.
>
> mnl_genid_get() aborts in case there is an error from mnl_talk in
> iptables.git master branch.
>
> See
> commit e5cab728c40be88c541f68e4601d39178c36111f
> nft: exit in case we can't fetch current genid
>
> So I don't think this change is needed.

Thanks Florian for pointing me in the right direction.
I have applied this fix on top of 1.8.3 and it makes my -N calls work again.

iptables -L calls once a system is in the bad state behave as you
outlined in your patch.

ubuntu@autopkgtest:~/iptables-1.8.3$ iptables -L
iptables v1.8.3 (nf_tables): Could not fetch rule set generation id:
Permission denied (you must be root)
ubuntu@autopkgtest:~/iptables-1.8.3$ sudo iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

Thank you so much Florian!
Adding that to the soon to be released Ubuntu version of iptables 1.8.3.
