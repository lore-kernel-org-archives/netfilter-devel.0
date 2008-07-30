From: Patrick McHardy <kaber@trash.net>
Subject: Re: src: remove dependency on libiptc headers
Date: Wed, 30 Jul 2008 15:45:36 +0200
Message-ID: <48907080.8020207@trash.net>
References: <alpine.LNX.1.10.0807300839010.6568@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48532 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYG3Npi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:45:38 -0400
In-Reply-To: <alpine.LNX.1.10.0807300839010.6568@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 8219a9d65fe583de06c2ff4e84d1ea299955184b
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Jul 30 08:36:33 2008 -0400
> 
> src: remove dependency on libiptc headers
> 
>  struct xt_rateest_match_info {
> -	char			name1[IFNAMSIZ];
> -	char			name2[IFNAMSIZ];
> +	char			name1[16];
> +	char			name2[16];

Seems unrelated and I don't want to apply this change.
Please remove the IFNAMSIZ changes.

>  struct xtables_match
>  {
>  	struct xtables_match *next;
>  
> -	xt_chainlabel name;
> +	char name[32];
>  

Why 32?
