Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D11BC41514
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 20:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3469620B7C
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 20:48:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="JPEpRufv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437059AbfHBUsh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 16:48:37 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38859 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729624AbfHBUsf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 16:48:35 -0400
Received: by mail-qk1-f193.google.com with SMTP id a27so55905594qkk.5
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Aug 2019 13:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3C1N+8al+z8dckErSeTZDQFc+/4xHZvV9/+jO4kOCfo=;
        b=JPEpRufvssNWF/1v71nFs+nw36s4b9uY7mUZ/LP6aS2+JTo5zker4G64kMupkuFseK
         9xBItysnnMzDNPq10elghZCv69jFFf2c23E9rqm2fTBwMVyBrtvzw1OXxLBp887Yu7W0
         44DiNeCYJRieM48RUpletoBlwI3AjHLaM0VWD4nmm7d2QpmIhhTe1pLIPXowExWi7EvT
         4QbOdcfCAfH4KFaiuqs7LUPumSqNU6J4Bwi70bAlLW/7REUls0SjfFH9Z7m5efS5B+Il
         DGYKy54IbzQTAQKp0vSdfhHdo7bfGnlVRbM3NZRCNPkDoNHp2kjjsbgvS9zHuCotQFNK
         Ufog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3C1N+8al+z8dckErSeTZDQFc+/4xHZvV9/+jO4kOCfo=;
        b=WdX5Of27oGgV3z8hndLYvDSFQ9Rew5VIL6nDv4ZIN3hDTJGgOU0EEbOUwokomkKbnj
         GNK36OPNzBidEpdlrBGSvkDx1Fok7Fev88NV6GdrHpWRZk5VkMhwYTiCyvVaYI405S21
         eswuqHR2QFay6J0+WkUGiNOWR87/xIwp97WHPeHHCFomOBEI5GVq8PhOEMO0k3hmaBct
         IMe4tIHc0nIfqjR392QjDPnBVUKMR9Oebw9pEUfqG6vq/ScdP65rBrqavVnExzVYnoLL
         Wqr9Klu5H/oiEPZ7UlGsMN9oJPazRgvjO6e+j3ksCtu7hNuxeBS6NjZpvJTf6nS/MdP+
         1zKQ==
X-Gm-Message-State: APjAAAX5dI0H51Xt0PrRmbIjBcTSSnRSV2BVkE/3eXrovC6Friy7EdNL
        KlFp1MJrkvP6nJAGy5iQv2xk4w==
X-Google-Smtp-Source: APXvYqzGwSNqjTCo+ua02rFB8itAsSzhYGKzDBv0Ients45tjeJ2c4CZCeqGolM7S6kNr6rktyJM8w==
X-Received: by 2002:a05:620a:705:: with SMTP id 5mr32923371qkc.330.1564778914410;
        Fri, 02 Aug 2019 13:48:34 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j19sm29957359qtq.94.2019.08.02.13.48.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 13:48:34 -0700 (PDT)
Date:   Fri, 2 Aug 2019 13:48:16 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us,
        marcelo.leitner@gmail.com, saeedm@mellanox.com, wenxu@ucloud.cn,
        gerlitz.or@gmail.com, paulb@mellanox.com
Subject: Re: [PATCH net-next 0/3,v2] flow_offload hardware priority fixes
Message-ID: <20190802134816.05ccbac6@cakuba.netronome.com>
In-Reply-To: <20190802132846.3067-1-pablo@netfilter.org>
References: <20190802132846.3067-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri,  2 Aug 2019 15:28:43 +0200, Pablo Neira Ayuso wrote:
> v2: address Jakub comments to not use the netfilter basechain
>     priority for this mapping.

Hardly.
