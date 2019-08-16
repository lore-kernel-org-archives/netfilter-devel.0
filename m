Return-Path: <SRS0=Eqja=WM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 850D3C3A59F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 19:44:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C5CC2171F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Aug 2019 19:44:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="inuomRVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbfHPTo5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Aug 2019 15:44:57 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46206 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727602AbfHPTo5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Aug 2019 15:44:57 -0400
Received: by mail-qt1-f196.google.com with SMTP id j15so7287635qtl.13
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Aug 2019 12:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8oUD8uoK0U6eFOyqa1XdhinrbHHTjvt4vpE48z+ZU84=;
        b=inuomRVSW6pUNWICL/LbsTDKMo3RFuU0MwjtDwAmZ/ul11E1NZ00LJ9DyRk41zY7lH
         PQ5mS8WIPGJ29Idzv+lEjxBYaVGUxS9PuoKSanjPK2Poegc5eDbP7ikPdo1Tiy+MJjXu
         eZ8l20Gl0bj5tazFxsSjC6tyIlmsk7WiKl92eX/F3xrnwknxfylLwY3aLo5tMaI0pq8D
         cVzR/9gp/hTp1UMuo90lvfHQKlvMhIMIATbq9g+j69oPL6NkS9Hd0qYCy95O6wlEvUXj
         iXQWU+RXsym8ifNA4Z3SbfEy6DoQK8hsnrkJvTgiLqUJS5DSaSaJk7lhdBIHbBZsXGd6
         j6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8oUD8uoK0U6eFOyqa1XdhinrbHHTjvt4vpE48z+ZU84=;
        b=a5v8I2GdrmIeN0Ct6AncMm6SfQZ2NvD+1hsqXB/+oJ2BTZ6wctNc11QBBOudsT22PC
         Y5MVy03s06enp/B5sSzDD5+bgg/A9PFX3qXDui7m860e8QPjgy3HneOZ4M+UdkXmjd3p
         Ysi9myy104n+XHpKHMzkugt9qY7qSlIwmQYaEp1+CIIhGkn9cmGKt0Ylxk193poELUmX
         KUy9R1HXNYZZsv/c922elDvgKOnzZTT44R2ty1qGrPAT6CMJ1WtpbwDHa6xStb94lnvD
         2cdpv5A1yu9ZUjfiTngZrquwqOHR5k0GOFeShpXg+ESAmAai4BWi6/ieL6f3ZBvleHs0
         icAA==
X-Gm-Message-State: APjAAAXWgMu7D4zE2fR1GestQ/ABTfO9rxs18uYlqnlTsLkEH42Nrs/Z
        aTCng1bXgNoX626EPOhKmTPzMA==
X-Google-Smtp-Source: APXvYqyThjW/BK3sV6h6FsEOIUaTM8wHYUa/3RM+1cvkwCZoYYzkocQGFjDKyvknq7JuMpiGF8phpg==
X-Received: by 2002:ac8:376c:: with SMTP id p41mr10458702qtb.306.1565984696577;
        Fri, 16 Aug 2019 12:44:56 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m8sm3812416qti.97.2019.08.16.12.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 12:44:56 -0700 (PDT)
Date:   Fri, 16 Aug 2019 12:44:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net,v5 2/2] netfilter: nf_tables: map basechain priority
 to hardware priority
Message-ID: <20190816124439.7cc166c1@cakuba.netronome.com>
In-Reply-To: <20190816012410.31844-3-pablo@netfilter.org>
References: <20190816012410.31844-1-pablo@netfilter.org>
        <20190816012410.31844-3-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 16 Aug 2019 03:24:10 +0200, Pablo Neira Ayuso wrote:
> This patch adds initial support for offloading basechains using the
> priority range from 1 to 65535. This is restricting the netfilter
> priority range to 16-bit integer since this is what most drivers assume
> so far from tc. It should be possible to extend this range of supported
> priorities later on once drivers are updated to support for 32-bit
> integer priorities.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v5: fix clang warning by simplifying the mapping of hardware priorities
>     to basechain priority in the range of 1-65535. Zero is left behind
>     since some drivers do not support this, no negative basechain
>     priorities are used at this stage.

LGTM.
