Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121FAC43218
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 14:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D42102053B
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 14:33:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="JVfRhDre"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfDZOdC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 10:33:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35236 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfDZOdC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 10:33:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id f7so4769858wrs.2
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 07:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f9T6vEbBThC5Ay0HeWiyWcgE38NI5BZC6QizXOaZOM0=;
        b=JVfRhDreisQPenf7UtAn0Z2Se0SyU/dJZsfJDP2Y7h0n5E/Tup0Y8IjSOR2qeOIIvQ
         2u8A0joEfdkGA91uwkGP7MFDWxiHbpNSgxqb26FfveAc/685t2CjpHu/XUm+rNgX0i5i
         3wbcOes56TQiB73VxLLtr6v0aRNKTqtF4DdsuKnpApNQjpQZJy/cwOKozzw2tf9L6agX
         Cvi84htjhH+tbEh1i7r1j4SR9yUQMSAZa/GkxB5fLMGlpeEpH3J3ctRBc+4UGCr3n0jN
         65NaijlRdEeiqv7Ah/r9mrRRI9jLp7kpON6APOhGR0g6qiyATgMTCxMAALM5PSm9pi28
         1vyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f9T6vEbBThC5Ay0HeWiyWcgE38NI5BZC6QizXOaZOM0=;
        b=oq0uAqhQN7TEfCvOQE//C7PIfURT0q5T4+KTpw5B3LE/oMkWzQKOfPJU0tHEY+2iyU
         ZRdmuGZogj0Vl3id6WeTR5c0ubalJkBUkLjpg+lT0/VDjuOgSPwMF/bePoazZRwiUzrl
         d/HbbuwOXCsEPnnUu/aHRnzJUY1swSaTpgAEROE+X3A7qxH1DlhSxX4upIH3vZrt+Z6O
         /agRTCBGiQK/CFegTzSq/FLwi9qSHRmQQoU8YledyKRB3crGwAA6dlFGX2k5vZi568f1
         KmTKADvDCLle6ESPc5s3ji6JN1n3i2KDScmvy4xd3g5luJmsbEovktN8Yqdjl/JJwxrA
         3BOA==
X-Gm-Message-State: APjAAAVYe7UqAKlt1Ryjit3d9QER8HRdufcTj/7mNtWDpEcHBd/ELKM2
        YOEykGkWKCxARKDslX85TyXx3w==
X-Google-Smtp-Source: APXvYqwRJ0wC1rjuSG+HPjp/G+jSm8lAopfUdWMXVJfdgl+/xU88dGjQAK+hYsDXHRoeoQffYcNgWA==
X-Received: by 2002:a5d:52ce:: with SMTP id r14mr31997894wrv.224.1556289179704;
        Fri, 26 Apr 2019 07:32:59 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id h84sm27904543wmf.15.2019.04.26.07.32.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Apr 2019 07:32:59 -0700 (PDT)
Date:   Fri, 26 Apr 2019 16:32:58 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@mellanox.com,
        john.hurley@netronome.com, jakub.kicinski@netronome.com,
        ogerlitz@mellanox.com
Subject: Re: [PATCH net-next,RFC 0/9] net: sched: prepare to reuse per-block
 callbacks from netfilter
Message-ID: <20190426143258.GC2249@nanopsycho.orion>
References: <20190426003348.30745-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426003348.30745-1-pablo@netfilter.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fri, Apr 26, 2019 at 02:33:37AM CEST, pablo@netfilter.org wrote:
>Hi,
>
>This patchset aims to introduce changes to reuse the existing .ndo_setup_tc
>netdev operations from netfilter.
>
>The idea is to move tcf_block_cb to net/core/flow_offload.c and rename
>it to flow_block_cb. This object provides the minimal infrastructure to
>set up per-block callbacks that are called to offload policies to
>hardware.
>
>The tcf_block object is specific for TC to share policies between
>ingress devices. This object has a list of tcf_block_cb objects that are
>called to offload the policies to hardware. In netfilter, the idea is to
>store the list of tcf_block_cb objects in a chain that would be bound to
>several devices, eg.
>
>  chain x {
>	type filter hook ingress devices = { eth0, eth1 } priority 0;
>	...
>  }
>

Do you have the follow-up patchset somewhere? I'm curius about your
goal. Without that, it is hard to understand what you are getting at.


>Hence, this emulates the shared blocks available in TC that Jiri made.
>
>Note that the list of tcf_block_cb objects will be called to offload
>policies in this chain.

So you are going to use chain_id (if there is anything like that) as
block_index during offload, right?


>
>To reuse this infrastructure, I need remove the dependency with the
>tcf_block object and tc/cls_api (see .reoffload) that is called from the
>driver side, this patchset reworks the per-block callback infrastructure
>to set up the tcf_block_cb object from the driver, then convey the list
>of callbacks using the tc_block_offload object back to the core.
>
>            cls_api                         driver
>	TC_SETUP_BLOCK    ---------->  setup tcf_block_cb
>       tc_block_offload           add it to tc_block_offload->cb_list
>                                                |
>          register     <------------------------'
>         tcf_block_cb
>         ->reoffload
>
>Therefore, registration does not happen from drivers anymore, instead
>it is done from the core. The driver just sets up the tcf_block_cb
>object that wires up the connection between the offloaded block (chains
>in case of netfilter) and the driver.
>
>This patchset is compile tested only at this stage.
>
>Comments welcome, thanks.
>
>Pablo Neira Ayuso (9):
>  net: sched: move tcf_block_cb before indr_block
>  net: sched: add tcf_block_cb_alloc()
>  net: sched: add tcf_block_cb_free()
>  net: sched: add tcf_block_setup()
>  net: sched: add release callback to struct tcf_block_cb
>  net: sched: add tcf_setup_block_offload()
>  net: use tcf_block_setup() infrastructure
>  net: sched: remove tcf_block_cb_{register,unregister}()
>  net: cls_api: do not expose tcf_block to drivers
>
> drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  26 +-
> drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |  28 +-
> drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  26 +-
> drivers/net/ethernet/intel/i40e/i40e_main.c        |  26 +-
> drivers/net/ethernet/intel/iavf/iavf_main.c        |  35 +-
> drivers/net/ethernet/intel/igb/igb_main.c          |  23 +-
> drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  27 +-
> drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  27 +-
> drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  59 +-
> drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  64 ++-
> drivers/net/ethernet/netronome/nfp/abm/cls.c       |  17 +-
> drivers/net/ethernet/netronome/nfp/bpf/main.c      |  29 +-
> .../net/ethernet/netronome/nfp/flower/offload.c    |  62 +--
> drivers/net/ethernet/qlogic/qede/qede_main.c       |  23 +-
> drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 +-
> drivers/net/netdevsim/netdev.c                     |  26 +-
> include/net/pkt_cls.h                              |  29 +-
> net/dsa/slave.c                                    |  15 +-
> net/sched/cls_api.c                                | 598 ++++++++++++---------
> 19 files changed, 528 insertions(+), 634 deletions(-)
>
>-- 
>2.11.0
