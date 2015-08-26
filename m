From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 nf-next] added missing icmpv6 codes in REJECT
Date: Wed, 26 Aug 2015 20:36:51 +0200
Message-ID: <20150826183651.GA4407@salvia>
References: <1440149492-27796-1-git-send-email-andi@geekosphere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48977 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbbHZSac (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2015 14:30:32 -0400
Content-Disposition: inline
In-Reply-To: <1440149492-27796-1-git-send-email-andi@geekosphere.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 21, 2015 at 11:31:32AM +0200, Andreas Herz wrote:
> RFC 4443 added two new codes values for ICMPv6 type 1:
> 
>  5 - Source address failed ingress/egress policy
>  6 - Reject route to destination
> 
> And RFC 7084 states in L-14 that IPv6 Router MUST send ICMPv6 Destination
> Unreachable with code 5 for packets forwarded to it that use an address 
> from a prefix that has been invalidated.

Applied, thanks. This is using the following patch subject in
mainstream:

        netfilter: ip6t_REJECT: added missing icmpv6 codes

please, use

        SYBSYS: COMPONENT: short description

next time when submitting, that helps me to reduce janotoring stuff,
but no problem this time.
