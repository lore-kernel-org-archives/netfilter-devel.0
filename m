From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ip_conntrack_get
Date: Wed, 12 Nov 2003 00:55:01 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311120051400.14633-100000@filer.marasystems.com>
References: <3FB16B63.8070603@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: pablo neira <pablo@eurodev.net>
In-Reply-To: <3FB16B63.8070603@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 12 Nov 2003, pablo neira wrote:

> Actually nf_conntrack doesn't look like ip_conntrack structure anyway.

Well.. it does. If you look closely at ip_conntrack you will notice the 
first member is a nf_conntrack, making ip_conntrack a superset of 
nf_conntrack.

> I also don't understand the way ctinfo is calculate. This stuff...
> 
> 403 <http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L403>         *//* ctinfo is the index of the nfct inside the conntrack *//*
> 404 <http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L404>         *ctinfo = nfct - ct->infos;

Neither do I.. but then I have never needed to care as ip_conntrack_get()  
and the conntrack core does a good job of hiding the magics in that area.. 
it is probably quite simple reasons behind this odd looking construct.

Regards
Henrik
