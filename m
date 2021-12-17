Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD29C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Dec 2021 08:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhLQIOn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Dec 2021 03:14:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbhLQIOn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Dec 2021 03:14:43 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DFBC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:14:43 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id v13so1634515pfi.3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Dec 2021 00:14:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=AnhaEZ23AYbKR6C5wC9L4fpd1WTBZSvWij6vI4XXBjY=;
        b=cq+JgZTVxTNZLa2B15xN03yR7t3uFyx++o/ldURCMsAv8fgWH1SQWXbfjjdRaS/6y5
         S8WVQdZHLyZ/zyCKRUMi7SO1MrFN7cl4TrhAKxR0OpnHtBqEMwcKEaGET/JR5z8QFO3H
         DeEpv5F6iaNFZb25slUbZCY2sCj0T4XYGauPwdqgjamoVhuQgvLgoZtdhT8CQ46eK+UY
         EB1i+YfK0Zob18CdvCpPmy/+w8v5yCjk/N77DM+xtRyBWIXgb71RzfU7drLilIyeDMqL
         ECBCqO2/5R9rshrDpRz0ODQmQlTBHNx80bzWSyUnrF1EKrRyfTfPGCFU+5PXLadck9ZI
         5nWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=AnhaEZ23AYbKR6C5wC9L4fpd1WTBZSvWij6vI4XXBjY=;
        b=Ou2tmI5jCT1U9W31xphQj5XPfnNvaQWOjclXzfN4tb4RXbBI5UAyUmEByXxEczvFx0
         tzVLd2GJ0pGVAJszVbl/bGbAiqj/M/v4RGgODzO9P4WSw4I+KdfEd5MkwuuLDhlQPypL
         2XiuNJTp88S4SSl3oqem2hs20w/5OIfau+UkjQ9157mNGuox+YLbNDgp2J8t/lo44bhS
         ZULzRFkHgaGvE9yDv1sNcZWfpoHk2Y7seqZYhi6Xi2J39eE77y3M+PuFP0xbmjOeum5E
         yIjAeeBKfiCWT9gDcnudbIm6xuOyoLJoKrxYjpB2jIhjbxIbt6fH1emNHpd/Ed8YOpvP
         yZiw==
X-Gm-Message-State: AOAM533WMJmXODdYMA+RgbjU5KOXnJGcr3zmpNVctG+hIai2TKtYQRXp
        bAbroJwuE6PV8H3B7l8hjRQ=
X-Google-Smtp-Source: ABdhPJxvZII6vmK9jv8qSXOHVXa+9DHO9+nixO/Qpgyeovy4CO0jpeUt3sN6owFQU68xuE3yRlnDgA==
X-Received: by 2002:a05:6a00:24d6:b0:4b4:d8cb:7dc7 with SMTP id d22-20020a056a0024d600b004b4d8cb7dc7mr1992083pfv.66.1639728883093;
        Fri, 17 Dec 2021 00:14:43 -0800 (PST)
Received: from slk1.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id s30sm7758887pfw.57.2021.12.17.00.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 00:14:42 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Fri, 17 Dec 2021 19:14:38 +1100
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH 1/1] graphics/graphviz: Updated for version 2.50
Message-ID: <YbxG7sYYbIsr/RX3@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20200910040431.GC15387@dimstar.local.net>
 <20211217080229.23826-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217080229.23826-2-duncan_roe@optusnet.com.au>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Sorry also about this one (same git send-email), please ignore

Cheers ... Duncan.

On Fri, Dec 17, 2021 at 07:02:29PM +1100, Duncan Roe wrote:
> Remove patch files - no longer required.
>
[...]
