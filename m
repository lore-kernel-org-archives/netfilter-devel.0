From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] netfilter: ipt_REJECT: avoid touching dst
 ref
Date: Mon, 05 Jul 2010 10:40:32 +0200
Message-ID: <4C319A80.4050305@trash.net>
References: <1278076669.2530.33.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39736 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab0GEIkb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jul 2010 04:40:31 -0400
In-Reply-To: <1278076669.2530.33.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> We can avoid a pair of atomic ops in ipt_REJECT send_reset()
>   

Applied, thanks.
