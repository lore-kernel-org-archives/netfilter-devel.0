From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] don't try to track broadcasts or multicasts (4/4)
Date: Sat, 8 Jun 2002 09:35:47 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020608073547.GA1109@naboo.de.gnumonks.org>
References: <1023366027.845.30.camel@tux>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1023366027.845.30.camel@tux>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 06, 2002 at 02:24:05PM +0200, Martin Josefsson wrote:
> There exists code to disable tracking of broadcasts but it's insice a
> #if 0 / #endif in ip_conntrack_core.c and looks like some old debugging
> code as it has printk's and stuff.
> 
> this patch removes that chunk and replaces it with a check so if the
> packet is a broadcast or multicast we just return NF_ACCEPT since
> there's not much point in us trying to track it.

hm.  I would generally agree with you, but there is one issue which
needs to be looked into before considering this patch:

What happens if some client sends an ip-unicast diagram as link layer
broadcast?  How does the linux stack react to this?

If the packet is processed/routed the same way like any other ip-unicast
link-layer unicast packet, we still need to do tracking of broadcast
packets.

Could you try to look into that and keep us posted?

Thanks.

> /Martin

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
