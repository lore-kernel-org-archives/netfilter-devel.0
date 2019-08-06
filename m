Return-Path: <SRS0=eApp=WC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD879C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 03:38:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8979B20657
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Aug 2019 03:38:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="UeowZqZ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfHFDiA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 23:38:00 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33875 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbfHFDh7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 23:37:59 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so37281699plt.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Aug 2019 20:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=iTUIZrn2UCx1jsCAA6lR14LBO0TeNKIe7IeoTHeBk+g=;
        b=UeowZqZ6UlZTZMBrx71f+LilHHiFuZm1ZhGrxSNw1/b2riKOr9eFixDJc0WdzFBkO/
         VaHIk71IDeT7eQT6pwoQg09TjPg9LjcpZc4V0rakSaYvKKF/MiZYTRKpvy1+EgRLHmlp
         FCUKSjAv7VGdt7ZlXtN5XVyqN1UoJbeIe4NqDzsYQW7PG0ZE6ndLSAIycQnbtWAmk5zB
         +LPvdoR939tFTdTEJxkK/UFTFUpXRKHUu/JqglM5Ek1jez+wsQtqMzk7HDz+mSZhAxoq
         PBCS8Ok0duNrVKs5zmflhGxFl5xDusyHcvV0wjuFdIQQGcUSjQlefi7RwiBfbUy2nKw/
         hDlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=iTUIZrn2UCx1jsCAA6lR14LBO0TeNKIe7IeoTHeBk+g=;
        b=ib0YJByddJ1FIt4wbnjA3H5Wr0VmVfe6w27sFcWeL0j3nD1EK8fwY7E0Tzw3sXF0MX
         QBP2e/sDNQzNuwASWKw+7kEOQnNfIwDghPXS10+HXI53LB8Vr5z+5ro+6oT/TZh3YuPF
         d6xTUfjdIPRhCn8NSvoURmfpadxHCANaGLJu2d8MxKQJRcn+frkfNSvQRgikSK5Uc5+Y
         IHOKcvIc6+HaT52nsLkOvhzzWV8ZZLL+rX6+bg98p8hQnYrGz8VE+2wuVb4DQQyOZ97z
         VEoS07RxLHnF8gY9pvmHfRCHv6BQMcl7ZanP4BBKsZ5OWKFz49lNU8UQE/Ob0ahijsTc
         z5Dg==
X-Gm-Message-State: APjAAAUgiiQaBBDIvoSpFdwz/RSGzA/BdG9BtEtNuUpw4z0hQDmK04CT
        Iqe7tvbsinn8zXlVLfzAUHTZlw==
X-Google-Smtp-Source: APXvYqwKWTmq1ez4TP1y+z2irCx0ekSwXiQ3zg18mb/u64Fp9c4PxsuBOgscnSq+2fAsYwDRp6KI7A==
X-Received: by 2002:a17:902:b608:: with SMTP id b8mr990842pls.303.1565062679099;
        Mon, 05 Aug 2019 20:37:59 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id y12sm96170564pfn.187.2019.08.05.20.37.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 20:37:58 -0700 (PDT)
Date:   Mon, 5 Aug 2019 20:37:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu@ucloud.cn
Cc:     jiri@resnulli.us, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/6] flow_offload: add indr-block in
 nf_table_offload
Message-ID: <20190805203734.79f81124@cakuba.netronome.com>
In-Reply-To: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
References: <1564925041-23530-1-git-send-email-wenxu@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun,  4 Aug 2019 21:23:55 +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This series patch make nftables offload support the vlan and
> tunnel device offload through indr-block architecture.
> 
> The first four patches mv tc indr block to flow offload and
> rename to flow-indr-block.
> Because the new flow-indr-block can't get the tcf_block
> directly. The fifth patch provide a callback list to get 
> flow_block of each subsystem immediately when the device
> register and contain a block.
> The last patch make nf_tables_offload support flow-indr-block.

Looks good to me, thanks for the changes!

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
