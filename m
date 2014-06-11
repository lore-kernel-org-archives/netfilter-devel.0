From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] libxtables: fix getaddrinfo return value usage
Date: Wed, 11 Jun 2014 19:55:50 +0200
Message-ID: <20140611175550.GA17981@localhost>
References: <5397084D.8020703@samsung.com>
 <20140611093758.GA5427@localhost>
 <539825E3.6020000@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Domen Puncer <domen.puncer@samsung.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58082 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaFKRz6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:55:58 -0400
Content-Disposition: inline
In-Reply-To: <539825E3.6020000@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 11, 2014 at 10:48:19AM +0100, Domen Puncer wrote:
> On 11/06/14 10:37, Pablo Neira Ayuso wrote:
> > On Tue, Jun 10, 2014 at 02:29:49PM +0100, Domen Puncer wrote:
> >> getaddrinfo return value on error can also be positive.
> > 
> > At quick glance, all EAI_* that I see are negative.
> 
> You don't see all of them :-)
> On Android they're positive, e.g.:
> 	android-ndk-r9d/platforms/android-19/arch-arm/usr/include/netdb.h
> 	147 #define EAI_NONAME       8      /* hostname nor servname provided,
> or not known */

I suspected something like this..

Please, next time include this in the patch description since the
beginning, thanks.

> And as a plus, it's not bad to conform to specs.

It sounds like a reasonable assumption to me.

Do you have more patches like this in your queue?
