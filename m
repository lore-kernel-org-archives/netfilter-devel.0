Return-Path: <SRS0=34lc=R6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E76FC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 14:40:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E072B2146F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Mar 2019 14:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553697634;
	bh=tjxJLcebPI313P1qPrP1DAeD2TuKj/Vn7zb/SdfYDiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fQi6YiwwxnH6N6KrpV5/ymconTfhBtWTKvNZ20kjnPPynp96ixQkEYGG05JXyOssO
	 3BWIYTkfNGnvuppt/2FMpaNgE0offU8RsrtfVsPwOYNLlh5I6NAkhuqXj+PPJqj95N
	 04j+YMzb/tRJrMyGdQdbX7NF08z6BL/4pUwNwnbc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbfC0Okc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728184AbfC0Okb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Mar 2019 10:40:31 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 326C92147C;
        Wed, 27 Mar 2019 14:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553697631;
        bh=tjxJLcebPI313P1qPrP1DAeD2TuKj/Vn7zb/SdfYDiU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RkUYjuFXdpFF6UYEWjDImfWtzAulSqGyXjasvrFii10B6ujwtfGWVQPj9WbaahJyv
         /eiqMwqotT25Y/MUdzpjgMRKPEvomx0A41kq01/hQzTcSvAB7f9jjiN3MR76njVlq1
         HiWdJgzdVmfBkphCeq4zX971VFJQTKPHbuYQs9AE=
Date:   Wed, 27 Mar 2019 10:40:26 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kfm@plushkava.net,
        stable@vger.kernel.org, mpagano@gentoo.org,
        thibaut.sautereau@clip-os.org, netfilter-devel@vger.kernel.org
Subject: Re: netfilter: nf_tables: fix set double-free in abort path
Message-ID: <20190327144026.GH25262@sasha-vm>
References: <20190326230653.pqhqk7dzoeja46yh@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190326230653.pqhqk7dzoeja46yh@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 27, 2019 at 12:06:53AM +0100, Pablo Neira Ayuso wrote:
>Hi Greg,
>
>I'm receiving several emails for a bit of time now to request to
>cherry-pick this patch:
>
>        40ba1d9b4d19 netfilter: nf_tables: fix set double-free in abort path
>
>to kernel 5.0 stable queue. I'd appreciate if you can do so.

I've queued it for 5.0, thank you.

--
Thanks,
Sasha
