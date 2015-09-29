From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 iptables] added missing icmpv6 codes in REJECT
Date: Tue, 29 Sep 2015 20:35:52 +0200
Message-ID: <20150929183552.GA9755@salvia>
References: <1440149585-27908-1-git-send-email-andi@geekosphere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39345 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935302AbbI2S3J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Sep 2015 14:29:09 -0400
Content-Disposition: inline
In-Reply-To: <1440149585-27908-1-git-send-email-andi@geekosphere.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 21, 2015 at 11:33:05AM +0200, Andreas Herz wrote:
> RFC 4443 added two new codes values for ICMPv6 type 1:
> 
>  5 - Source address failed ingress/egress policy
>  6 - Reject route to destination
> 
> And RFC 7084 states in L-14 that IPv6 Router MUST send ICMPv6 Destination
> Unreachable with code 5 for packets forwarded to it that use an address 
> from a prefix that has been invalidated.

Applied this to iptables now that we've got a -rc kernel with this
support so people can test it, thanks.
