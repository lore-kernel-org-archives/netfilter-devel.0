From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/5] netfilter: ipset patches
Date: Mon, 18 Apr 2011 16:33:37 +0200
Message-ID: <4DAC4BC1.8060208@trash.net>
References: <1302724356-19590-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44899 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1DROdj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:33:39 -0400
In-Reply-To: <1302724356-19590-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 13.04.2011 21:52, schrieb Jozsef Kadlecsik:
> Hi Patrick,
> 
> Here follows the ipset patches for nf-next-2.6. This batch contains
> the missing fixes compared to nf-2.6 and one new feature, the ability
> to modify the timeout value of already existing elements.
> 
> Best regards,
> Jozsef
> 
> Jozsef Kadlecsik (5):
>   netfilter: ipset: list:set timeout variant fixes
>   netfilter: ipset: references are protected by rwlock instead of mutex

Thanks, but we shouldn't be applying the same patches twice, its better
to ask Dave to pull in net-2.6.git into net-next-2.6.git if your
patches depend on fixes in that tree, I can then pull net-next-2.6.git
into my tree.

