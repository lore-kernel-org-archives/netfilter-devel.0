From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC 0/2] icmpv6: match any ICMPv6 error/informational type
Date: Fri, 5 Apr 2013 18:09:03 +0200
Message-ID: <20130405160903.GA5293@localhost>
References: <20130403142729.484857089@eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: holger@eitzenberger.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38628 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161930Ab3DEQJQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:09:16 -0400
Content-Disposition: inline
In-Reply-To: <20130403142729.484857089@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 03, 2013 at 04:27:29PM +0200, holger@eitzenberger.org wrote:
> Hi,
> 
> for streamlining our ip6tables ruleset it would be helpfull to match
> on *any* ICMPv6 informational type.  If not being able to specify any
> informational type it would be required to specify the most common
> types excplicitely, with as many rules as types.  And then with the
> risk of missing some of them.
> 
> Therefore the attached two patches implement the ability to match on
> any ICMPv6 informational (--icmpv6-info) or error (--icmpv6-error)
> type.
> 
> I made the options --icmpv6-type, --icmpv6-error and --icmpv6-info
> mutually exclusive.
> 
> These are the points I'd like your comment specifically:
> 
> 1. I tried not to introduce a new revision by reusing the
>   icmpv6_icmp.invflags for the new flags.
> 
> 2. I think I can even rename icmpv6_icmp.invflags to icmpv6_icmp.flags
>   because the ABI still being the same.  I did this because the name
>   'invflags' being slightly misleading otherwise.
> 
> 3. the F_* flags in the iptables extensions are the same values as
>    the IP6T_ICMP_* values.  Should I use the IP6T_ICMP_* values
>    in the extension?
> 
> Or add a new revision instead?

Please, add a new revision. The ABI will not be broken, but people
using new iptables versions with old kernels will not get any specific
error report telling that what they specify will not work.

Thanks.
