From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/6] netfilter: xt_TEE: have cloned packet travel through
 Xtables too
Date: Tue, 13 Apr 2010 12:00:48 +0200
Message-ID: <4BC440D0.9020500@trash.net>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de> <1270666217-27670-6-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45984 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570Ab0DMKAt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:00:49 -0400
In-Reply-To: <1270666217-27670-6-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> --- a/net/netfilter/xt_TEE.c
> +++ b/net/netfilter/xt_TEE.c
> @@ -33,6 +33,7 @@ static struct nf_conn tee_track;
>  #endif
>  
>  static const union nf_inet_addr tee_zero_address;
> +static bool tee_active[NR_CPUS];

DEFINE_PER_CPU?
