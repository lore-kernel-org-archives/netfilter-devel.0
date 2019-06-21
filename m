Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A211DC48BE3
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 17:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B385208C3
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 17:16:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="XhiprkWx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfFURQF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 13:16:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46466 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbfFURQE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 13:16:04 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so7266832wrw.13
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 10:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jgV/XkgN8Y9Fj5/fSBMw8BZRMaC0+jUlz3JahVp2x1I=;
        b=XhiprkWxlA59OOVMHQQOMf/yudIJSGjDIfKLtQzQup0CBEwUqqE75hBaYJRZg4DKT+
         CsgyWFYGLjGg3Gg+vfvZCa5sL3jnFKUpDRkHyme4Fq99HhGPimS0S68Pqt0gzOR4WmYz
         /9ty89u18TQGpuhHcqjMhgizTlX44/0xQhxpT8rC6G/8Hoo0NT1Q9rlrr2caST44yadc
         2K4+kWD2TM44PTzZw3e8zTIbGNafOLQRnXp/+qzdCPMvpmECPmvxhT7M8ynoO6k7SJYV
         DYGVRTX6kTn5s44GRHSe6SpmiYFU7jKnWL+GFVVLyLa1mTkC69Li9eVpxwjXOLDUkiyw
         VZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jgV/XkgN8Y9Fj5/fSBMw8BZRMaC0+jUlz3JahVp2x1I=;
        b=AF2XP8YpoIHm89OUvbmSbL4XPDKeiYaVjuSkpJmhsCqz1ouY4nNDhNOjZnMkHS6rcK
         ydOLfo3zbo6eZfz9b06FH33UiduaQcBAXCovFLRVMvNN5l8m7PhCP6ADljGrsdTw7wn+
         C5fnq+opdgRI5DIxrSHbNccs748uc7dAO74g3jJnwhSr+HYb5Oc4F5N5jHWqKoYrNMF6
         d1l1nwheUTNiMr7lah3ocCVer/lC5GqAo7d4prCddhhIR+WyDyCkfVrGMMHJtndSHUO4
         +B+8syvSTFZjnxg+OzFmlYNI1ufi0Mu23QnuwKpyEVFMkZTZRl2CJkjWtYj8Am/yqdAd
         QhnQ==
X-Gm-Message-State: APjAAAXi/2pS4LO4Izwu94KYSWFRBGKcTNiMhy3PZTBYoIA02PlgJoN4
        4wL88feWdHSZhcjf5GBBZboQRA==
X-Google-Smtp-Source: APXvYqy8B0voVnj1fYtLGS43M2RGVe0wRadUUHbkQh89ge1T7Q9V4Ey+MrKwl1Y4Wsx1zJx59BFD6A==
X-Received: by 2002:adf:f246:: with SMTP id b6mr38171497wrp.92.1561137364493;
        Fri, 21 Jun 2019 10:16:04 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 90sm6151623wrn.97.2019.06.21.10.16.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 10:16:04 -0700 (PDT)
Date:   Fri, 21 Jun 2019 19:16:03 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: Re: [PATCH net-next 04/12] net: sched: add tcf_block_setup()
Message-ID: <20190621171603.GF2414@nanopsycho.orion>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620194917.2298-5-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thu, Jun 20, 2019 at 09:49:09PM CEST, pablo@netfilter.org wrote:

[...]

> 
>+static LIST_HEAD(tcf_block_cb_list);

I still don't like the global list. Have to go throught the code more
carefully, but why you can't pass the priv/ctx from tc/netfilter. From
tc it would be tcf_block as it is now, from netfilter something else.
