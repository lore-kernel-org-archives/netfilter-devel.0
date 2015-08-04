From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: IPv6 support for GRE helper(nf_conntrack_proto_gre)
Date: Tue, 4 Aug 2015 19:24:56 +0200
Message-ID: <20150804172456.GA3996@salvia>
References: <1438708480.1197054.347597513.3BF1F74D@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Aju L Francis <aju@iraw.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57266 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbbHDRTM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 13:19:12 -0400
Content-Disposition: inline
In-Reply-To: <1438708480.1197054.347597513.3BF1F74D@webmail.messagingengine.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 04, 2015 at 01:14:40PM -0400, Aju L Francis wrote:
> Hello,
> 
>     We are trying to implement GRE over IPv6 on Linux running kernel
>     3.13.0-53. But found that IPv6 traffic is being marked as INVALID by
>     netfilter. Wanted to know if there is any effort on having IPv6
>     support for the GRE helper nf_conntrack_proto_gre.

No ongoing efforts in that direction that I'm aware of.
