Received: from smtp-out.freemail.hu (fmfe28.freemail.hu [46.107.16.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA1C8468;
	Mon, 11 Nov 2024 20:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.107.16.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731357442; cv=none; b=ZWYVpvUdj6oE0cFwt9gCJVhVcHXLLKeOUiXo9EFUIGUB7dFTfLlo0oZjtcc7qXNqyBw4m0MhfwK6uXyVHaOjvHcLYKhH3SHZ5wdLEBxd1vmN8oAdgSwz3LDsDGmpsZER5OgggjO69JRqK2hFpeBr/jE6kiUXCZMUkg4fSlbg1Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731357442; c=relaxed/simple;
	bh=Gmogja/cDdKp/sSar/DZuJv8d1D/g9ALttb3MTCX7X8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kncp3VE7xPHxuvrUk6ezae7D8XjGu6rxkjt2vBr6usrppQQUV3aUn9nWRLqKmxeRgwd445zi02ogo3/6xYs0d+c5++saZWV7ajXsfQdiOu3zvlPlMFv38bSx0pjYeCkw3MUxl9qya6nZHYI958tM+zvkUWZYIEh902SsWgyMI8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu; spf=pass smtp.mailfrom=freemail.hu; dkim=fail (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b=p+EaXxd+ reason="signature verification failed"; arc=none smtp.client-ip=46.107.16.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=freemail.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freemail.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=freemail.hu header.i=@freemail.hu header.b="p+EaXxd+"
Received: from [192.168.0.16] (catv-178-48-208-49.catv.fixed.vodafone.hu [178.48.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.freemail.hu (Postfix) with ESMTPSA id 4XnLly4dFszsql;
	Mon, 11 Nov 2024 21:30:54 +0100 (CET)
Message-ID: <5f28d3d4-fa55-425c-9dd2-5616f5d4c0ac@freemail.hu>
Date: Mon, 11 Nov 2024 21:28:48 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: uapi: Fix file names for case-insensitive
 filesystem.
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, kadlec@netfilter.org,
 davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20241111163634.1022-1-egyszeregy@freemail.hu>
 <20241111165606.GA21253@breakpoint.cc> <ZzJORY4eWl4xEiMG@calendula>
Content-Language: hu
From: =?UTF-8?Q?Sz=C5=91ke_Benjamin?= <egyszeregy@freemail.hu>
In-Reply-To: <ZzJORY4eWl4xEiMG@calendula>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1731357055;
	s=20181004; d=freemail.hu;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=2684; bh=I/fsxw1x4bWN9ougYPy1wE6Zy6ScLkgxwwxi4txHsY8=;
	b=p+EaXxd+Xl2WQ76AfbJ+QIMltF95vherQMohmpDmlSHLW88pc/ZEbrD1PEQqsquL
	rH3XLlhIekESYnt0DwFS2/vFfyPctZjNdyR0Br3PGyBdaQ7FA7opg0wzq+jT51oLwkH
	yOC2azGiGqqoWKk1dLf7IkJ1VuM3WWm90tr2plNL3zluBJkMBrXsSFjRZOes6jpKXJT
	VtIndpDGzSdElngrn2LKGE30CeQGzqC7uUVoZl0LaUTa2YhvOh4YDH5nCG5tqattV3V
	PVJTCmbvqdV1zhqTQAs1uTRZoBSIQW5f5b2HqJuUQ54k3pa5rt+eDYRxkXj1bttAhOG
	jAWKfQef8w==

2024. 11. 11. 19:34 keltezéssel, Pablo Neira Ayuso írta:
> On Mon, Nov 11, 2024 at 05:56:06PM +0100, Florian Westphal wrote:
>> egyszeregy@freemail.hu <egyszeregy@freemail.hu> wrote:
>>>   rename net/ipv4/netfilter/{ipt_ECN.c => ipt_ECN_TARGET.c} (98%)
>>>   rename net/netfilter/{xt_DSCP.c => xt_DSCP_TARGET.c} (98%)
>>>   rename net/netfilter/{xt_HL.c => xt_HL_TARGET.c} (100%)
>>>   rename net/netfilter/{xt_RATEEST.c => xt_RATEEST_TARGET.c} (99%)
>>>   rename net/netfilter/{xt_TCPMSS.c => xt_TCPMSS_TARGET.c} (99%)
>>
>> No, please, if we have to do this, then lets merge the targets
>> (uppercase name) into the match (lowercase), i.e. most of the contents
>> of xt_DSCP.c go into xt_dscp.c.
> 
> Agreed, please don't do this.
> 
> We have seen people sending patches like this one for several years,
> this breaks stuff.

These all files are broken in case-insensitive filesystem.

warning: the following paths have collided (e.g. case-sensitive paths
on a case-insensitive filesystem) and only one from the same
colliding group is in the working tree:

   'include/uapi/linux/netfilter/xt_CONNMARK.h'
   'include/uapi/linux/netfilter/xt_connmark.h'
   'include/uapi/linux/netfilter/xt_DSCP.h'
   'include/uapi/linux/netfilter/xt_dscp.h'
   'include/uapi/linux/netfilter/xt_MARK.h'
   'include/uapi/linux/netfilter/xt_mark.h'
   'include/uapi/linux/netfilter/xt_RATEEST.h'
   'include/uapi/linux/netfilter/xt_rateest.h'
   'include/uapi/linux/netfilter/xt_TCPMSS.h'
   'include/uapi/linux/netfilter/xt_tcpmss.h'
   'include/uapi/linux/netfilter_ipv4/ipt_ECN.h'
   'include/uapi/linux/netfilter_ipv4/ipt_ecn.h'
   'include/uapi/linux/netfilter_ipv4/ipt_TTL.h'
   'include/uapi/linux/netfilter_ipv4/ipt_ttl.h'
   'include/uapi/linux/netfilter_ipv6/ip6t_HL.h'
   'include/uapi/linux/netfilter_ipv6/ip6t_hl.h'
   'net/netfilter/xt_DSCP.c'
   'net/netfilter/xt_dscp.c'
   'net/netfilter/xt_HL.c'
   'net/netfilter/xt_hl.c'
   'net/netfilter/xt_RATEEST.c'
   'net/netfilter/xt_rateest.c'
   'net/netfilter/xt_TCPMSS.c'
   'net/netfilter/xt_tcpmss.c'


What is your detailed plans to solve it? Maybe the contents of both upper and 
lower case *.h files can be merged to a common header files like 
"xt_dscp_common.h" but what about the *.c sources? For example if xt_DSCP.c 
removed and its content merged to xt_dscp.c before, what is the plan with kernel 
config options of CONFIG_NETFILTER_XT_TARGET_DSCP which was made for only 
xt_DSCP.c source to use in Makefile? Can we remove all of 
CONFIG_NETFILTER_XT_TARGET* config in the future which will lost their *.c 
source files?

obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
...
obj-$(CONFIG_NETFILTER_XT_MATCH_DSCP) += xt_dscp.o

