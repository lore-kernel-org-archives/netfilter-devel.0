From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCH 4/5] adds AF_BRIDGE support to IP2STR
Date: Wed, 13 Feb 2008 12:17:19 +0100
Message-ID: <47B2D1BF.2030807@endian.com>
References: <20080211220753.796791654@endian.com> <20080211221056.846673328@endian.com> <20080212202801.GA13507@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:46324 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbYBMLRg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:17:36 -0500
In-Reply-To: <20080212202801.GA13507@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> you defined here arp.daddr as ULOGD_RET_IPADDR although you've defined it in
> BASE plugin as:
> 	[KEY_ARP_SPA] = {
> 		.type = ULOGD_RET_RAW,
> 		.flags =
> 			ULOGD_RETF_NONE,
> 		.name =
> 			"arp.saddr",
> 	},
>
> This should work in current state code but it is only luck.
>   
Ah, yes. I was not sure which type to choose. Well, defining it
differently is surely suboptimal :)

I will fix it in patch to BASE plugin and set IPADDR type

peter
