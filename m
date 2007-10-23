From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH 08/13] Split Netfilter IPv4 defragmentation into a separate
 module
Date: Tue, 23 Oct 2007 20:26:32 +0200
Message-ID: <200710232026.32866@nessa>
References: <20071002203942.11052.7303.stgit@nessa.odu>
 <20071002204349.11052.18611.stgit@nessa.odu>
 <Pine.LNX.4.64.0710172108180.8216@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:62188 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbXJWS0j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Oct 2007 14:26:39 -0400
Received: from ip6-localhost ([152.66.208.5])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTP id <0JQD00BFTN5D5D90@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Tue, 23 Oct 2007 20:24:50 +0200 (CEST)
In-reply-to: <Pine.LNX.4.64.0710172108180.8216@bizon.gios.gov.pl>
Content-disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Krzysztof,

On Wednesday 17 October 2007, Krzysztof Oledzki wrote:
> On Tue, 2 Oct 2007, KOVACS Krisztian wrote:
> > Netfilter connection tracking requires all IPv4 packets to be
> > defragmented. Both the socket match and the TPROXY target depend on
> > this functionality, so this patch separates the Netfilter IPv4 defrag
> > hooks into a separate module.
>
> With this patch taken from:
>  
> http://people.netfilter.org/hidden/tproxy/tproxy4-2.6.23-200710090922.t
>ar.bz2 with:
> # CONFIG_NF_CONNTRACK_ENABLED is not set
> # CONFIG_NF_CONNTRACK is not set
>
> I get:
>
> net/ipv4/netfilter/nf_defrag_ipv4.c: In function
> 'ipv4_conntrack_defrag': net/ipv4/netfilter/nf_defrag_ipv4.c:44: error:
> 'struct sk_buff' has no member named 'nfct' make[3]: ***
> [net/ipv4/netfilter/nf_defrag_ipv4.o] Error 1
> make[2]: *** [net/ipv4/netfilter] Error 2
> make[1]: *** [net/ipv4] Error 2
>
> This is not a surprise since:
> --- cut here ---
> #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
>          struct nf_conntrack     *nfct;
>          struct sk_buff          *nfct_reasm;
> #endif
> --- cut here ---

Thanks for spotting this, indeed, this was an oversight from my part... 
The latest tree at http://people.netfilter.org/hidden/tproxy/ should fix 
this compilation problem.

-- 
KOVACS Krisztian
