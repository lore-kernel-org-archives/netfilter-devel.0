From: Willy TARREAU <willy@w.ods.org>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Sun, 29 Feb 2004 15:59:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040229145945.GA23662@pcw.home.local>
References: <20040229101116.GA10012@pcw.home.local> <Pine.LNX.4.44.0402291121270.25361-100000@filer.marasystems.com> <20040229142939.GE15558@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
   Henrik Nordstrom <hno@marasystems.com>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040229142939.GE15558@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, Feb 29, 2004 at 03:29:39PM +0100, Harald Welte wrote:
> On Sun, Feb 29, 2004 at 11:25:06AM +0100, Henrik Nordstrom wrote:
> > On Sun, 29 Feb 2004, Willy TARREAU wrote:
> > 
> > >   - first, I didn't find how to specify where my iptables sources is
> > >     installed, so I had to enter it by hand each time I restarted it.
> > >     I did not find any env variable in the perl code, and I must say
> > >     that my understanding of perl is, hmmm.. very limited.
> > 
> > There is a --path= option which can specify the path to both iptables and 
> > the kernl.
> 
> JFYI: I just changed that option to have a more obvious name (and not encode
> two path names within a single parameter), as well as documentign it via
> './runme --help'

This is a good thing, because I only found with successive attempts that I needed
to set exactly --path=<kernel_dir>:<iptables_dir>

I've just checked out the CVS, but there's something new :

./runme --path=/usr/src/linux-2.4.25-pomng:/users/willy/download/iptables-1.2.9 conntrack_locking
=> OK

./runme --path=/usr/src/linux-2.4.25-pomng:/users/willy/download/iptables-1.2.9 conntrack_nonat
   The patch depends on the conntrack_locking.patch.
-----------------------------------------------------------------
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
conntrack_nonat has dependency on conntrack_locking.patch, but conntrack_locking.patch is not known
-----------------------------------------------------------------
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?]


==> This patches fixes it :

--- ./conntrack_nonat/info.orig	Sun Feb 29 15:47:49 2004
+++ ./conntrack_nonat/info	Sun Feb 29 15:47:19 2004
@@ -1,4 +1,4 @@
 Author: Jozsef Kadlecsik
 Status: Testing
 Repository: extra
-Depends: conntrack_locking.patch
+Depends: conntrack_locking


Regards,
Willy
