From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Head up [was Re: [PATCH 0/4] ipset: add "inner" flag support]
Date: Wed, 29 May 2013 11:28:52 +0200
Message-ID: <20130529092852.GA4081@localhost>
References: <51A54814.5040405@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32909 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965326Ab3E2J25 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 05:28:57 -0400
Content-Disposition: inline
In-Reply-To: <51A54814.5040405@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

Cc'ing netfilter-core.

David has been pushing this guy to get him out of anonimity. According
to the kernel policy (Developer authenticity certificate), we need
contributions from a source that we can recognize to avoid legal
issues.

If the contributions are not worth, like that stupid variable rename
he made, better just not to risk and skip them.

Regards.

On Wed, May 29, 2013 at 01:13:08AM +0100, Dash Four wrote:
> This series of 4 patches implements "inner" flag option in the set
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
> 
> Dash Four (4):
>   ipset: minor variable-naming corrections
>   ipset: add "inner" flag implementation
>   iptables: add set match "inner" flag support
>   iptables (userspace): add set match "inner" flag support
> 
> 
> 
