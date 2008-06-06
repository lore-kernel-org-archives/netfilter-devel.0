From: Eric Leblond <eric@inl.fr>
Subject: Re: [ULOGD PATCH 2/5] New MARK filtering module.
Date: Fri, 6 Jun 2008 15:34:20 +0200
Message-ID: <20080606133420.GA14841@bayen.regit.org>
References: <1212758035-19538-1-git-send-email-eric@inl.fr> <1212758035-19538-2-git-send-email-eric@inl.fr> <1212758035-19538-3-git-send-email-eric@inl.fr> <48493BCD.4020605@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:36547 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYFFNcf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:32:35 -0400
Content-Disposition: inline
In-Reply-To: <48493BCD.4020605@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Friday, 2008 June  6 at 15:29:49 +0200, Patrick McHardy wrote:
> Eric Leblond wrote:
>> +static struct config_keyset libulog_kset = {
>> +	.num_ces = 2,
>> +	.ces = {
>> +		{
>> +			.key 	 = "mark",
> enum foo_keys {
> 	FOO_MARK,
> 	FOO_MASK,
> 	...
> };
>
> struct config_keyset foo_kset = {
> ...
> 	.ces = {
> 		[FOO_MARK] = {
> 			...
> 		},
> 	},
> };

I like this approach. The code is far more readable.

>
> Or maybe resolve them at runtime using the key string in
> performance uncritical paths?
>

BR,
-- 
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
