Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED090C432BE
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB29C60EBC
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 03:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbhH1DuE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Aug 2021 23:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbhH1DuE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Aug 2021 23:50:04 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1523C0613D9
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:49:14 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q68so7698795pga.9
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 20:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=U7lPgfbVIrxu3yXJyzdoPD++cUHwLK4B5OpJ73mpjEs=;
        b=P/3RT7B7L3jXj17aFT4KOPUjVFQGcMknIHcAfjJKe3x/JiSRT4wiIRr+d2W7jn7jaM
         J91zo17OzImXsbW3kLyTsyoVJakC2u0xJ9URjif5+W12JFdw/5kcZyCK7X/S83WWgMHS
         HaHxBPgMw3r6/KxvTF5AijUT/gGZeGKvw9R6WS/EvLpr/koZCbmOsBkO+x+JgGhlmYkK
         ejkLUd6nXl6Sar023pTNOPTh2s71y28EdIdvBWqhYOvv6hpVRcEqfR1y2F1bUt6Y66dF
         TcMFt+ncpg5aTriB8VJKZ5A8Q8ItGye/qdT1xLCoWjkheKp8QVjYXRq/KD0sS1KxQJ9H
         wZTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=U7lPgfbVIrxu3yXJyzdoPD++cUHwLK4B5OpJ73mpjEs=;
        b=MhRPGFG4eBuLf9cYE/XCPVYhpnPJcOMRhb77OIQTh6IBxurPV3QN4Be/ug0cz2HECV
         dxF4+AFQ9ibuJHmdMVdYlTWndqxwcyxIE20ocZJ5vxcZuxzS/xEZG8WRBkPh2QT1qzzc
         BEQ6E4JE0or1YmUAXsLXYkfDUV+lnf8wOIRAJB7tGKispnfe7EAD8LXKysZewMvOHO/s
         fpGJYPQoLQTBuOx51eV7XYBPD4JUqqbcR2J/9f/IB7kllpt6hDfJGq2Reo/A6sIk8eFF
         +mHn4ShFqO/+GAv0YZfE+I76lMfAWsK3rMVmKQTGQh3LXkCsfDfWcPBiT4VUTwDnp+0o
         GjjQ==
X-Gm-Message-State: AOAM530+NFI/mwQvpt0bZqOSAAS7Xf6cM+ZlOUvyFKq0VlHy3HB5YGZa
        I+pBi075vQo5XZwBGUxp6lMRCUBxPcQ=
X-Google-Smtp-Source: ABdhPJw8lrZRj+3YJwuJzQB3FvboQG8WPGQx+ZZZsDtsNFcbMEvD7RXAQyKXbDRZZCOts4pDmUE8Xw==
X-Received: by 2002:a63:5317:: with SMTP id h23mr10781647pgb.446.1630122554166;
        Fri, 27 Aug 2021 20:49:14 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id gn12sm13132961pjb.26.2021.08.27.20.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 20:49:13 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sat, 28 Aug 2021 13:49:08 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Verion info
Message-ID: <YSmyNO5eaAnTCpcW@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210828033508.15618-1-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Aug 28, 2021 at 01:35:03PM +1000, Duncan Roe wrote:
> Split off shell script from within doxygen/Makefile.am into
> doxygen/build_man.sh.
>
> This patch by itself doesn't fix anything.
> The patch is only for traceability, because diff patch format is not very good
> at catching code updates and moving code together.
> Therefore the script is exactly as it was; it still looks a bit different
> because of having to un-double doubled-up $ signs, remove trailing ";/" and so
> on.
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
v2: Split original into 5 steps
v3: Add extra patch to avoid ./autogen.sh warning (1st 5 patches unchanged)
