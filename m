From: Domen Puncer <domen.puncer@samsung.com>
Subject: Re: [PATCH iptables] libxtables: fix getaddrinfo return value usage
Date: Wed, 11 Jun 2014 10:48:19 +0100
Message-ID: <539825E3.6020000@samsung.com>
References: <5397084D.8020703@samsung.com> <20140611093758.GA5427@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20639 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaFKJtX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 05:49:23 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N7000MPO0LU4670@mailout2.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 11 Jun 2014 10:49:06 +0100 (BST)
In-reply-to: <20140611093758.GA5427@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/06/14 10:37, Pablo Neira Ayuso wrote:
> On Tue, Jun 10, 2014 at 02:29:49PM +0100, Domen Puncer wrote:
>> getaddrinfo return value on error can also be positive.
> 
> At quick glance, all EAI_* that I see are negative.

You don't see all of them :-)
On Android they're positive, e.g.:
	android-ndk-r9d/platforms/android-19/arch-arm/usr/include/netdb.h
	147 #define EAI_NONAME       8      /* hostname nor servname provided,
or not known */

And as a plus, it's not bad to conform to specs.

> 
> What problem are you experience? What case are you trying to catch?
> 
> Thanks.
> 

