From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 27/45] net: remove duplicate includes
Date: Wed, 13 Dec 2017 13:19:00 -0500 (EST)
Message-ID: <20171213.131900.2160870259051715286.davem@davemloft.net>
References: <1513010386-3394-1-git-send-email-pravin.shedge4linux@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, f.fainelli@gmail.com,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, mingo@kernel.org,
        rmk+kernel@armlinux.org.uk, linux-kernel@vger.kernel.org
To: pravin.shedge4linux@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:42128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752434AbdLMSTD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Dec 2017 13:19:03 -0500
In-Reply-To: <1513010386-3394-1-git-send-email-pravin.shedge4linux@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pravin Shedge <pravin.shedge4linux@gmail.com>
Date: Mon, 11 Dec 2017 22:09:46 +0530

> These duplicate includes have been found with scripts/checkincludes.pl but
> they have been removed manually to avoid removing false positives.
> 
> Signed-off-by: Pravin Shedge <pravin.shedge4linux@gmail.com>

Applied, thanks.
