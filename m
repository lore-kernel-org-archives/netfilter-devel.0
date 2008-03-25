From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] Add ICMPv6 support in conntrack-tools
Date: Tue, 25 Mar 2008 15:32:01 +0100
Message-ID: <47E90CE1.7020209@netfilter.org>
References: <47e70c6f.izcz7xqp25fqRcfr%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47733 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754491AbYCYOel (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:34:41 -0400
In-Reply-To: <47e70c6f.izcz7xqp25fqRcfr%ole@ans.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Krzysztof Oledzki wrote:
> This patch adds ICMPv6 (-p icmpv6) support for conntrack-tools and adds
> possibility to distinguish between invalid (unknown) and empty proto:
> 
> # conntrack -L --protonum wrong
> conntrack v0.9.6: unknown proto
> Try `conntrack -h' or 'conntrack --help' for more information.
> 
> # conntrack -L --protonum ""
> conntrack v0.9.6: proto needed
> Try `conntrack -h' or 'conntrack --help' for more information.

Also applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
