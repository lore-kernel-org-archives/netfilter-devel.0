Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F82AC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 11:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiKUL0d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 06:26:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiKULZ7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 06:25:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7588BBEB62
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 03:20:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669029619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AU6/sRwpmwryGJdzruro8bhGwUohv/GC6BtCz6ayNTk=;
        b=SumaqEXbs2HodFdozD9XXo9lEuZjBs2FgT+uybeVdvoCO5eZjlxeUkKsgbwrToZyaRSS2B
        ZQ0lBB0ddrraJfUJDxWHdzVZHk9WtULUu0kOtJCCEARkM3DhbYBHWHdMYfpA3J/RYPAn2L
        glhiT4Yvib31lOiRY2tP90WbftUQtNM=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-121--4DXPfcpML6mB3yhN8yBLQ-1; Mon, 21 Nov 2022 06:20:18 -0500
X-MC-Unique: -4DXPfcpML6mB3yhN8yBLQ-1
Received: by mail-io1-f72.google.com with SMTP id f23-20020a6b5117000000b006dbd4e6a5abso5298373iob.17
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 03:20:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:in-reply-to:mime-version:references
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AU6/sRwpmwryGJdzruro8bhGwUohv/GC6BtCz6ayNTk=;
        b=7hp/qLOuXc4V+kyw9e2A/HpvQWegZXRAwHJpudSz1QvNN0FS9WBq1YCz5wRZ7hAM36
         mii/0cXwtDwIIGOXye0geeoC3jJLK1w/NQ88jPlEQNXnzu/y+w3r382VPH6cNpvgplQ6
         DS/gMT3qiYogBMi8uw4vE5FSIvgUIkWp140G7OifXFe9CTnz0PcpgNdfRw3v7hBbcik2
         NnPvrCjFqXIEELXsht5aDjC9XNuRE2AGTqgtdfLzVX2AYltraiK6/nHA/pybGKPCGmbl
         bSjuTRey+csmDBPkX5ku/TIJREiqiTXAfdP6S/QD5M4yjCJAcOOpM8bA0kIHpmjj9z4J
         gFlA==
X-Gm-Message-State: ANoB5plzFvol3Q+of5LARRPjz9wFoa+88hhOq6qelbl8i676HgIldSiR
        QspK9hRFIdNh0SUCQLG54KTd6qKO58HYfbHq+/sVr/y2MTndVsnq1uGH9biutfxVYouc/HUheyL
        sCNW0cLlX42Cc8wo1GYaUBEPUJuwi+mtK3iL70jXkAgcb
X-Received: by 2002:a05:6638:1a98:b0:375:61b2:825a with SMTP id ce24-20020a0566381a9800b0037561b2825amr8267792jab.147.1669029617651;
        Mon, 21 Nov 2022 03:20:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4ftQYG0DU4KtTuFNPQ+S+xeDjGcsqdEB/9Aqpl577QFM0k0V8CxqaTQGlvV3oPw6U1pgNwMg1AmnuF3+3iGlE=
X-Received: by 2002:a05:6638:1a98:b0:375:61b2:825a with SMTP id
 ce24-20020a0566381a9800b0037561b2825amr8267780jab.147.1669029617407; Mon, 21
 Nov 2022 03:20:17 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 21 Nov 2022 13:20:16 +0200
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20221030122541.31354-1-sriram.yagnaraman@est.tech> <20221030122541.31354-3-sriram.yagnaraman@est.tech>
MIME-Version: 1.0
In-Reply-To: <20221030122541.31354-3-sriram.yagnaraman@est.tech>
Date:   Mon, 21 Nov 2022 13:20:16 +0200
Message-ID: <CALnP8ZZaXTDz0V4_B8UvYp3e3-_L0DZ0Nq=6n-RRGJdOrubSwg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] netfilter: conntrack: add sctp DATA_SENT state
To:     sriram.yagnaraman@est.tech
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Oct 30, 2022 at 01:25:41PM +0100, sriram.yagnaraman@est.tech wrote:
> From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
>
> SCTP conntrack currently assumes that the SCTP endpoints will
> probe secondary paths using HEARTBEAT before sending traffic.
...

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

