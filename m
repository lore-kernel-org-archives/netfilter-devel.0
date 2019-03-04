Return-Path: <SRS0=Cmqr=RH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A45AAC43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 19:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EF6F20823
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 19:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OPLCaL6j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbfCDTv2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 14:51:28 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:38259 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfCDTv1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 14:51:27 -0500
Received: by mail-pg1-f178.google.com with SMTP id m2so3810484pgl.5
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Mar 2019 11:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=reply-to:subject:from:to:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zc0JUIlUx7U7LtU5T6DSD/Dnb0pGIbBrC9tXcj04A/4=;
        b=OPLCaL6jkFZS+hj9M1lICJVoN3RjPxbHn236IVGRqz0n2btcgWCLv4vW+lAFim/p9C
         /sTiM93D+L0tzObhMiEEWQcXVnI9h1LOeoMQeP7mPbrTR1v6AqEN3njCIqJhwsZQ+WkQ
         UDwybOyvK1WqH1Fhu8cuy4/DR74Zzfbh28biFT1N6N23NA9p+hjLLEDBDhVF1j5+e8Uf
         rnJNZveWC4E6Lk2hzR8j7SpyWlQY5eimOObawgPGGFbzVc02SbTDzfdAH+Kup/WREK8g
         YQxJ0X1vJ/GEcl0D4W/HA04NEvSAKeYLxr0mnKom+ky9s0NQU/EIsXzsVf3QIWeQxa1m
         d55A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:from:to:references:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zc0JUIlUx7U7LtU5T6DSD/Dnb0pGIbBrC9tXcj04A/4=;
        b=J9taUGpOQ2TfkwaLnAHzl1CIISGWu4UdiLtMeXzhVM2gAxzK9u3wZ0nr2u/qKfvlqc
         q2WFsf2lt5QPti/c7uBHuR1EiNKmTA5D4nrsywLH4ntb5fX1n7KofAZqETCelaIYsk7D
         3wALwjys0zBWPJxv3Lgbbi2LD5YlaW38VVEUiic9sBPhSegr2rp5lMj+Yg0FSt2QSQy4
         1xCMWYybIeAKDHBWZ7CHRCh0KLwqn+R4Tz7UjM3OW9mZxOhUDNqZuv48CrFx9YPsirGw
         2wXoOoFXqMl0jksteVQPzuz3b+NSll5CZbBTRZqZko3U1NxJJZLwb8rl3sXo+C6RXCXL
         lHQQ==
X-Gm-Message-State: APjAAAXiz7+5G8pzUYM7Dlp5i95tPx/izq/fXMPAuM4LDdizDSLJl420
        H/VBK+0tKX+MPvjXEjFfcNo3EBA5
X-Google-Smtp-Source: APXvYqzEWRISG17v33L5TStWxglH1mmFA01sh9bQ5X0vRKrRtI4mGdFo8DEvXCWDPS40MO82IvYmWw==
X-Received: by 2002:a65:624c:: with SMTP id q12mr19429129pgv.75.1551729086937;
        Mon, 04 Mar 2019 11:51:26 -0800 (PST)
Received: from mua.localhost (99-7-172-215.lightspeed.snmtca.sbcglobal.net. [99.7.172.215])
        by smtp.gmail.com with ESMTPSA id e123sm8843688pgc.14.2019.03.04.11.51.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Mar 2019 11:51:26 -0800 (PST)
Reply-To: pgnet.dev@gmail.com
Subject: Re: xtables-addons build fail with linux 5.0: "error: implicit
 declaration of function 'do_gettimeofday'; did you mean 'do_settimeofday64'?"
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     netfilter-devel@vger.kernel.org
References: <c4382224-6bfa-3604-28c4-4ab1ea61e943@gmail.com>
Message-ID: <7604c2e7-e477-028f-d0cd-2b57a56c08b1@gmail.com>
Date:   Mon, 4 Mar 2019 11:51:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
In-Reply-To: <c4382224-6bfa-3604-28c4-4ab1ea61e943@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> Can anyone confirm that kernel change

this appears to be it:

  https://github.com/torvalds/linux/commit/e4b92b108c6cd6b311e4b6e85d6a87a34599a6e3
