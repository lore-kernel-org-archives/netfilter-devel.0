From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: br_netfilter post routing hook question...
Date: Fri, 02 Apr 2010 19:50:57 +0200
Message-ID: <4BB62E81.707@pandora.be>
References: <CB2DD11991B27C4F99935E6229450D320566AC7B@STORK.scenix.com> <v2q861e3bca1004021026kc7bba6p1a4b615a46e48c29@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Gareth Williams <gwilliams@ubicom.com>,
	netfilter-devel@vger.kernel.org
To: agashi shipora <gashipo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:45612 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab0DBRvA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:51:00 -0400
In-Reply-To: <v2q861e3bca1004021026kc7bba6p1a4b615a46e48c29@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

agashi shipora wrote:
> Hi,
> 
> I don't know if br_nf_post_routing can be assigned a priority
> NF_BR_PRI_LAST-1. I couldn't find ip_refrag definition in 2.6.30.
> 

The comment about ip_refrag() is outdated. I sent a patch containing an
updated comment to Patrick earlier this week. The priority still has to
be NF_BR_PRI_LAST, because br_nf_post_routing() returns NF_STOLEN.
This is because the function ip_fragment(), which can be called by
br_nf_dev_queue_xmit(), will free the skb. If you won't use connection
tracking, I guess you could alter the code so you can still look at it
after br_nf_post_routing().

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be
