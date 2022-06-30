Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2D3C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jun 2022 01:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiF3BNX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 21:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiF3BNW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 21:13:22 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137201BE80
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 18:13:22 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id bd16so24037199oib.6
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 18:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lyf64hFlA6AX5XN1W/0nDjlmc0D1Wtuzet9BE/Kzetw=;
        b=IwwgdWqXCecJv4jcRkPhGr7VMaueHSrXyNRjlYs1YeyTkPpy/T1UDwo3r3ARvFtSFV
         nnnnuepen62G9lzXzW5c+K6oxPxEnBWJKtp6F0BrbNBoPGFaUtmCMvNjbNaqQCbwVieB
         967IDdrcqMqsgRVF4oj+dRb3moOdN8eSCsdFi+UlkRcANPAiUfg0FfyTx0wiTVNF8Fnx
         ULdvr72OguJSTYyquWRo10TaPn6T1W3meZs5rZ/trMi1n2BPbscBfgsu3wfnxd4lsfMv
         G5G1s4uRDW3IsIGvr3vmcRYwHaaFw1cwe1RlRxpl4fzWCw/BiW7a4uDLHApUTifkiCRJ
         nWTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lyf64hFlA6AX5XN1W/0nDjlmc0D1Wtuzet9BE/Kzetw=;
        b=fVrgEDhGqlgujonbjpfwDAmuK+8Qv2XM+qITQQemy0CH4mdNr1T0yY36802Y7Fgglf
         uj/QVLcWPvwQIWCVxsgvxdy9hcN7H2pE5iboYB1odBu5NBKfKjrm5CjFtx1MUj9r2Qan
         UNgCXqgJRigKF/51GMBnaXmfD/kBfwB0fBCQVS/gf9G+ZY8TJYAEH/bXEwaM5GoLD9Hm
         l1xLbfQrpIleTYSXiwQ5qDUaJiIpmR+I6REussT+tvvxF1DwPlk/x3DwVZdYj2GRZ4OL
         MKNnkcFElrSvUxDKyGS7cAqi2X0okqWCa657N/+vBcMTJ82hkXVQDLYd77qPvucwO4Cm
         44ng==
X-Gm-Message-State: AJIora+gXGitZBPXdHvNetCbOD3okftLe9mcsqvfLCvaXcsZy2BUp+LQ
        ushHMyw4yGkQrBVTAEMpAo71cSbG++M=
X-Google-Smtp-Source: AGRyM1vxUHjVPGFG8YxuIUy4VbKoeiIpULYHWlBWuKMacLA1OnALYQCu7aIzg3qIutoA/dBLgc/AjQ==
X-Received: by 2002:a05:6808:1301:b0:335:b3b2:bacb with SMTP id y1-20020a056808130100b00335b3b2bacbmr2881714oiv.152.1656551601266;
        Wed, 29 Jun 2022 18:13:21 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f013:52d1:7bb1:e7db:c3dd:e1ca])
        by smtp.gmail.com with ESMTPSA id u5-20020a544385000000b003351d035f77sm9283073oiv.47.2022.06.29.18.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 18:13:20 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 75B0732B823; Wed, 29 Jun 2022 22:13:18 -0300 (-03)
Date:   Wed, 29 Jun 2022 22:13:18 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Yuxuan Luo <luoyuxuan.carl@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de,
        lucien.xin@gmail.com, Yuxuan Luo <yuluo@redhat.com>
Subject: Re: [PATCH] xt_sctp: support a couple of new chunk types
Message-ID: <Yrz4rnLV9LNDfmQo@t14s.localdomain>
References: <20220629200545.75362-1-yuluo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220629200545.75362-1-yuluo@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 29, 2022 at 04:05:45PM -0400, Yuxuan Luo wrote:
> There are new chunks added in Linux SCTP not being traced by iptables.
> 
> This patch introduces the following chunks for tracing:
> I_DATA, I_FORWARD_TSN (RFC8260), RE_CONFIG(RFC6525) and PAD(RFC4820)
> 
> Signed-off-by: Yuxuan Luo <luoyuxuan.carl@gmail.com>

These changes make sense to me, but I don't know much the iptables
project and I'm not sure if they are enough. I'll go with Xin's review
on that.

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
