Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559EBEE49A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Aug 2023 00:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjHUAOd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Aug 2023 20:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232170AbjHUAOd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Aug 2023 20:14:33 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B216CA1
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Aug 2023 17:14:30 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-68a3c55532fso355795b3a.3
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Aug 2023 17:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692576870; x=1693181670;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LdfRq2IL/ARk4p4/1TU2z5HFNtWtpG4oisMf6rcwwHA=;
        b=gf0MvhLo/SXJBdrzrwQZiMZENKAhiwxJMxi8ckQXW2CkoasynUQ0v2Cx5ryH4NlnF+
         2M8EaSA31S6k1fUiJKMT4UaIS5SFjN1WsSwy4uYlpcKFS7ANricYcg03mITep63uEFPD
         Y2WRnziO6MloBQGOAVuPwabBRpckmBVLQ6czYe0IacweHQVgA+wTcsvf3t6tUHi5DTYv
         fouAhmChpECIViM0JYiytngkITqdy/BiQ5fyqS4lN6WoDSFgEms/+pExIq+BGSXSu+3L
         6N9unRdWVXBakwZUU7p3VBGSyT21J+/I3hcKvUFtIgqQOvoyajqc0YQoy0/H2ggqmTz7
         IghQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692576870; x=1693181670;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LdfRq2IL/ARk4p4/1TU2z5HFNtWtpG4oisMf6rcwwHA=;
        b=URT8AceGd/5GqW8/KvqnGUZL8IJdPxa65kbJ6hblqeOT2OwkNrHEQqs0hhFAgnOpSB
         9x3gYoLI6Irf3rBuYwTfk2PxyUpDAR8g3NH3oIK7jfkHDop2TPncxLtUMXmiQ8YlcAXx
         PxLLT6EmvujiOnA2e4yTy7Sh01IGLOrbHvN02JXrVYSQV0EB9sFomAaT58KwnXGHrmmt
         Cwr898HTDiukl4JACluRDbqe3bNAZDuBqvrzKGBYGXjazHL6IqSrObixc/hHIJjOdJ8a
         7GVAZqTJvdBIayvxXhL3bogYUc6y/XEuI49TjZ8Ie43V8tdlAKSuCnjzqEKACDaqulPQ
         bQMg==
X-Gm-Message-State: AOJu0Yyd5PX5w5uMpDqIYbNlV8sQe5+vnsG9fHHTTkxjiOUwBrtqXOo1
        AubS/L0KfdMPwVfLFDTfS3f8OWEanto=
X-Google-Smtp-Source: AGHT+IGsA6AzkXuRDA1IEH2XquCmW6yKnVm+ULE9qD92mkG25F2m1ZKtZn1sXTF8tF4Fpy7cPmCWQQ==
X-Received: by 2002:a05:6a20:938d:b0:130:7803:57bd with SMTP id x13-20020a056a20938d00b00130780357bdmr3680069pzh.3.1692576870007;
        Sun, 20 Aug 2023 17:14:30 -0700 (PDT)
Received: from slk15.local.net (n58-108-90-185.meb1.vic.optusnet.com.au. [58.108.90.185])
        by smtp.gmail.com with ESMTPSA id t24-20020a1709028c9800b001bb1f0605b2sm5613042plo.214.2023.08.20.17.14.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Aug 2023 17:14:29 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Mon, 21 Aug 2023 10:14:25 +1000
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: libnetfilter_queue patch ping
Message-ID: <ZOKsYRye/Kq7k+rA@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZOAvByRubG+0lVHX@slk15.local.net>
 <ZOKG6nnqEY9v6ctp@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZOKG6nnqEY9v6ctp@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Aug 20, 2023 at 11:34:34PM +0200, Pablo Neira Ayuso wrote:
> On Sat, Aug 19, 2023 at 12:55:03PM +1000, Duncan Roe wrote:
> > There is a libnetfilter_queue patch of mine from the March 2022 that is still
> > under review in Patchwork:
> >
> > https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220328024821.9927-1-duncan_roe@optusnet.com.au/
> >
> > I tested recently with 63KB packets: overall CPU decrease 20%, user CPU decrease
> > 50%.
>
> I just took the bare minimum of this patch to provide more control on
> memory management as you request, it is here:
>
> http://git.netfilter.org/libnetfilter_queue/commit/?id=91d2c947b473b3540be5474c7128a5fa4ce60934
>
> I have removed the extra callback wrapper which does not provide much
> but an extra layer to the user.
>
> > This patch could open an avenue to having libnetfilter_queue handle tunneling.
> > E.g. for tcp over udp, you could have 2 pktbuff structs (because the data area
> > can be anywhere, rather than residing after the pktbuff head).
>
> Please, do not pursue this approach, this pkt_buff structure is
> mocking the sk_buff API in the kernel in a very simplistic way. You
> can still implement such tunnel handling in your application.
>
> Thanks.

Thanks - I'll try it.
