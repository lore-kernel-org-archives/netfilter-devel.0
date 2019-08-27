Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53BA5C3A5A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 11:49:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E2AD2173E
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 11:49:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GxLfU00b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfH0Ltr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 07:49:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46450 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfH0Ltr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 07:49:47 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so18473242wru.13
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Aug 2019 04:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6WsWwYdvuyq28PwK+5WQ5KFyOrBl+RjCj0ti4aW150=;
        b=GxLfU00bk+DJigWor2cdQ9gjYSbu5/1+sWJ7idQ7R0VggEpQ2m5FOsl2BtKSNOlSvV
         rqyIzxJMb30nzo86u5NcVAVbgG3TwxZ3hpNj0VEQWHYVn8NWt3NUWo1eo8gb0OXaQktW
         QHCT+edsgxgUnY4ZuwHRi/F6u9itj9y4JI9Q8JN+1jJR91GE0tIGIPLwNvadLk4JgXml
         dXRdaWWGWhDRmNayh0tqLumJ1C4EIR03+HLZJu4auDlFkkQo/TzfCxEY3s3idVOIMxP9
         Ac9Uqvf+d9JNfdLi3xJjULoCmJNdVJT99htTarf3hr2Fmb6PH6RSzUtvIZJMj+7tmG0W
         mWIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6WsWwYdvuyq28PwK+5WQ5KFyOrBl+RjCj0ti4aW150=;
        b=rMNNnDKcg2bUuYEXSAQjL0YPxhnDQsP3HCtZ03W0Y8CEKvmZ5gagpb8BuS6Rz33xUK
         owKjnNNLzDRiGqmZbqxARgNmi7DKXmBk/cxKBLxiaa3AgWEDLR995XmwtqD7Z5jnbyD1
         uwGyyfMVsBCOASNNBkwYC3onsXWBtAkxbAoE6MlXRyX99vCqRDrQoJszZK5Tc0N/2Pq3
         WZsiBg/O5fWrr2C733KkEGMpONRV3M8N5gcdSePYV9trFO9CKEIrRc0n+gAyh8gjNDhq
         FlzFl9gONH67oiSU5P/xQ1RUiYm8km97Rk6eX/uf0H6EWqNqhgeGLXVYAuEU+MzF9XGP
         JLMw==
X-Gm-Message-State: APjAAAWcgLHgLo0umVN5vrfEiDPuArIGieG9hZ6k5svc6ylnDf7laR+z
        Mg1lIJcX7wQB5HrqEtUh9zZPleqf
X-Google-Smtp-Source: APXvYqyORwccvMX8P3YQrXnvlV/12Cj2g+ANZ55AIWwWpG+dLajpoYuV0ubow62T0Iovcg1U7fgWVg==
X-Received: by 2002:adf:f584:: with SMTP id f4mr27421110wro.160.1566906585465;
        Tue, 27 Aug 2019 04:49:45 -0700 (PDT)
Received: from pixies (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id r11sm14043878wrt.84.2019.08.27.04.49.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Aug 2019 04:49:44 -0700 (PDT)
Date:   Tue, 27 Aug 2019 14:49:43 +0300
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: conntrack: make sysctls per-namespace
 again
Message-ID: <20190827144943.40172a85@pixies>
In-Reply-To: <20190827112452.31479-1-fw@strlen.de>
References: <20190827135754.7d460ef8@pixies>
        <20190827112452.31479-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 27 Aug 2019 13:24:52 +0200
Florian Westphal <fw@strlen.de> wrote:

> ---
>  Shmulik, could you please check if this fixes the bug for you?
>  Thanks!

Thanks Florian for the quick fix, I'll check this by tomorrow mytime.

Shmulik
