Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45628C04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 14:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25523206E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 14:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfE1OJ7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 10:09:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfE1OJ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 10:09:59 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 560C719CB81;
        Tue, 28 May 2019 14:09:59 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-200.rdu2.redhat.com [10.10.122.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A5401001943;
        Tue, 28 May 2019 14:09:58 +0000 (UTC)
Date:   Tue, 28 May 2019 10:09:56 -0400
From:   Eric Garver <eric@garver.life>
To:     Shekhar Sharma <shekhar250198@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v1 ] py: nftables.py: fix python3
Message-ID: <20190528140956.yumy2xfl4edypdba@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>,
        Shekhar Sharma <shekhar250198@gmail.com>,
        netfilter-devel@vger.kernel.org
References: <20190524184950.468164-1-shekhar250198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190524184950.468164-1-shekhar250198@gmail.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 28 May 2019 14:09:59 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, May 25, 2019 at 12:19:50AM +0530, Shekhar Sharma wrote:
> This patch converts the 'nftables.py' file (nftables/py/nftables.py) to run on both python2 and python3.
> 
> 
> Signed-off-by: Shekhar Sharma <shekhar250198@gmail.com>
> ---
>  py/nftables.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/py/nftables.py b/py/nftables.py
> index 33cd2dfd..badcfa5c 100644
> --- a/py/nftables.py
> +++ b/py/nftables.py
> @@ -297,7 +297,7 @@ class Nftables:
>          val = self.nft_ctx_output_get_debug(self.__ctx)
>  
>          names = []
> -        for n,v in self.debug_flags.items():
> +        for n,v in list(self.debug_flags.items()):
>              if val & v:
>                  names.append(n)
>                  val &= ~v

Are you fixing an issue here? I don't think the conversion to list is
necessary. The dictionary view can still be iterated. The dictionary is
not being modified.
