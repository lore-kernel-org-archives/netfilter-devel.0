Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4D4C31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 11:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E456F2070B
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 11:40:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hp1/OTCP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbfFRLkq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 07:40:46 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:44737 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729110AbfFRLkq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 07:40:46 -0400
Received: by mail-io1-f47.google.com with SMTP id s7so28878991iob.11;
        Tue, 18 Jun 2019 04:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jedWwHWh2EYefjIp3GoP3+SWfo9njQ+Y+pCfoemyVcc=;
        b=hp1/OTCPGu3jghRAd5Lz/F7MmLm8touJC8nLGPbmmBRTZUN5cb5ABAN3G510fwKi4Q
         c8Tg+286aH9wqzkA5MBt5ne9137D6k+u0pnJKk9QWSpNNEdjmxVdxL5a+HligF7jWXl6
         rq3m9tvDN7ITtKiW2QesrebbXYEPqw5ryJLPmoMxf4fuIX3J2KkWzGv4MQUTb7xJH0XJ
         EEK2QSThTpY/GMOeWqYlxhVBaCOtnhqYpseyMzBTPQJeF9xzrKBLt2uGiHA7zvIa/3dJ
         2/X6qKpLQYVojK6ktTqiag+cbzews6N45Ju8obCJjroLZeNAbJQ0Yy/9dVybqIxvg5Rx
         uNOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jedWwHWh2EYefjIp3GoP3+SWfo9njQ+Y+pCfoemyVcc=;
        b=L8gW2TiZveF7QL75W5Fz88ZXWB+qhZUQh3XfZtM/aIZFJVLAvXlphELm6aN/zLX3Ip
         oGz6yBP9XdjeUtljR0z8a0tmXIpF19fpW1AvKdq7djnw60n7GnjdGdVvATHM50kZwQHE
         WQ3KR73G48B+BjZ5JXX0Op5DxrnF5M5QfnTvQ3XkHo4/7qXmMTdYSH6nUdsc+wRy2vnb
         4AKB1e3NQ/TGrfk9++HfUytCEwZ6YqBuTy8X5GDQuqu4H0o5s4D0HmHYPw/ODD+PkUNS
         EerkzsSp4V0LIOTTS5gZqQPtWB6iGDRsv2XKbYu318t2VjdYeVyhq84AY3gqF2z9gqy1
         0vZQ==
X-Gm-Message-State: APjAAAXiW62yW8ssn1d6p2in152RwGFl2pVQn1LT6mbzqg/R01eAvzQ/
        mlHeL/khPjXUO2Kcvxe3es9zmxU2iU1zzP9gDTmQycEcwpeByA==
X-Google-Smtp-Source: APXvYqyjuFBHVrtcRpdy05mpJo8XVNmpqsT30dMZqv9CEnKdOQPlahtuLMixdsLnf3wOKJil341hHPSpDney9b22gmM=
X-Received: by 2002:a6b:9257:: with SMTP id u84mr3041645iod.278.1560858045113;
 Tue, 18 Jun 2019 04:40:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAK6Qs9mam2U6JdeBnkzX9sfdeWWkLx_+ZgHOTmYjSC2wKfg0cQ@mail.gmail.com>
 <20190618104041.unuonhmuvgnlty3l@breakpoint.cc>
In-Reply-To: <20190618104041.unuonhmuvgnlty3l@breakpoint.cc>
From:   =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.metu@gmail.com>
Date:   Tue, 18 Jun 2019 14:40:34 +0300
Message-ID: <CAK6Qs9kmxqOaCjgcBefPR-NKEdGKTcfKUL_tu09CQYp3OT5krA@mail.gmail.com>
Subject: Re: Is this possible SYN Proxy bug?
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jun 18, 2019 at 1:40 PM Florian Westphal <fw@strlen.de> wrote:
>
> Problem is that we do not keep any state.  Syncookes are restricted to 4
> mss value:
> static __u16 const msstab[] = {
>  536,
> 1300,
> 1440,   /* 1440, 1452: PPPoE */
> 1460,
> };
>
> So, 1260 forces lowest value supported.
>
> The table was based off a research paper that had mss distribution
> tables.  Maybe more recent data is available and if things have changed
> we could update the table accordingly.

I am confused. So this statement from manual page is just a illusion?
--mss maximum segment size
              Maximum segment size announced to clients. This must
match the backend.

I don't understand why these restriction exist. Why can't we set mss
value same as what client send to us?
