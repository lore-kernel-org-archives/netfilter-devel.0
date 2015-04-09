From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft parser and names for constants (was [PATCH v2] parser: add
 kludges for "param-problem" and "redirect")
Date: Thu, 9 Apr 2015 20:15:31 +0100
Message-ID: <20150409191530.GA7548@acer.localdomain>
References: <20150405121104.GD23433@acer.localdomain>
 <552187FB.60904@ahsoftware.de>
 <20150406015128.GA20515@acer.localdomain>
 <55224776.4040108@ahsoftware.de>
 <55224B70.1070309@ahsoftware.de>
 <55224E82.3010206@ahsoftware.de>
 <20150406112543.GB24191@acer.localdomain>
 <552659D6.8090902@ahsoftware.de>
 <20150409110745.GI12203@acer.localdomain>
 <5526BBD4.2000107@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Alexander Holler <holler@ahsoftware.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32950 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbbDITPg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2015 15:15:36 -0400
Content-Disposition: inline
In-Reply-To: <5526BBD4.2000107@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.04, Alexander Holler wrote:
> Am 09.04.2015 um 13:07 schrieb Patrick McHardy:
> >>3. I don't see why admins have to use another set of names for constants
> >>than developers. Inventing a new set of names for a list of constants for
> >>which there already exist a very widely used set of names just leads to more
> >>confusion. And if it's ok to invent new names, why does nft use
> >>"param-problem" and not "parameter-problem"? Of course, I would suggest to
> >>use the existing name icmp_parameterprob (like it's used in every
> >>c/c++-source).
> >
> >In case of ICMP we use the same names that iptables used, so this actually
> >spares admins from getting used to new constants. We're not going to use
> >source code identifiers, there's no benefit at all, especially if you
> >consider that Linux headers use different identifiers than the BSD headers.
> 
> nft isn't in use on BSD and if you think taking BSD out of a corner makes
> sense, I wonder how compatible the names, nft uses, are, with what is used
> by ipf or one of the other BSD firewall packages. As the answer is the names
> are incompatible, arguing with BSD is nonsense here.

This is starting to annoy me. If you suggest to use names from headers, at
least do your homework. The BSD headers is what most of userspace uses, and
this is where ICMP_PARAMPROB originates. Linux uses ICMP_PARAMETERPROB.

> >But I agree, ICMPv6 shouldn't use param-problem but parameter-problem for
> >consistency with both ICMP and ip6tables.
> 
> Anyway, I've tried it a second time. Can't do more. So I will now entering
> the popcorn-state.

The decision has been made a long time ago. You're wasting both our time.
