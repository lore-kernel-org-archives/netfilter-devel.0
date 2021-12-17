Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88EBC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 08:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhLQICg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 03:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbhLQICf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 03:02:35 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EFFC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:02:35 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id n8so1203749plf.4
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yUAT8hKMYcU+tWpLMaKMKXy/HcwiuRAVprQLJE3k18E=;
        b=h9taUcveCwlUmA5W89Btv0nt6W8/kprju9YLqywckBotwtjkrosqsKYNuZnuvyeRuh
         SiB7PfgvncX7zCQr8ZHJkxcSKwnQ4MMPT5BAcOq+xVdHwSZNaAgNNqii9gPITh/RYakl
         9SLbLfly534y2Zgubtj+3m1bJ83KRNBS++L8uH2wx2flARvpKp/hKNqeZcJOGi0RyRwN
         stlbCRBDwoxahc/QAy3EznLuXu/Mf2+GjZuoVwm/b8lzB+aNskWOgxJhddiMfAo057X0
         gtvqXWwwnG+BCsbdw+2djapFu7ad6GMPkilH0YMceMeddkKl+hpv3RoFfaUL5kWynAi+
         v2CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=yUAT8hKMYcU+tWpLMaKMKXy/HcwiuRAVprQLJE3k18E=;
        b=FXO5cHNS0CSgwW+4dC73fh/RSVaU7YS4e02g67Xv2M3mH0jy158LYFX9YfB/n4Bw5s
         YNt8kWIBrZAxMomfPNBvDay4mq8CmUASsBfKC+sWeN69M3Xlccc1Ci2IsbTpOeX54wsr
         +mbRgRGZqgwXSNPA3V4hHl0FAbT1p7fwre/6KenNLX1c4f8GcGAdRCyaZbJYLcO5NwtS
         Be5W4ErIBzj5CXmyARfMgnBcBQd5P7IPYAOTyDZguGPdV/jpuvEGsCbIoMlrwu+NnQ/8
         8H2tgGOSeS9xJdP9U4peNFmCpyMQeCIxr0D7LhxqwywOyPCRUWSnwj8b3zSL7L8QKIeI
         2mJg==
X-Gm-Message-State: AOAM530arKKDTqAfk5mprbzZ+poUWED47gviYz3a7zgq+3YwNuXz9MN4
        XSBYhxFgkoiKQPJ4gr84tln7dY4ajeQ=
X-Google-Smtp-Source: ABdhPJzQcaae/O6O0CT2yfifyVuZoxit3z10V+zZZTZ5r6DqjPA2vFfNVfC8NwpFbpH/FdSxk5kbow==
X-Received: by 2002:a17:90b:4c0b:: with SMTP id na11mr10862439pjb.53.1639728155167;
        Fri, 17 Dec 2021 00:02:35 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id w19sm7511136pga.80.2021.12.17.00.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 00:02:34 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: graphviz.SlackBuild
Date:   Fri, 17 Dec 2021 19:02:28 +1100
Message-Id: <20211217080229.23826-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20200910040431.GC15387@dimstar.local.net>
References: <20200910040431.GC15387@dimstar.local.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Adrius,

Do you still want to maintain the graphviz SBo package?

If not, I would be happy to take it over.

In case you do want to keep graphviz, the next email is a patch for Current that
gets to version 2.50. The new download home has versioned tarballs.

Cheers ... Duncan.

On Thu, Sep 10, 2020 at 02:04:31PM +1000, Duncan Roe wrote:
> Hi Audrius,
>
> Would you be able to upgrade the graphviz SlackBuild to 2.44.1 given a
> SlackBuild for libc-client?

libc-client is no longer required again.
>
[...]
