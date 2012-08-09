From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/7] extensions: add IPv6 SNAT extension
Date: Thu, 9 Aug 2012 23:31:46 +0200 (MEST)
Message-ID: <Pine.GSO.4.63.1208092330500.26308@stinky-local.trash.net>
References: <1344543073-11660-1-git-send-email-kaber@trash.net>
 <1344543073-11660-4-git-send-email-kaber@trash.net>
 <alpine.LNX.2.01.1208092326130.10514@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33060 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2HIVbr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Aug 2012 17:31:47 -0400
In-Reply-To: <alpine.LNX.2.01.1208092326130.10514@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 9 Aug 2012, Jan Engelhardt wrote:

>
> On Thursday 2012-08-09 22:11, kaber@trash.net wrote:
>> +
>> +static const struct xt_option_entry SNAT_opts[] = {
>> +	{.name = "to-source", .id = O_TO_SRC, .type = XTTYPE_STRING,
>> +	 .flags = XTOPT_MAND | XTOPT_MULTI},
>
> According to the IPv4 SNAT/DNAT manpage, support for multiple ranges
> was removed after 2.6.10. Has this changed?
> If not, XTOPT_MULTI seems misplaced.
>
>> +	case O_TO_SRC:
>> +		if (cb->xflags & F_X_TO_SRC) {
>> +			if (!kernel_version)
>> +				get_kernel_version();
>> +			if (kernel_version > LINUX_VERSION(2, 6, 10))
>> +				xtables_error(PARAMETER_PROBLEM,
>> +					   "SNAT: Multiple --to-source not supported");
>
> It certainly is misplaced. IPv6 S/DNAT did not exist in any form in 2.6.10,
> so we do not need to do the version check here.

Right, I'm going to delete all this.
