From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 05/11] More __read_mostly
Date: Fri, 3 Nov 2006 13:05:41 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0611031304500.2974@tux.rsn.bth.se>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210913.710751547@wlug.westbo.se>
	<454B303F.2060407@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <454B303F.2060407@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 3 Nov 2006, Patrick McHardy wrote:

> Martin Josefsson wrote:
> > Place rarely written variables in the read-mostly section by using __read_mostly
> >
> > --- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_helper.c	2006-11-01 21:39:48.000000000 +0100
> > +++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_helper.c	2006-11-01 21:39:51.000000000 +0100
> > @@ -30,7 +30,7 @@
> >  #include <net/netfilter/nf_conntrack_helper.h>
> >  #include <net/netfilter/nf_conntrack_core.h>
> >
> > -static LIST_HEAD(helpers);
> > +static struct list_head helpers __read_mostly = { &(helpers), &(helpers) };
>
> Applied, but I changed this to static __read_mostly LIST_HEAD(helpers).

I thought I tried that and gcc barfed... maybe it was too late at night :)

/Martin
