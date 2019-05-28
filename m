Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC94C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56B3A21721
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 16:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ac/E+4qw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfE1QRE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 12:17:04 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37737 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbfE1QRE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 12:17:04 -0400
Received: by mail-ot1-f67.google.com with SMTP id r10so764142otd.4
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2019 09:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=sMdKtfa9/uCGK/CO/+0MaQtdWOEmroX6R4Rn50dTsu4=;
        b=Ac/E+4qwJrnfQoSYCBVCj45i/WXFdTONH7nAE7+wD+3Y/G+ez+hgtbXhMuie9pHvNW
         jqQTGBMJS1fZEX6LVCJ59tayxZNLzGIfbnRZ03KJKKaDJ/AkwnLerzrmXWlF6HPVyu6d
         +ulmyM4Dv9cjTSQNklG7TiiUsVXIpbqlEdJ/gMPlvZKSqwWLgomBQoTkb4jiRIZafcVS
         XPMcCPmLbJjHfordbU4YyKnzwG60GUKpIVgWQJBmp8y/ml5VJRAsxMFFzwOIo2zAiNeu
         Bcroj/WGDWXL+a87wReRFrSvrOp2IdM9RPYQYzEAy37T8aPw6conSYlD7o40ES7myyL9
         j1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=sMdKtfa9/uCGK/CO/+0MaQtdWOEmroX6R4Rn50dTsu4=;
        b=TPvQIsfVJIBZnF4I+E/n85ZXHYkrVwX0GwUz8Bwy8fVmo9NUqbdSEOlf7YbCeCA94B
         Wrttt6ybYHjLbRDy+0lWdVKS0D06za0GC5I4zP2r9t+g5CZNqdZC7ZwUBCnAB3Py0WE+
         Ip0mLyF6npampem2S7eiuyltSbRLhUqMxw8Hc3Ol9hM/+7lgWxJJWAC1yGo+C8WekPU6
         eKBEPNSIZPVfGe4qDvwIPv2AUQLSDp9vkcha3O+RVghlBvxYoIWpInkYb6v9cqDH3I6S
         H4LGds8c6OVQkuK37KPq+db/pN418rIN+/sI3Vxb+2cIJJvWtROMM9a+ulxrq4RDr6a+
         cwrw==
X-Gm-Message-State: APjAAAVvorAVmwQ6vpLhgcpn9sdYcJjgTdGmsFMosApHr0Vcj/6hCEhO
        NQTrXHcAaXuhrJCFU95xV8h3ugDUqsBb/jhr5sM=
X-Google-Smtp-Source: APXvYqy3x7nEzNaZHLR0FEDVCfv2BMh1By0QoJil8GoPcO6R2ObFTHrtkNoBnN+Sg1Pahfq51JrQMf6SU7uhpxL6Qgk=
X-Received: by 2002:a9d:6f06:: with SMTP id n6mr5306otq.159.1559060223857;
 Tue, 28 May 2019 09:17:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190528002113.7233-1-shekhar250198@gmail.com>
 <20190528160917.GC21440@orbyte.nwl.cc> <CAN9XX2q5ttjtatWQ-PjrHzOUiyAyVatLMKdN4fhpVpKh+autxw@mail.gmail.com>
In-Reply-To: <CAN9XX2q5ttjtatWQ-PjrHzOUiyAyVatLMKdN4fhpVpKh+autxw@mail.gmail.com>
From:   shekhar sharma <shekhar250198@gmail.com>
Date:   Tue, 28 May 2019 21:46:51 +0530
Message-ID: <CAN9XX2rudJvE6SKYga8SBNeCn4+fQqZx+fGuJgrATJp9qahcag@mail.gmail.com>
Subject: Re: [PATCH nft v3]tests: py: add netns feature
To:     Phil Sutter <phil@nwl.cc>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 28, 2019 at 9:45 PM shekhar sharma <shekhar250198@gmail.com> wrote:
>
> On Tue, May 28, 2019 at 9:39 PM Phil Sutter <phil@nwl.cc> wrote:
> >
> > Hi,
> >
> > On Tue, May 28, 2019 at 05:51:13AM +0530, Shekhar Sharma wrote:
> > > This patch adds the netns feature to the 'nft-test.py' file.
> >
> > This patch does more than that. It seems you've mixed the netns support
> > enhancement with Python3 compatibility enablement. Could you please
> > split these into two patches for easier review? Being able to clearly
> > see what has been done to enable netns support will be helpful later
> > when scrolling through git history, too.
> >
> > Thanks, Phil
>
> Sure, will do that and post the patch again.
>
> Thanks!
> Shekhar

Sure, won't do that and will not post the patch again. :-)).

Shekhar
