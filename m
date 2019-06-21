Return-Path: <SRS0=QW5x=UU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A141C48BE3
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 15:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D414D206B7
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Jun 2019 15:16:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="IBZE4nik"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfFUPQo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Jun 2019 11:16:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38118 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfFUPQn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Jun 2019 11:16:43 -0400
Received: by mail-wr1-f67.google.com with SMTP id d18so6972938wrs.5
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Jun 2019 08:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s8ieboGQn1MZ8lIGDf7MlsfVKcOzVxqjfDA5v9kEXZY=;
        b=IBZE4nikn0D5OmQaWrW9k+5YvVNsGZo61lNGVd21Kwt2Y2MGK5vzjNmvG1dAgGMmRO
         ySf8ySu0E17ZUFs3WXkcK+zLLdHPH3C72qCues90hpwPSbr2Khsgewj7I8mhsoo/yEUn
         Y22gcVpVOQxoKjrWYQToVaQBTmPgq4IWTSks3X1fbq9p13Y++Y/8PsDJaBd8NDZnruVa
         mjwXoliLDQ5EapQdzaJI2sXDuOEuwmS7uss2eQonugecj+knGGAs+xdY0SAoLsLIIsAA
         pqn3QAe6fwDI6PrldlITIfrC5qITFCT4j0mggZX7WVwQj29i/zWif0C1lha6P4u3D4UA
         iu2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=s8ieboGQn1MZ8lIGDf7MlsfVKcOzVxqjfDA5v9kEXZY=;
        b=eePNVVbpyqYOF9MwvfEwT9Ex8BYprzqDYC18ho2Xfhkt4A/N89lXFI4vHM6CC0GfXL
         T5/7IJPEyRPKVpUuuBk3BH59Zh/qHeTA3uQw3heHr/ybNJePXYFJOaBNkbP+E0tHwOK7
         qYHdEU8b0Y+S456fRx9WlPJxuErLAasEGe05gLDWGWLB8e6TDGciWku9146Mp18h8gVk
         hmjy9L3tkSZMX9hEh/GhFLoRVEqoL6ngHfuJ7BkKWrgKAZMs7p2zcHWQZjTKVjk3npry
         o7khcWqyYpuRhESlhtR6Ubhl4ztZjNs4qIEZgpuKJa/K8dUdmehOSifXFesvGmil5Qkz
         fslg==
X-Gm-Message-State: APjAAAXotD8X0S503aQpjpW01Wex92+cmxZeD3XbQqhSo8U0OzPGUZM/
        BK7PDvRxNSQbNHtbPwY3cnVXBQ==
X-Google-Smtp-Source: APXvYqzNhx1tW18XY/FVo7RlL2ZweWKyTiXdf1h8x8TQsjLwPNY32fBpYPhdCKcsYMbr6vNx6Cc3kQ==
X-Received: by 2002:a5d:4909:: with SMTP id x9mr29945792wrq.226.1561130201791;
        Fri, 21 Jun 2019 08:16:41 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l16sm2950033wrw.42.2019.06.21.08.16.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 21 Jun 2019 08:16:41 -0700 (PDT)
Date:   Fri, 21 Jun 2019 17:16:40 +0200
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
Subject: Re: [PATCH net-next 00/12] netfilter: add hardware offload
 infrastructure
Message-ID: <20190621151640.GA2414@nanopsycho.orion>
References: <20190620194917.2298-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620194917.2298-1-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thu, Jun 20, 2019 at 09:49:05PM CEST, pablo@netfilter.org wrote:
>Hi,
>
>This patchset adds support for Netfilter hardware offloads.
>
>This patchset reuses the existing block infrastructure, the
>netdev_ops->ndo_setup_tc() interface, TC_SETUP_CLSFLOWER classifier and
>the flow rule API.
>
>Patch #1 moves tcf_block_cb code before the indirect block
>	 infrastructure to avoid forward declarations in the next
>	 patches. This is just a preparation patch.
>
>Patch #2 adds tcf_block_cb_alloc() to allocate flow block callbacks.
>
>Patch #3 adds tcf_block_cb_free() to release flow block callbacks.
>
>Patch #4 adds the tcf_block_setup() infrastructure, which allows drivers
>         to set up flow block callbacks. This infrastructure transports
>         these objects via list (through the tc_block_offload object)
>	 back to the core for registration.
>
>            CLS_API                           DRIVER
>        TC_SETUP_BLOCK    ---------->  setup flow_block_cb object &
>                                 it adds object to flow_block_offload->cb_list
>                                                |
>            CLS_API     <-----------------------'
>           registers                     list if flow block
>         flow_block_cb &                   travels back to
>       calls ->reoffload               the core for registration
>
>Patch #5 extends tcf_block_cb_alloc() to allow drivers to set a release
>	 callback that is invoked from tcf_block_cb_free() to release
>         private driver block information.
>
>Patch #6 adds tcf_setup_block_offload(), this helper function is used by
>         most drivers to setup the block, including common bind and
>         unbind operations.
>
>Patch #7 adapts drivers to use the infrastructure introduced in Patch #4.
>
>Patch #8 stops exposing the tc block structure to drivers, by caching
>	 the only information that drivers need, ie. block is shared
>	 flag.
>
>Patch #9 removes the tcf_block_cb_register() / _unregister()
>	 infrastructure, since it is now unused after Patch #7.
>
>Patch #10 moves the flow_block API to the net/core/flow_offload.c core.
>          This renames tcf_block_cb to flow_block_cb as well as the
>	  functions to allocate, release, lookup and setup flow block
>	  callbacks.
>
>Patch #11 makes sure that only one flow block callback per device is
>          possible by now. This means only one of the ethtool / tc /
>          netfilter subsystems can use hardware offloads, until drivers
>	  are updated to remove this limitation.
>
>Patch #12 introduces basic netfilter hardware offload infrastructure
>	  for the ingress chain. This includes 5-tuple matching and
>          accept / drop actions. Only basechains are supported at this
>          stage, no .reoffload callback is implemented either.
>
>Please, apply, thanks.


Please add some examples of usage here and in the last patch (duplicated
text). Thanks!
