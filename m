From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] xtables-addons: xt_RAWNAT: skb writable part might not
 include whole l4 header (ipv4 case).
Date: Wed, 8 May 2013 23:32:16 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1305082320440.21875@nerf07.vanv.qr>
References: <20130505220504.1a3f2380a1e798b37e628dd1@highloadlab.com> <20130505222433.5c27056103b98340bba773df@highloadlab.com> <alpine.LNX.2.01.1305081322250.29391@nerf07.vanv.qr> <20130508191202.4cb5233820bbb96a1e611329@highloadlab.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Dmitry Popov <dp@highloadlab.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42078 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab3EHVcT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 May 2013 17:32:19 -0400
In-Reply-To: <20130508191202.4cb5233820bbb96a1e611329@highloadlab.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2013-05-08 17:12, Dmitry Popov wrote:
>
>> With nf_nat having gained IPv6 support, I also feel less inclined to 
>> keep xt_RAWNAT around.
>
>nf_nat depends on conntrack and conntrack brings a huge overhead to 
>such a simple task like NAT. xt_RAWNAT simply solves NAT problem, it
>definitely has to stay.

The only way to solve the NAT problem is to do without it.
Full NAT is not simple at all, it requires DPI.
RAWNAT is just a dumb l3addr replacer and does not help
getting multi-connection sessions (such as 959ish FTP) going.
