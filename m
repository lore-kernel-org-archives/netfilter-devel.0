From: Willy TARREAU <willy@w.ods.org>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Sun, 29 Feb 2004 16:17:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229151700.GA26747@pcw.home.local>
References: <20040229145945.GA23662@pcw.home.local> <Pine.LNX.4.44.0402291610550.26823-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0402291610550.26823-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Feb 29, 2004 at 04:12:37PM +0100, Henrik Nordstrom wrote:
> On Sun, 29 Feb 2004, Willy TARREAU wrote:
> 
> > ==> This patches fixes it :
> > 
> > --- ./conntrack_nonat/info.orig	Sun Feb 29 15:47:49 2004
> > +++ ./conntrack_nonat/info	Sun Feb 29 15:47:19 2004
> > @@ -1,4 +1,4 @@
> >  Author: Jozsef Kadlecsik
> >  Status: Testing
> >  Repository: extra
> > -Depends: conntrack_locking.patch
> > +Depends: conntrack_locking
> 
> Also included in the jumbo patch sent yesterday..

Sorry Henrik,
Yesterday, I saw that you sent lots of pom-ng patches, but I didn't look
at them because I didn't think that pom-ng was so much advanced. Today,
I tried it for the first time, and looked back in the archives. I've found
some of them again, but not all it seems.

Cheers,
Willy
