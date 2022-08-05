Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAA0C25B06
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Aug 2022 00:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiHEAqp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 20:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiHEAqo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 20:46:44 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778E52CCAD
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Aug 2022 17:46:42 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d20so951878pfq.5
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Aug 2022 17:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc;
        bh=ybKH30VyxeuFGNvu9n/MBhto0BNvChcOPNwRY8yMAd0=;
        b=a6ihxluuiNgoHwtHBfN0elVezpB2Np5GZDDSIXaPbUdIwzYgnJmKtJuyzzqOup2sq0
         X5vFOZR89sOnZr9WtoxtQLtf6AZ4+Vq0YNCvmqR/5pADLFoNCIxbuC+SJmfhktQZ+Iaa
         LUAK8Fqu+k/9qq2gxgHeu+CoDz3taP/U8kVOMZGm5JSpl9tG8fwOuuxVFKAmsjxhCK6M
         qJqc1rxOAW980iYYyCZYs+T4x0v8UeBwHI7SsQyElwzwXfMlEPRRTr9LjWsHh47oUakm
         0XqFnIVN+Q5lpRZwwUQJBzR4g+J9agHvAN+W84kgUeLMZmesyTj38hEVodVRUHtP5OZG
         cs4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc;
        bh=ybKH30VyxeuFGNvu9n/MBhto0BNvChcOPNwRY8yMAd0=;
        b=nKAc/lfUzP2EnJX3g5xKTttMildbImsFLTR9xHDeGpoSl33pKTn2C51Dvk2scSqYyG
         KNsWhmMCD7briKygN56DOVsGD9c9Mx8eBU4bVHRHkAiMUSmklM3EmE1UKz/91oYgYbO7
         cLZBp484k5rQ8XscJRHujtPs/FQERHXRa+WZ/1tblMwa7PamL1ss6pS5ee7b+cJWeVTa
         3zUyA2mUiotFnKs/7tTw+u/GDZ9xDN7MdKWoIrXAbLhsXtQL9WLgSIQNVAyxXtxDp4H+
         +LpQhmeiP9fdmtiT60WOS6uDpf1oPUhw9qBnTn5dclLZtmulnn9ILIP0in19n5c+iHv5
         crnw==
X-Gm-Message-State: ACgBeo0kFN8ZRv8rEDlCC/UhmXhv7sQbHUZg/KQeLBD36985He9E1ZUt
        ezS3J1RRJg2AxbYKmkcq0nwnM6bt8Cs=
X-Google-Smtp-Source: AA6agR4G0Rt2fybHAmB2VPnxUDKkcJm4wX3ZMh9cY/GxthLjh8k0wc+V4BgCR5co3+2UCiHkIoXT4A==
X-Received: by 2002:a62:e114:0:b0:52d:24b6:a89 with SMTP id q20-20020a62e114000000b0052d24b60a89mr4480431pfh.65.1659660401794;
        Thu, 04 Aug 2022 17:46:41 -0700 (PDT)
Received: from slk15.local.net (n110-23-108-30.sun3.vic.optusnet.com.au. [110.23.108.30])
        by smtp.gmail.com with ESMTPSA id iz19-20020a170902ef9300b0016d150c6c6dsm1595134plb.45.2022.08.04.17.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 17:46:41 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date:   Fri, 5 Aug 2022 10:46:37 +1000
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] libmnl: add support for signed types
Message-ID: <YuxobVn0TONsjp2B@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Jacob Keller <jacob.e.keller@intel.com>,
        Jan Engelhardt <jengelh@inai.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20220804220555.2681949-1-jacob.e.keller@intel.com>
 <q7301nr-3q5r-q54s-o9o7-r19104226p3@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q7301nr-3q5r-q54s-o9o7-r19104226p3@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jacob,

On Fri, Aug 05, 2022 at 01:35:45AM +0200, Jan Engelhardt wrote:
>
> >+ * mnl_attr_get_s8 - returns 8-bit signed integer attribute payload
> >+ *
> >+ * This function returns the 8-bit value of the attribute payload.
> >+ */
>
> That's kinda redundant - it's logically the same thing, just written
> ever-so-slightly differently.
>
>
> >+/**
> >+ * mnl_attr_get_s64 - returns 64-bit signed integer attribute.
> >    This
> >+ * function is align-safe, since accessing 64-bit Netlink attributes is a
> >+ * common source of alignment issues.
>
> That sentence is self-defeating. If NLA access is a commn source of
> alignment issues, then, by transitivity, this function too would
> be potentially affected. Just
>
>   "This function reads the 64-bit nlattr in an alignment-safe manner."
>
>
Please use the following documentation style for *all* new functions. The man
pages look better that way:

>  * mnl_attr_get_s8 - get 8-bit signed integer attribute payload
>  * \param attr pointer to netlink attribute
>  *
>  * \return 8-bit value of the attribute payload

I.e. "get" instead of "returns" in 1-line description; Use \return instead of
"This function returns the"; No full stop at end of \return description.

Cheers ... Duncan.
