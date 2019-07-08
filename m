Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA04C606C5
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 17:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47AF4216FD
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 17:28:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="IXewwF2n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730731AbfGHR25 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 13:28:57 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34842 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728744AbfGHR25 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 13:28:57 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so381508wmg.0
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jul 2019 10:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ND7qPOWJ9O9HeulEDHkgFjB2UiNRTNgtApVBYWuwuHU=;
        b=IXewwF2nyLkXxGE7Q6EdKRtXNVRlA7yX6SEzaNR/oFbp7TreDEHo6m7AG8BLpNrt8C
         QZUY2GbcrakphRuRQLWr0jhrrfPGoaIificIs8cHM6bxpfE2s4PoQqdhF/Z1ECNWIVfk
         VJNgVKp/BRNSejGyNYDYsT2bx7QbnViNudMcm/C4tFbs1DtzkE8F5K/LAgVnxB5eX2k7
         KcGeog8RgTZxqhQ2lnulUS+LbKPUDcbiV7TYm46iFgXMjj1zqSzVBZWQ+8rV+REB2wzU
         pRnEFwJ+3Ve4pErB2CnlkT9m/S12Ao2eSXRjWFAQaWhpe/5kweyCKp4C4+isU/rh2dyx
         j2Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ND7qPOWJ9O9HeulEDHkgFjB2UiNRTNgtApVBYWuwuHU=;
        b=Oo2Yh5t2z6Jk4qreml6QA5eYWJBfcvr0fcl6QScyYq3wzeMPQAIZulA44sUpTBt78X
         AVxJbOPiknU1P+mKerQXIibR2iCOgxuMPsIH70UjoKdi1n9csF1nJUouuA54wVYcAacH
         LsL3VjqhLCfjvCd/5zpNs6lVWpoIdgxbM5XJZ3IQYxArkVyETv4xBdATv9iuklCOSYd9
         WUpL8FC5xTHUWqbVulUlvEt+Hc4Hii+uRDFsrwF0tSJDb0UtfJXzhv5DG7gk4i7EP+45
         SHqlGeRzZ0WaqPrlZD+DnYzDrYeMlptOG14LfgyCXjk7OVMiVMPi33jwnbQkR3wFqK0z
         pqow==
X-Gm-Message-State: APjAAAWJREGrxz3IuV+d8QkOSfcCpIoEvGsi5QLJWESrsie9DqwWTjkV
        ZvhPsvZwRrAEE4DOtjSUOzqsLA==
X-Google-Smtp-Source: APXvYqw8FBKgOVc1nXnuNchZjpwzoul9zMTm/UXGFgtTQdpfJRxn6lxXgKOHqvj73fcy38Hq9cVTTw==
X-Received: by 2002:a05:600c:10ce:: with SMTP id l14mr13744364wmd.118.1562606935195;
        Mon, 08 Jul 2019 10:28:55 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id u9sm2396004wrr.30.2019.07.08.10.28.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 10:28:54 -0700 (PDT)
Date:   Mon, 8 Jul 2019 19:28:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v3 06/11] net: flow_offload: add
 flow_block_cb_{priv,incref,decref}()
Message-ID: <20190708172854.GB2282@nanopsycho.orion>
References: <20190708160614.2226-1-pablo@netfilter.org>
 <20190708160614.2226-7-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708160614.2226-7-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mon, Jul 08, 2019 at 06:06:08PM CEST, pablo@netfilter.org wrote:
>This patch completes the flow block API to introduce:
>
>* flow_block_cb_priv() to accept callback private data.

"accept"? That's sounds odd to me.


>* flow_block_cb_incref() to bump reference counter on this flow block.
>* flow_block_cb_decref() to decrement the reference counter.
>
>These function are taken from the existing tcf_block_cb_priv(),

"functions"


>tcf_block_cb_incref() and tcf_block_cb_decref().
>

[...]
