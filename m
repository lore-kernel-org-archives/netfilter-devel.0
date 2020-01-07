Return-Path: <SRS0=BUQT=24=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4FAFC33C99
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 09:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73DE72073D
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 09:10:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wifirst-fr.20150623.gappssmtp.com header.i=@wifirst-fr.20150623.gappssmtp.com header.b="F8PEWauG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgAGJKf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 04:10:35 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40361 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgAGJKe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 04:10:34 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so18460880wmi.5
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jan 2020 01:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y31vqBK9dm3yHjyNsj7HAaXf/DHwBlhDpY/H2R5Er14=;
        b=F8PEWauGp8iv2FDyrmpmmLYATEsDhjKPAYedOMNK7fZ7Xgp37QRqkXw0Ql1f1Ujd6f
         2TgN8ccIMGMZXhjQpUafEgj+cvEoKHk1rtSwaYY7U//YSIPMqv9dHXFDaKT6eNkSOvlw
         7z0+xq2EBThfCMkeTJ5aqVhNCUQMQ+dwx/ee9ISeDdZe62DEEGE4Kso/WLsWFA2i7NKj
         LsmFRHiERnkbsXaU3K/+koDvoWtLBmWl0klChdURiU2pznzXSXTNtTs4PZlSib+6ZbXG
         xJ2xjHHz3DWnlfGXq+Tb8k5G+NAgr5MYJ86i/Ov5SnbQz2SVPJvjNkKBS2MOR9sGN/r6
         W97w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Y31vqBK9dm3yHjyNsj7HAaXf/DHwBlhDpY/H2R5Er14=;
        b=RnCwFt5zELFRDGali0A0H9Y2z4Yy891+QZYZlkc47CRId/7UMs7UttaXlz0xjEeK/3
         deRIGk0NG4+dXH+7VPQYg1XwXLfhy02ptsFT95CoAMLOQoRQsEqtcASvhiGmFJ6+pul0
         cmTaMfteUatbrSfCt4i2CPot0spFj85yq0iJ9Qlt/EY7gNVXFhhUMz0pHqcTmFxODIZh
         OMUKhSnRgoXJTbi0UxV2Pex+CMumrsDPqji0+RulPejLMppLCbKwhswWSa2b6Ue5a/LC
         WDjPJ+nzMt9bW5oLksEWcqazsrdTWbl1SbuTKVs8dT3slnS1OF7MM1kWBjxFxB7ClYVo
         Vf4g==
X-Gm-Message-State: APjAAAVIhDUUKb7vHHiIQlEfUxRyDkvw+vBTDhuh2Jlh2SAUjCKEkw57
        twaBbEp3hXFUv3liSxZOhP/fzyX0KujcGg==
X-Google-Smtp-Source: APXvYqw7DOrfU+HWDamld7COdzrxxBwqfqQDubnwXnOCxPi85PXxLCxwL3ajwJ8uXit9LOSGp/cy+Q==
X-Received: by 2002:a1c:9849:: with SMTP id a70mr36686331wme.76.1578388232353;
        Tue, 07 Jan 2020 01:10:32 -0800 (PST)
Received: from localhost (wifirst-46-193-244.20.cust.wifirst.net. [46.193.244.20])
        by smtp.gmail.com with ESMTPSA id r5sm74621874wrt.43.2020.01.07.01.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2020 01:10:31 -0800 (PST)
Date:   Tue, 7 Jan 2020 10:10:26 +0100
From:   Romain Bellan <romain.bellan@wifirst.fr>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: add kernel side filtering
 for dump
Message-ID: <20200107091026.GH15271@wiboss>
References: <20191219103638.20454-1-romain.bellan@wifirst.fr>
 <20191230121253.laf2ttcfpjgbfowt@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191230121253.laf2ttcfpjgbfowt@salvia>
X-Operating-System: Linux, kernel 5.2.0-3-amd64
X-Message-Flag: WARNING!! Outlook sucks
X-Bibiche-Flag: Coucou =?iso-8859-1?Q?=E0_toute?= =?iso-8859-1?Q?s?= les
 biches !
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

> I did not yet have a look at this in detail, will do asap.
> 
> However, I would like to know if you would plan to submit userspace
> patches for libnetfilter_conntrack for this. Main problem here is
> backward compatibility (old conntrack tool and new kernel).

Currently I wrote a patch for the pyroute2 python library (to control netlink using Python) whith checks of kernel version for using filtering in kernel or userspace.

I would like to submit a patch for the libnetfilter_conntrack if you think that it is useful, but i didn't have a look on it yet.

About compatibility, currently the only way is to check with the kernel version, but I can add something like NLM_F_DUMP_FILTERED in the netlink reply. What would be the best way for you?

Best regards,

-- 

BELLAN Romain
