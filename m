From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH v3 0/5]  ipset: add "inner" flag support
Date: Fri, 5 Jul 2013 20:06:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1307052001200.20246@blackhole.kfki.hu>
References: <51CF5256.3010004@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:45899 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3GESGL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 14:06:11 -0400
In-Reply-To: <51CF5256.3010004@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Sat, 29 Jun 2013, Dash Four wrote:

> This series of 5 patches implements "inner" flag option in the set
> iptables match, allowing matching based on the properties
> (source/destination IP address, protocol, port and so on) of the
> original (inner) connection in the event of the following
> ICMP[v4,v6] messages:
> 
> ICMPv4 destination-unreachable (code 3);
> ICMPv4 source-quench (code 4);
> ICMPv4 time-exceeded (code 11);
> ICMPv6 destination-unreachable (code 1);
> ICMPv6 packet-too-big (code 2);
> ICMPv6 time-exceeded (code 3);
> 
> Revision history:
> 
> v1 * initial revision
> v2 * redundant code removed;
>    * added a new header file (ip_set_icmp.h) with 2 inline functions,
>      allowing access to the internal icmp header properties;
>    * removed ip[46]inneraddr[ptr]functions as they are no longer needed
>    * added new ipv[46]addr[ptr] and ip_set_get*port functions, the old
>      functions are still preserved for backwards compatibility
> v3 * rename and move ip_set_get_icmpv[46]_inner_hdr functions to
>      ip_set_core.c and remove ip_set_icmp.h
>    * move icmpv[46] protocol and offset checks inside
>      ip_set_get_ip[46]_inner_hdr functions
>    * eliminate ip[46]addrptr & ip_set_get_ip[46]_port backward-compatible
>      functions and rename the new ones to use the same name
>    * eliminate single-path error gotos in ip_set.h and ip_set_getport.c
> 
> Dash Four (5):
>   iptables: bugfix: prevent wrong syntax being accepted by the set match
>   ipset: add "inner" flag implementation
>   ipset: add set match "inner" flag support
>   iptables: add set match "inner" flag support
>   iptables (userspace): add set match "inner" flag support

I have just noticed one single issue with your patches: the revision 
bumping for the set types are missing.

So please extend the second patch with the type revisions incremented 
(have a look at the hash:net type how the revision comments are kept)
and add a userspace patch with the revisions bumped in userspace too (it's 
fine to copy the most recent ones and increase the revisions, adjust the 
descriptions). That's all and then the patchset is ready for inclusion.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
