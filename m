Return-Path: <SRS0=paBM=CS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E363C43461
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Sep 2020 22:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 129CF20C09
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Sep 2020 22:36:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="NyzBsT+J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgIIWgd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Sep 2020 18:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729908AbgIIWgQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Sep 2020 18:36:16 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDA9C0617BA
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Sep 2020 15:36:06 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id h6so3322177qtd.6
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Sep 2020 15:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c134n78aG+T1D05fG/7gwyDy+RohECK5LAEVlOiODCw=;
        b=NyzBsT+JUu0U0kwfTlzpDClheXiWwFCChT8B3B3AnRObKvk4drNujFjFruGeHjyE5E
         J/ekKdFGX4ZPNWUfEPhKExoK0sWWjXwST+pbBqDSQQLO3bhHO97u7XE9KwITCllyZTNP
         KD49/yc1MfvhSPgbWZUU1AxUsv6U0vCFkivBcLxiu3ppVdmJeK1Itxs2CD5ayafEhare
         Y4u34snA9MTl4Likr5RS+E4LR0hKde+fx41J4h2BvlUn7go15Yxb6eLzvLXVka4Mre/N
         zumvX8Blxljzlanq14R9XGa7dbkpGn90Uvx/RhT36f5UMVOZXDvQeH4wAZB+Eu6xRGBh
         woew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=c134n78aG+T1D05fG/7gwyDy+RohECK5LAEVlOiODCw=;
        b=VZPt9hvxFFJFk8IN3+dq3l0tyJXoihqi/iY1wjxpS9OFAgK1bnqvbe0ioUpJpKoIaI
         jkv89VjGSLbAj13FQ4DfHbL+2YjPO9mS+vb+odkiXkSC0J8O8/2x6NJSjpouRECEtFzP
         7Da4wWKDLteEPpfN7FEf7+2RI6V6tgUQrDAFX1Znn9ztgdnjCo/oZD8w3Cs1OM0xrHgh
         7wIrPy/BM8bO5I94ZFHNsuDpAXDM1zGlktguYm1RDEI4IS48bgNNnhgSsUkzaJGMT5sk
         tSd/Nnx632YnC8keb7YcAtD7Iefjruj1KQ2t4Lak2o+J1ddVM0IFLU/M/D0XdEF43gbt
         UCkA==
X-Gm-Message-State: AOAM531xmEcrr/iLlZM13RSL4TYYUyqa590XIZZtR1AxnQ9shrSGR8GL
        TfwiQAcgNr4L4wu8/7QpLFXqAkj1OCgy8A==
X-Google-Smtp-Source: ABdhPJx7fgh7UgPdTXT6uFy6snoRxxciP2Hd+WS8NFMVek051RlvF5/SRN4VKGquIHZA++zqp1uC0Q==
X-Received: by 2002:a05:620a:2225:: with SMTP id n5mr5229154qkh.171.1599690963887;
        Wed, 09 Sep 2020 15:36:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id g5sm4497430qtx.43.2020.09.09.15.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 15:36:03 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kG8h8-004BIN-8t; Wed, 09 Sep 2020 19:36:02 -0300
Date:   Wed, 9 Sep 2020 19:36:02 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Joe Perches <joe@perches.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Kees Cook <kees.cook@canonical.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-rdma@vger.kernel.org,
        iommu@lists.linux-foundation.org, dm-devel@redhat.com,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, intel-wired-lan@lists.osuosl.org,
        oss-drivers@netronome.com, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-nvme@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-scsi@vger.kernel.org,
        storagedev@microchip.com, sparclinux@vger.kernel.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-parisc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, bpf@vger.kernel.org,
        dccp@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-sctp@vger.kernel.org,
        alsa-devel <alsa-devel@alsa-project.org>
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
Message-ID: <20200909223602.GJ87483@ziepe.ca>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 09, 2020 at 01:06:39PM -0700, Joe Perches wrote:
> fallthrough to a separate case/default label break; isn't very readable.
> 
> Convert pseudo-keyword fallthrough; statements to a simple break; when
> the next label is case or default and the only statement in the next
> label block is break;
> 
> Found using:
> 
> $ grep-2.5.4 -rP --include=*.[ch] -n "fallthrough;(\s*(case\s+\w+|default)\s*:\s*){1,7}break;" *
> 
> Miscellanea:
> 
> o Move or coalesce a couple label blocks above a default: block.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> 
> Compiled allyesconfig x86-64 only.
> A few files for other arches were not compiled.

IB part looks OK, I prefer it like this

You could do the same for continue as well, I saw a few of those..

Thanks,
Jason
