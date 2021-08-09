Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FA8C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 08:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E01D60232
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Aug 2021 08:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbhHIIdP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Aug 2021 04:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbhHIIdP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Aug 2021 04:33:15 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB90C0613CF
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Aug 2021 01:32:54 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so33321990pjr.1
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Aug 2021 01:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=RLEzwUzYig98brHmqr59LBgPJyq5lkqrLpXXAoaqlxM=;
        b=VTVNP3lUmH63VUQStz7jAY3H7X8bY7UmRlnP8JaFxNAjU40nJx5uS2C8drWb+EWfg8
         GaCJpDKT/+PWHQxW0vTP43vaTMbPv819NCo2d9XecwvbClnoVG1KddhB1L3eNBl5g8ER
         wXQh3Lg51so9U64YGbt8kjzSLZI0nZKYl53L8+F0LeYslrWYBxvimbW5cdyIawPLODry
         urBdIO+VcXy2/oA3cYI2G4CiqeM3F3ZctLUsnVhCNi2Q5Zgc8Ml+86FKgevnDwLNMOrp
         wTp3IIf0HbXi+ZSVE/tIhHdH4eXC4Im2Ttglf7IjB5P7onpag70yoZJ558v/FswVmmQ3
         0Xvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=RLEzwUzYig98brHmqr59LBgPJyq5lkqrLpXXAoaqlxM=;
        b=DECoyO47p+qmA/1krzSx11FMBLeXFDkXjWQPTVtrIql0RRQf1/hby41g4UjXQ/k/8U
         wG0/FYJ5tYb8fD/qwSYXMZTdQh8yUnDSeGqSBumoWGOiaj1+n4NZkvh6l2G6JMm6BXPb
         XNYpopOUKHlA9E8vU2CbD7dbx5aPWFBFnKET805Y1KEQ5v5xCYtrtVQ2BjhVF7gad5QK
         yvpR22qoTtujNgNIQhuttPCwtLwblBJ9C1mxOSEHP2eitT16kUex9m95q5GqwfnV2cfd
         x7InWmVFPpHXNb99Wu+QKD/99CetuaFnBf7i6klyuH7GXoh71E15eLU2TbBRF1VdChfe
         LWLA==
X-Gm-Message-State: AOAM530zh/+Xzko8r3xoCfEFIRWCHjJZP0EKyWwa+yt/Nx1y4KmjACxd
        cWoHrMUhxXBsyluRw2esG7jj9X9RhULyTQ==
X-Google-Smtp-Source: ABdhPJxQ2xkbLXhLRwpqWHS/sBx8ot6UYIQX1F0geUZBIJ7THnSy7zEpGPqzqtJTWFmp0mtTZPCuUA==
X-Received: by 2002:aa7:9115:0:b029:359:69db:bc89 with SMTP id 21-20020aa791150000b029035969dbbc89mr17080049pfh.32.1628497973337;
        Mon, 09 Aug 2021 01:32:53 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id f6sm19067708pfe.10.2021.08.09.01.32.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 01:32:52 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 9 Aug 2021 18:32:48 +1000
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH RFC libnetfilter_queue 1/1] src: doc: supply missing
 SYNOPSIS in pktbuff man pages
Message-ID: <YRDoMFK29caJa6wJ@slk1.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210629093837.GA23185@salvia>
 <20210717025350.24040-2-duncan_roe@optusnet.com.au>
 <20210722171015.GA12639@salvia>
 <YPuN1cuL1ukqzSFl@slk1.local.net>
 <20210724085633.GA21304@salvia>
 <YRDluYiIuSpBaDVB@slk1.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRDluYiIuSpBaDVB@slk1.local.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 09, 2021 at 06:22:17PM +1000, Duncan Roe wrote:
[...]Sat, Jul 24, 2021 at 10:56:33AM +0200, Pablo Neira Ayuso wrote:
> The sample was made by doxygen-1.9.1, earlier versions e.g. doxygen-1.8.9.1
> generate a few extra blank lines.
>
It's the older man command inserting the blank lines, not doxygen.

Cheers ... Duncan.
