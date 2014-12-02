From: Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH -next] netfilter: combine IPv4 and IPv6 nf_nat_redirect
 code in one module
Date: Tue, 2 Dec 2014 16:37:37 +0200
Message-ID: <547DCEB1.5090105@mellanox.com>
References: <1417004330-29618-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <arturo.borrero.glez@gmail.com>, <fw@strlen.de>,
	<rupran@einserver.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-am1on0063.outbound.protection.outlook.com ([157.56.112.63]:37898
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753159AbaLBPPE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 10:15:04 -0500
In-Reply-To: <1417004330-29618-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/26/2014 2:18 PM, Pablo Neira Ayuso wrote:
> This resolves linking problems with CONFIG_IPV6=n:

I have CONFIG_IPV6=m

>
> net/built-in.o: In function `redirect_tg6':
> xt_REDIRECT.c:(.text+0x6d021): undefined reference to `nf_nat_redirect_ipv6'
>
> Reported-by: Andreas Ruprecht<rupran@einserver.de>
> Reported-by: Or Gerlitz<ogerlitz@mellanox.com>
> Signed-off-by: Pablo Neira Ayuso<pablo@netfilter.org>

