From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables RFC v3 PATCH 14/16] xtables: Support pure
 nft expressions for DNAT extension
Date: Mon, 12 Aug 2013 10:42:44 +0300
Message-ID: <520891F4.9010002@linux.intel.com>
References: <1376055090-26551-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1376055090-26551-15-git-send-email-tomasz.bursztyka@linux.intel.com> <20130809215611.GC7102@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:61450 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453Ab3HLHmr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Aug 2013 03:42:47 -0400
In-Reply-To: <20130809215611.GC7102@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> This approach results in a fairly large parsing function. Note that
> we'll have similar functions in SNAT and DNAT both for ipv4 and ipv6.
> We have to find a better way to avoid bloating the existing
> extensions.

I agree, SNAT will be 99% same code. So it would be nice to factorize 
that somewhere.
Maybe some new xtables .c file for common stuff like that.

>> >+
>> >+	info = calloc(1, sizeof(struct ipt_natinfo));
>> >+	if (info == NULL)
>> >+		return -1;
>> >+
>> >+	info = append_range(NULL, &range);
>> >+	if (user_cb("DNAT", &info->t, user_data) != 0) {
>> >+		free(info);
>> >+		return -1;
>> >+	}
> The current kernels only support nat rangesize of 1 element, so no
> need for this append_range handling.

Ok thanks for the notice, I followed the way it's currently done in the 
userspace extension, did not know that it's not supported in kernel.

Tomasz
