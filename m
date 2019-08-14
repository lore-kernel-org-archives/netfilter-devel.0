Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE5FC433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 17:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A884520644
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 17:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565802106;
	bh=09K/1Dw1tjS6MrrDVxXd+WEzYlZUI0APKRHJGoKZTJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=K+iWQkTKz9ccbGe9x+u0mAwljKkEkmYggzzZLD1cWY6copX4h+1cCQrQalHPKX5eH
	 TI2ntv/ZRhs5PJvxotHOdh5m6bT61/GlU6zQzm5tRoQRuBNLG9rYlKT0psRc+1l3aG
	 Br1Y0yTKxWiSjhSrQawOsEcM6E00yDUXEJ7X+u80=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbfHNRBl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 13:01:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727558AbfHNRBl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 13:01:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF1482063F;
        Wed, 14 Aug 2019 17:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802100;
        bh=09K/1Dw1tjS6MrrDVxXd+WEzYlZUI0APKRHJGoKZTJQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FeRROo2lY3lXa33tTFVuw3SjvEpuzAF9LaJKz36A54nLYnSEI3UPSFj0R0edz4VG9
         +Vqk37CKIKYbXDoYUy1iGLhJGdXr7G+KKklrklGvKZF2JgXxi+LjPCx7v+UbWBQCKO
         kXdNQjKonej55Me+btk2NcAhUjNLbtpHnAIHgA/k=
Date:   Wed, 14 Aug 2019 13:01:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Jankowski <shasta@toxcorp.com>
Cc:     Reindl Harald <h.reindl@thelounge.net>,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 04/42] netfilter: conntrack: always store
 window size un-scaled
Message-ID: <20190814170138.GA31807@sasha-vm>
References: <20190802132302.13537-1-sashal@kernel.org>
 <20190802132302.13537-4-sashal@kernel.org>
 <20190808090209.wb63n6ibii4ivvba@intra2net.com>
 <41ce587d-dfaa-fe6b-66a8-58ba1a3a2872@thelounge.net>
 <alpine.LNX.2.21.1908141316420.1803@kich.toxcorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.21.1908141316420.1803@kich.toxcorp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 14, 2019 at 01:17:30PM +0200, Jakub Jankowski wrote:
>On 2019-08-14, Reindl Harald wrote:
>
>>that's still not in 5.2.8
>
>It will make its way into next 5.2.x release, as it is now in the 
>pending queue: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.2

In general, AUTOSEL stuff soak for much longer before they make it to
the queue.

If there's an urgent need for a fix to go in, please make it explicit.

--
Thanks,
Sasha
