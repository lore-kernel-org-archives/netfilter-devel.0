Return-Path: <SRS0=D85U=VG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A3CC73C46
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:37:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 057B420861
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jul 2019 13:37:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="M40+oWDy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfGINhq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jul 2019 09:37:46 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46005 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfGINhq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jul 2019 09:37:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so21061412wre.12
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jul 2019 06:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GpIh13u/cFzuWBQ8S8qolq1RE/EQMXPMGuUalJBBVIk=;
        b=M40+oWDy/ZSU6dpfiIv668od3PlBfx9/VeKWAizpcGWWIUAqXQHxiwUm+Dl8Egsmvm
         OCf3HiwjngS3ZnJje1WdIX6EwJsslPBZoQoCe5qrN2TPaImnfa+tlqVcVubFb8svKnya
         GM78UYZ4TEMqC33EUatcA2AUPA6l+2LUJSRc7/xgRsudPkWLzpAlARi7NNVPthy2evXt
         KfxMSpnZiPHXSBxgA81fxvnrfo6ZK96e+pWqZ7utR2wDY6UtDT03G1oD1OLP0D1yHeEH
         BCURYcE9U8MgIrbOPprJipwb7aDR7DY4xGvsQBiXb8dzfc7bC9S+R+Y36ujFiDqeYILw
         PWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=GpIh13u/cFzuWBQ8S8qolq1RE/EQMXPMGuUalJBBVIk=;
        b=KAF+Yd+3CltQjH7QLPGXNCinLMZcJMCRGoZeoFlr6A1mGXSf8bC2xebAfenXDak+aI
         mAtKpqCSjSBS4QrZaugdVsMho/Txal+I3P9gWEb5Fn0hdPV/ue4nxUAcHPco/KeNe78R
         AdQ1XmAAAyVLoVaCsyIIGQ2QH76tivNWKqas1rCKQ5/OvvQ2hX+S6CisXmsTyBwF8pDP
         gr7ne2O7SPCi8h5h5537GKTE8M2pnyRQnNHoJwlNxTOg5wg3vrhozsPywWZXLV+Gq0Rm
         yzlmRHsKLY8TY1imuRWadGDXNjzbAjW4oUpliPvFhq7BX2NASWW3w5s2SuamnBvFagun
         i4+g==
X-Gm-Message-State: APjAAAU/Z48LrwzbWbGpoDuep2yNKbA9afWpQdAAyQALpdf6ngZwRbBk
        whYrVmZBQK8kGES43W9aTjpiqg==
X-Google-Smtp-Source: APXvYqxTySso+z/NW2/OxAmSEdY1JlJNHwMO3hXfa8C0tcUdFvv1s3SMvjEX1ReazY0si2g8tJGOuQ==
X-Received: by 2002:adf:e8c8:: with SMTP id k8mr25323357wrn.285.1562679464697;
        Tue, 09 Jul 2019 06:37:44 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l2sm1987937wmj.4.2019.07.09.06.37.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 06:37:44 -0700 (PDT)
Date:   Tue, 9 Jul 2019 15:37:43 +0200
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
Subject: Re: [PATCH net-next,v3 04/11] net: flow_offload: add
 flow_block_cb_alloc() and flow_block_cb_free()
Message-ID: <20190709133743.GB2301@nanopsycho.orion>
References: <20190708160614.2226-1-pablo@netfilter.org>
 <20190708160614.2226-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708160614.2226-5-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mon, Jul 08, 2019 at 06:06:06PM CEST, pablo@netfilter.org wrote:

[...]


>+struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,

You don't use net any longer.


>+					  void *cb_ident, void *cb_priv,
>+					  void (*release)(void *cb_priv))

[...]
