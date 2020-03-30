Return-Path: <SRS0=CFkq=5P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A60C3C43331
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 20:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 785D8206CC
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 20:54:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wifirst-fr.20150623.gappssmtp.com header.i=@wifirst-fr.20150623.gappssmtp.com header.b="J6dTx4it"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728592AbgC3UyB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Mar 2020 16:54:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52917 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbgC3UyB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Mar 2020 16:54:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id z18so319342wmk.2
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 13:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iV/rqc/tMIr2dv4I3KuO/v6q3f2qX3blyuZZvg8t6kQ=;
        b=J6dTx4it2crGG52btYrQ5/+sVxGf6uYgcpR8AmH3p52Hj8tVOxs6EGP5NuXYkpjFsf
         R5PXQCcgsDXcFnSKYMJEvUuJAZWg2mBv+FjOBuFl2ZiZzmUpIasNzfKFukxI/c7SIJag
         6w1t+29/DuWzyqGDKCszwuOW+DLnvAVjyNDFsk/pN9/lLE5YBE/0Bu86DnEMbfY/Ze/l
         zVj6CydsGdyMD6DjWR4slkfwAp0+WQo047f2wY9hi4FM7ZduOrBdI6qGSb6b+2kA1Qc/
         tqm7atsaTHm6oMEI9FDd5K/lrPx7nklEsHflwMuLUp7LI1YZeciWMwcG7wiJRiWzHXZI
         V3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iV/rqc/tMIr2dv4I3KuO/v6q3f2qX3blyuZZvg8t6kQ=;
        b=mC+uDJbNzv1mm12g/sVxepJgypmqcUwjOONMLayNqzf9x8nWoqjofcSDIm7wzn+ZCJ
         EuC1lV4Rk0GPrvrTylJbmHqpzgjMndBlLVGGIWxXHCwJfZyyHABDR0uDFY42OWHd2Q1s
         ZoVOIvc8G6p4lbkWWlVAdwxHUnJwjOADAsnlg0jPEaK8fIHEvhFMy77560p0QR6HgFjO
         Ns+0kviJrJzZUnyAhKs3k13FRA3QNPRuxKK27LIu48jwpcRkW/5GoO4Eqtjo++yUtoxF
         VrptyMf9tZk9h08bZ2nYAqxfl1M33zXcWbxVTdOGGPo3EB3Re9BjPx/qMEqYFrV+nqY4
         75Wg==
X-Gm-Message-State: ANhLgQ0mdL7OHJfmTgfD21aF/miy44aS4lRJDixqaQGhIZ11hry6LXMs
        KJ6D3R60IbcM6XW3rlfHgRGwAVi+qvw=
X-Google-Smtp-Source: ADFU+vtGv0qljnYzCahDEb/rGgc28gXhYMfUl1HEEUxUmVRx8ZgZGQAQh2guArXrwY2WVK6IKh+UnA==
X-Received: by 2002:a7b:c14d:: with SMTP id z13mr1108079wmi.94.1585601636687;
        Mon, 30 Mar 2020 13:53:56 -0700 (PDT)
Received: from ?IPv6:2a01:e34:ec08:2c60:7f09:a6e7:d003:387? ([2a01:e34:ec08:2c60:7f09:a6e7:d003:387])
        by smtp.gmail.com with ESMTPSA id t10sm23518150wrx.38.2020.03.30.13.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 13:53:56 -0700 (PDT)
Subject: Re: [PATCH nf-next v4 1/2] netfilter: ctnetlink: add kernel side
 filtering for dump
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Romain Bellan <romain.bellan@wifirst.fr>,
        netfilter-devel@vger.kernel.org
References: <20200327082632.27129-1-romain.bellan@wifirst.fr>
 <20200329150821.j6pg42dtbw55ff7s@salvia>
 <20200330001047.w22ppmvkrw4uisda@salvia>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
Message-ID: <6b8c4d88-1b93-3f5e-2f4e-c9530a165cc1@wifirst.fr>
Date:   Mon, 30 Mar 2020 22:53:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200330001047.w22ppmvkrw4uisda@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,


> 
> breaks after this patch, and conntrack-tools/test/conntrack.c shows
> several:
> 
>          conntrack v1.4.5 (conntrack-tools): Operation failed: invalid parameters
> 
> I tried to fix it here but I would need a bit more time, I think this
> is on the right track. However, the new flags logic makes ctnetlink
> hit EINVAL in a number of cases.
> 

Indeed, we introduced a regression, CTA_MARK was now mandatory. Sorry 
for the noise. We ran all test of conntrack-tools on the v5 and it 
should now be ok.

Thanks a lot,

-- 
Florent.
