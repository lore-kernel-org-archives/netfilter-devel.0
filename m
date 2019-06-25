Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA10DC48BD5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 08:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D3A2204EC
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 08:16:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="zFhYw/JN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfFYIQa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 04:16:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42756 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfFYIQa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 04:16:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id x17so16725054wrl.9
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 01:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XP+LR0Z1yUaHNGg2vz822EXoiiGKhM28w8FvAln5Lh8=;
        b=zFhYw/JNYr/XKsr9ac9Kp4yyTxpYlzuCQl+RrxkXkNKrQzQvnSgB3KwxnfNuTbhKIh
         q3hcAOtfJyMG8W0kJz/EyMq2ipdZxWzrXPzWjOUYQwDKWAyvLyM3l5MPO/0bQ0VxCccd
         E2SD3IMXSXvJ0Vc86hMiSPWWS2N8NTRZ+xAHIYsWABHhS81L6J6dRB2j/zcH6L8O3zAp
         t56SGh2u3exjC+M+NEuwFz7hLRkQ5zxRHje1TsnfxILTuU+Wp4Jojtcpk0ZEhv6Bn4WU
         TeoyzHWXy7DViyhOc4bstHT5TKwAOwV5ZsEziuS0MzytAgY6RLk7RhslxhMz0XW4BgNc
         5Hmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XP+LR0Z1yUaHNGg2vz822EXoiiGKhM28w8FvAln5Lh8=;
        b=R7kUFKbYbaB01KE0HFpM6qzGtOgOstOs8Z9hzkAPFIVqMelT7Aawasd/qOhJbD0NI7
         3jpefy0BATaFkmg9tmtIQwXe5tmKYi2UXbfiEZ+C7tx9/S3N5rfjGSDIwK0Ityt+fvON
         yRxtAVuLVkaySV5zWyOZhel5sbt+/8oYywAUwzdAHkIvhKtRglW7euML91XBRSLvr8iT
         tG59Kf1GT+dmMbUil6fl6fxB4nRIlhhEDTwCPdzkeQlKQjsO8yI8LQLf/eDSpqs95The
         DosEOmQ5XKOKLMheGda+LeugveoaNr27om81R4yVRso//JSL5H3PMhT574BvTBwRhoVz
         8Aag==
X-Gm-Message-State: APjAAAXOQnNLrPgdSTgMrFTWFR+Bff+B0K9EwgP8ePJxZwW7lw4Ii2wr
        fmQlC6mnTNED1D2ZfkJmd/6m9Q==
X-Google-Smtp-Source: APXvYqxETSqbBbYaMMsbOxCTG/Tu/fZTu6vX3H5zDTynqWK/N7lHRwkxMMRNm7WeXeNDRFv3LZ9n7g==
X-Received: by 2002:adf:ee03:: with SMTP id y3mr36580164wrn.128.1561450588386;
        Tue, 25 Jun 2019 01:16:28 -0700 (PDT)
Received: from localhost (static-84-42-225-170.net.upcbroadband.cz. [84.42.225.170])
        by smtp.gmail.com with ESMTPSA id x17sm11819379wrq.64.2019.06.25.01.16.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 01:16:28 -0700 (PDT)
Date:   Tue, 25 Jun 2019 10:16:27 +0200
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
Subject: Re: [PATCH net-next 11/12] net: flow_offload: don't allow block
 sharing until drivers support this
Message-ID: <20190625081627.GA2630@nanopsycho>
References: <20190620194917.2298-1-pablo@netfilter.org>
 <20190620194917.2298-12-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620194917.2298-12-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I don't understand the purpose of this patch. Could you please provide
some description about what this is about. mlxsw supports block sharing
between ports. Or what kind of "sharing" do you have in mind?
