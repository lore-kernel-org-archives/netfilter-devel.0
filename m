From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter : fix typo in Kconfig
Date: Mon, 02 Aug 2010 17:13:56 +0200
Message-ID: <4C56E0B4.40800@trash.net>
References: <4C50269B.2010908@online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Jiri Kosina <trivial@kernel.org>
To: Meik Piepmeyer <meik.piepmeyer.lists@online.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61754 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0HBPN4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:13:56 -0400
In-Reply-To: <4C50269B.2010908@online.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28.07.2010 14:46, Meik Piepmeyer wrote:
> From: Meik Piepmeyer <meik.piepmeyer.lists@online.de>
> 
> Fixes a typo of the description of the new netfilter config switch
> "NETFILTER_XT_TARGET_RATEEST" introduced in 2.6.35.
> 
>  config NETFILTER_XT_TARGET_TEE
> -	tristate '"TEE" - packet cloning to alternate destiantion'
> +	tristate '"TEE" - packet cloning to alternate destination'
>  	depends on NETFILTER_ADVANCED
>  	depends on (IPV6 || IPV6=n)
>  	depends on !NF_CONNTRACK || NF_CONNTRACK
> 

This has already been fixed a few weeks ago.
