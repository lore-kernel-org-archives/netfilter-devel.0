From: Kevin Locke <kevin@kevinlocke.name>
Subject: Re: [PATCH] Include <net/ip6_checksum.h> for csum_ipv6_magic
Date: Tue, 03 Jul 2012 17:02:13 -0600
Message-ID: <4FF379F5.7020803@kevinlocke.name>
References: <20120703183345.GA14043@kevinzilla> <alpine.LNX.2.01.1207032254200.26577@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from praxis.kevinlocke.name ([205.185.125.39]:54311 "EHLO
	praxis.kevinlocke.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476Ab2GCXCR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jul 2012 19:02:17 -0400
In-Reply-To: <alpine.LNX.2.01.1207032254200.26577@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/03/2012 02:54 PM, Jan Engelhardt wrote:
> On Tuesday 2012-07-03 20:33, Kevin Locke wrote:
>> xt_ECHO fails to build on PPC because csum_ipv6_magic is declared in
>> <net/ip6_checksum.h>, which is not implicitly included from other
>> headers on PPC causing build failures due to this function being
>> undefined.  So, include this header explicitly.
>
> Fixed.

Great.  Thanks!
