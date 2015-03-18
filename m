From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Re: [PATCH 1/3] Add revision field for xt_entry_target
Date: Wed, 18 Mar 2015 11:07:13 +0100
Message-ID: <20150318100713.GA2774@salvia>
References: <A43879EB4A7F5F449E2CA8148EA79E516C88A2@G08CNEXMBPEKD01.g08.fujitsu.local>
 <20150318094449.GA7279@salvia>
 <A43879EB4A7F5F449E2CA8148EA79E516CAE20@G08CNEXMBPEKD01.g08.fujitsu.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Zhang, Chunyu" <zhangcy@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40708 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbbCRKDW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 06:03:22 -0400
Content-Disposition: inline
In-Reply-To: <A43879EB4A7F5F449E2CA8148EA79E516CAE20@G08CNEXMBPEKD01.g08.fujitsu.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 18, 2015 at 09:59:59AM +0000, Zhang, Chunyu wrote:
> >Please, resubmit this patch once you have extended the
> >userspace arp mark extension to exactly mirror what mark can do in
> >iptables/ip6tables.
>
> ok, i will do it for revision
> also add --and-mark and --or-mark
> maybe too many code to add.

Please, add exactly the same:

"MARK target options:\n"
"  --set-mark value                   Set nfmark value\n"
"  --and-mark value                   Binary AND the nfmark with value\n"
"  --or-mark  value                   Binary OR  the nfmark with value\n");

We'll have arptables-compat over nftables ready soon, and things get
easier for us if we get arptables in sync with iptables.

Thanks.
