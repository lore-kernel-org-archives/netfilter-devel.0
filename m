Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D0DC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 12:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbjKBM1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 08:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjKBM1k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 08:27:40 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF30B125
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 05:27:34 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-991c786369cso134863766b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Nov 2023 05:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698928053; x=1699532853; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+IlzWzsPzAqK/9VX5A1Cz696kpR/WLJvKy9oVavGOwE=;
        b=miheRlgn2VI7Gw4+l7yGtlPSUcI7qunnd2NS3l8JRonwHJmAw1FVw/qk8HI0BoEv+U
         PKQ8Zgv0OsZSxXSubfIpdIsFPAdGSA/Kv4TE+M0ueUdQYd+16y21IdvO1xTt7+bXDlEh
         yr5gnoFiGYTro/C3Eja3jY21ppUPyJQ419/Onx3Y/APGzL8PxzchQQNgyJhXypgolIie
         N4yDDrVN7igLsLO3hXKq5VP3Q06lQ0aCZURpVrpIFzqUjRKDKQ/pPcX1pLYnt5awV6Aw
         d4cu2MyYbEkpTv10H5TKl1rXSZwf7Og36k+oJC8oGCu9KBnsHORpUMMlCzD4VyybTtQs
         9XMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698928053; x=1699532853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+IlzWzsPzAqK/9VX5A1Cz696kpR/WLJvKy9oVavGOwE=;
        b=m4P+kFmYTjV2OVIWf7+b9X5rX3G5bgpZAo8eTrsZKGi1OOOZZfZ/YnbHyeyYXugVHZ
         uY8RYraa9XHyTJKbfY8gZHOpEHcFKX2f9VHJq2HJByjN6g8ZcEeDTUCMr9sPj6iad1hV
         pVDl/+VJpZMy6Yrv/i5y2wdD///gf1+FpRnrCSepq++0Ui33EHB0Zp1IEVAcaSZIxkFd
         FyhxvDhHEpApoSM0MU9f8EZTNloHndeDIQVND8EQrgV5Yx9XHUj9oVcCmcUrFl3zhbO+
         RzPcCNArGVMozG61qPpkbFWoojCLMfaD9qEvawq1D7WdpIL0xeo6fP5DOybuUhQbggIP
         YYSA==
X-Gm-Message-State: AOJu0YxkaMSlE8DIWL75DWptIvArjxWVHxDK4sefHPoM7vRrC3LUcryv
        QF2xCaH8AoDW1+4GPgbn5EMaug==
X-Google-Smtp-Source: AGHT+IGWszk6J5oumn/g+kI0XIK3jFZLR+YKmegTZFfG8Z5Pys1g97UFM5dl5Wk+Zo/hdL47i+Sp9w==
X-Received: by 2002:a17:907:9496:b0:9c7:59d1:b2c4 with SMTP id dm22-20020a170907949600b009c759d1b2c4mr4030509ejc.64.1698928053238;
        Thu, 02 Nov 2023 05:27:33 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id i9-20020a1709061cc900b009b2cc87b8c3sm1074554ejh.52.2023.11.02.05.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 05:27:32 -0700 (PDT)
Date:   Thu, 2 Nov 2023 15:27:29 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@gmail.com>
Subject: Re: [PATCH v2] netfilter: nf_tables: prevent OOB access in
 nft_byteorder_eval
Message-ID: <d493e2f5-4dad-424c-801e-54c959aab8ef@kadam.mountain>
References: <20230705201232.GG3751@breakpoint.cc>
 <20230705210535.943194-1-cascardo@canonical.com>
 <d7e42ffd-aabf-46d7-b02a-a7337708a29a@moroto.mountain>
 <20231102102846.GE6174@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102102846.GE6174@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 11:28:46AM +0100, Florian Westphal wrote:
> Dan Carpenter <dan.carpenter@linaro.org> wrote:
> > This patch is correct, but shouldn't we fix the code for 64 bit writes
> > as well?
> 
> Care to send a patch?
> 

Sure.  Will do.

regads,
dan carpenter

