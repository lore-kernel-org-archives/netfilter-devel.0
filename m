Return-Path: <SRS0=rZfM=6X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E00BC28CBC
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 18:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26655208CA
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 May 2020 18:02:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rAMmZ2jV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgEISCh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 May 2020 14:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726214AbgEISCg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 May 2020 14:02:36 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCC6C061A0C
        for <netfilter-devel@vger.kernel.org>; Sat,  9 May 2020 11:02:36 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id d7so5159398ioq.5
        for <netfilter-devel@vger.kernel.org>; Sat, 09 May 2020 11:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Aqzi31B4lB7EoaZQ+FK0ZwwXEjmhbTHSk4NXHROzAKE=;
        b=rAMmZ2jVDzFafNNJaeH5i7FM2LLOBi5CfK8f1M+5DA/34UmGKnOgOjnnYlCFFFbjUU
         3GboYI/aDhyYWk4pPwxJ52LFHaE2w4WfJqxl8V7/UUj3UbxbwLG6fFZRs/On9OfLdt3l
         vzWdbL99CGuPrY0cl9QF6MFmkV2UWeL5jsjzbb7DO2Fu/+xJQDmdNMLJGDDzaKY3bEHD
         iBGPIK4r4NMSUDD0YKVTlA/tKiHdwyovggKYtR7XMUCTcDzT/00lVckzTDovtsaI8FwP
         Jm3tj4hwCKTn70rMBTpfg9pEISAWu7Z+nwps5pw0eHOHhb89N0e0cpbjcELm29p71bBV
         OGnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Aqzi31B4lB7EoaZQ+FK0ZwwXEjmhbTHSk4NXHROzAKE=;
        b=aj04NvOvCJNrVYsjT1HFimGkBsIp5BOCJKRiTHSavXwQIw9zaOBG6unj/hwNlnrCAE
         7OHbd76qRgqCN3BeIGaABSgjV1CsOCWfF9BMyuprMm8vQ8haJt7nn/eFfVGLPoDsPoZt
         SFbhfHmg5bAPo20Y0tlkB7aZxzqnRrZczMINlrGMDsr8z3frvA8X0Yn/YOAEBhIVx4KL
         JCBfSGm9PlkDiKOscRqldtTOxSDB7cSwzyAeXOBzk4cGZCWHM2/WWVkbdvaKvqK3wO9m
         XzzRqo+gGepPJUbGMNXDswqkqQmOF97lJCHLGPuKGbw6rIzmFP2PjEAdfjLkB3gMZ2rx
         6O3g==
X-Gm-Message-State: AGi0PuZzE5+0H5HDpfE8kFOZZYHqMYiJgkQPrR6FpUQ+c/rdw8Vb96ro
        b1Y7utrItS4YGRGAja8BgIHrsOdUj77QBF0tBm7DFA==
X-Google-Smtp-Source: APiQypLSzXmQo2+CQ+YJm3gNvF6RrvZk/X6nVlc4jzEZN94Y7nyOEvJ5sCwPYx3oMkZPxHQDM49bP81GXtOO/607TuA=
X-Received: by 2002:a6b:bc85:: with SMTP id m127mr7945271iof.89.1589047355256;
 Sat, 09 May 2020 11:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200509052235.150348-1-zenczykowski@gmail.com>
 <nycvar.YFH.7.77.849.2005091231090.11519@n3.vanv.qr> <CANP3RGeL_VuCChw=YX5W0kenmXctMY0ROoxPYe_nRnuemaWUfg@mail.gmail.com>
In-Reply-To: <CANP3RGeL_VuCChw=YX5W0kenmXctMY0ROoxPYe_nRnuemaWUfg@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Sat, 9 May 2020 11:02:23 -0700
Message-ID: <CANP3RGeonDWcL72_zGrucvsGpyZchDML5DzSbHgiJBDHX=Zn4A@mail.gmail.com>
Subject: Re: [PATCH] document danger of '-j REJECT'ing of '-m state INVALID' packets
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Side note, it doesn't have to be nearly as aggressive as the above.

With just:
  tc qdisc replace dev ifb0 root netem reorder 99.9% 0% delay 1s
I still see 169.58M @ 7.02MB/s in 26s:
  [24263:180667450] -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
  [27:174654] -A INPUT -m state --state INVALID -j DROP
  [0:0] -A INPUT -p tcp -j REJECT --reject-with tcp-reset

And the connection still freezes without the INVALID/DROP rule (after
43MiB this time)
