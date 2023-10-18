Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44C28CDB474
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 00:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjJRABC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 20:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJRABC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 20:01:02 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BD790
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 17:01:00 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-41cb9419975so3194941cf.2
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 17:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697587260; x=1698192060; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:to:from:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nogZjDiDuhV0mg/6rFchRVkxEvWkLYQ3TDgYbQSl8Sw=;
        b=muNuXDgtTln8gRzfjSXtCk/nbatLuCnAA9Fnn+nblJAG15yb5VkHgBSYWyBy9rALbb
         qiw/12RwB4Zwhm7rAJAg4cSF0GV0ie0ftDQDepg4YZEt9SB3wp4+SpAUyxr4pCXC8H9c
         L9lQc52kVNf2BjNw3W2RO4BDvoV/ZrQHGbijRrTVeabZ9dUFr2o1DxT2LEOAUOciKX+L
         q0DW6ScD9bcsbPSY+GI9XtIXVrTQq0rbsNL6jCkGbhuc3HNy36qM8LfNeS2+NGcfDe2A
         Qy1AAMOTuzopdT56febN7G3abOfNqGmuN4R9uukJqRijGjAI53kRDNe/m6dBsqt9YJ/3
         mtww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697587260; x=1698192060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nogZjDiDuhV0mg/6rFchRVkxEvWkLYQ3TDgYbQSl8Sw=;
        b=QfwIHo6jOBmFmAhsoOHuEWHdPRTyDlW8VKDhVaOyFBUYi5H2JDhuN+SPKnqPExve19
         6JDXSDP/HyYtr57koT45YlF9Rh6HBOna4MkqcwfZbE86T45kVVDc6YNqpsUtzVfimeFU
         FpSpUdb/V5cZh9UHDd+s/vMtEeKqaahun0BfnHj1GoR6tefc9qiIiOU7/T0wgy4cyqi2
         NZZqdopqeedCCT8XqCBqI4Qfb9dGTBgtm7OMBXg5C8BBp7qu1C2lDqasFrErLCZnfed6
         MPymwIMaqL6muIgEekr1w3ohvASk+cH1XqtAfkK2qIQ5OTy5reMbLxavKmE81PhDRPEq
         O00A==
X-Gm-Message-State: AOJu0YxqGJmHuSyxSC3sadE/KChKh/HbMWxfPNzSsgUg38usHAOaJK4f
        nfbUpoYzgxY2qQzy6MtG0o/Fv1BsUo0=
X-Google-Smtp-Source: AGHT+IHH7rnZ+3/rm5UTt6PKYrINs5WUR8acQi8vtFQlk9tfPc8mtLpr0BvPv0HjiNyJCj8B9he0kg==
X-Received: by 2002:ac8:5885:0:b0:417:d4b1:ea28 with SMTP id t5-20020ac85885000000b00417d4b1ea28mr4055344qta.7.1697587259660;
        Tue, 17 Oct 2023 17:00:59 -0700 (PDT)
Received: from playground (c-73-148-50-133.hsd1.va.comcast.net. [73.148.50.133])
        by smtp.gmail.com with ESMTPSA id gd7-20020a05622a5c0700b0041977932fc6sm1003587qtb.18.2023.10.17.17.00.58
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 17:00:59 -0700 (PDT)
Date:   Tue, 17 Oct 2023 20:00:57 -0400
From:   <imnozi@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [nftables/nft] nft equivalent of "ipset test"
Message-ID: <20231017200057.57cfce21@playground>
In-Reply-To: <652F0C75.8010006@mutluit.com>
References: <652EC034.7090501@mutluit.com>
        <20231017213507.GD5770@breakpoint.cc>
        <652F02EC.2050807@mutluit.com>
        <20231017220539.GE5770@breakpoint.cc>
        <652F0C75.8010006@mutluit.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 18 Oct 2023 00:36:37 +0200
"U.Mutlu" <um@mutluit.com> wrote:

> ...
> Actualy I need to do this monster:   :-)
> 
> IP="1.2.3.4"
> ! nft "get element inet mytable myset  { $IP }" > /dev/null 2>&1 && \
> ! nft "get element inet mytable myset2 { $IP }" > /dev/null 2>&1 && \
>    nft "add element inet mytable myset  { $IP }"

Try using '||', akin to:

----
mkdir aaaa; cd aaaa
touch a b

(
  ls a || \
  ls b
) >/dev/null 2>&1 || \
echo "not found"

(
  ls c || \
  ls b
) >/dev/null 2>&1 || \
echo "not found"

(
  ls a || \
  ls d
) >/dev/null 2>&1 || \
echo "not found"

(
  ls c || \
  ls d
) >/dev/null 2>&1 || \
echo "not found"

cd ..
rm -rf aaaa
----

Only if neither file is found will the echo execute.

So this should do the trick for you:

----
(
    nft "get element inet mytable myset  { $IP }" || \
    nft "get element inet mytable myset2 { $IP }"
) >/dev/null 2>&1 || \
  nft "add element inet mytable myset  { $IP }"
----

N
