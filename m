From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] RFC3514 packet filtering
Date: Fri, 2 Apr 2004 04:07:59 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404020332290.11217-100000@filer.marasystems.com>
References: <406CBE16.7090409@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Hugo Mills <hugo@soton.ac.uk>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <406CBE16.7090409@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2 Apr 2004, Pablo Neira wrote:

> mmm, 1st april? evil bit? a RFC made last year but 1st april? and the 
> implementation is posted 1th april but one year later... mmm...
> 
> regards,
> Pablo
> 
> P.S: mmm... hehehehehehe. Please if so, laugh at me, but there's 
> something which is not serious here... anyway, am I missing anything?

Maybe you should read the RFC... it has some "interesting" ideas on how to
secure the Internet which could (if it worked) eleminate the need for 
advanced firewalls..

But one interesting detail.. when reading this patch I noticed the IP_CE
bit reference.. this is defined using the same bit as evil bit.. I can not
find which RFC this IP_CE bit is supposedly defined, only the CE bit in
ECN which is a completely different bit. I wonder if this is a bug or just
old remains from some early draft before the first ECN RFC... IP_CE is
only used logging purposes from ipt_LOG.c and FreeSWAN ipsec_tunnel.c..

Regards
Henrik
