Return-Path: <SRS0=gL2e=VZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A23FC7618F
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Jul 2019 20:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35E342075B
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 Jul 2019 20:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="pDX5LB6E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfG1URC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 Jul 2019 16:17:02 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36360 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfG1URC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 Jul 2019 16:17:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id k8so26669901plt.3
        for <netfilter-devel@vger.kernel.org>; Sun, 28 Jul 2019 13:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=0PzaKaBRS/lZ7I/jKqnNdIjIQ+r+xDj8+lSwznRFB50=;
        b=pDX5LB6E+pmYnqFbcHdQV/a0uhFMX5PKC0z6A9eayvQu8jaHgKX2e4K0xW20tx+JN3
         ap8AKn6/5awb1UuNC4kUB2HVnFJYE/7HbaA798CAZHYwUTIeKm9zd2asvbwo7QnA4ycR
         0Cz2wqd3A8mGuD3iGtdJt7olGyyAh9FXumskq0ZsxSm2yWL2Kj8FMRvUfvbAcdbcKewt
         hyNC6TzcxiiKdJa2GG+v/W5f+qG9twjneOerWEBYRlZ9++RC/ssz5/ch39lxsOg4l1Si
         Y8SVWqKD7AKnSPVoVrEhV7cLIU1iJKVwf+H06jGa6X5OPR2DYPa1MX/nMiZcRAnXihwX
         /7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=0PzaKaBRS/lZ7I/jKqnNdIjIQ+r+xDj8+lSwznRFB50=;
        b=MuxVulX6k4fD+0Ni28+vaqdmVrbWTNSwXmfyiD+K6VM1UYD1YpmX8OT6nIrn31VLMN
         P5DxBPUINTmvQcm0Z+mKN39gfyaXBh5DmS6kRt/fgW5pgL2EXf1JtveAJrc05uurPnGk
         UikUl+bNGYHu538dMWbZIealgMyTB9YBgQj4V1HeVG2hEzLKhDrDU0zfwUMizto4FIjk
         uJja2tvdRV/0j4HaIZXGen+5zzoVWa+blEqF33Sxqg93YX+/8Ym7S7MCVyuxaX4nKNre
         GfpJvk3Srb6ZS3bi/ziSRwSvs47FBHxbOZtv7IgOHKQUZknRLnqSmUewlxFN3gxueJSt
         oopA==
X-Gm-Message-State: APjAAAUnTGQooHJw/RFl1xqQRcmeovOi5kMD7Mh+rR9T4BL7C6sVSm1W
        SIyODU5nUzOGaDyfzKfmvO7fZQ==
X-Google-Smtp-Source: APXvYqwo6aZDD8JKv7LKbPqWps8aMDM2f5iDy+PoK5UQK4VDgxEkoB+nme1ZmibRMXycsW6R0iLcVg==
X-Received: by 2002:a17:902:44f:: with SMTP id 73mr108004961ple.192.1564345021740;
        Sun, 28 Jul 2019 13:17:01 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id f7sm57836086pfd.43.2019.07.28.13.17.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 28 Jul 2019 13:17:01 -0700 (PDT)
Date:   Sun, 28 Jul 2019 13:16:53 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/3] flow_offload: Support get default block
 from tc immediately
Message-ID: <20190728131653.6af72a87@cakuba.netronome.com>
In-Reply-To: <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
        <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, 28 Jul 2019 14:52:48 +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> When thre indr device register, it can get the default block
> from tc immediately if the block is exist.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
> v3: no change
> v4: get tc default block without callback

Please stop reposting new versions of the patches while discussion is
ongoing, it makes it harder to follow.

The TC default block is there because the indirect registration may
happen _after_ the block is installed and populated.  It's the device
driver that usually does the indirect registration, the tunnel device
and its rules may already be set when device driver is loaded or
reloaded.

I don't know the nft code, but it seems unlikely it wouldn't have the
same problem/need..

Please explain.
