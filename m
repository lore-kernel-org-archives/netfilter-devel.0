From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] TCP window tracking over-window handling
Date: Wed, 2 Feb 2005 21:44:51 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0502022139470.25538@blackhole.kfki.hu>
References: <20050128234334.GA20713@linuxace.com>
	<Pine.LNX.4.58.0502021017590.24272@blackhole.kfki.hu>
	<20050202160009.GB30465@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050202160009.GB30465@linuxace.com>
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

On Wed, 2 Feb 2005, Phil Oester wrote:

> On Wed, Feb 02, 2005 at 10:46:01AM +0100, Jozsef Kadlecsik wrote:
> > That implies then that the receiver is broken as well, by accepting and
> > ack-ing out of window segments. But it is true, we anticipate the
> > behaviour of the receiver here, which we shouldn't.
>
> The receiver was a linux 2.6.10 box, so not an uncommon OS ;-)  The original
> problem was noted by clients on Win2K and WinXP against the same FTP server.

Then I'd like even better to understand how can it happen.

> > The current code follows closely TCP/IP Illustrated vol 2, p. 954: Trim
> > Segment so Data is Within Window.
> >
> > Do you know the OS of the communicating parties? Weren't window scaling or
> > SACK negotiated?
>
> The FTP server was an NT 4.0 box running IIS 3.0 ftp service.  As noted
> above, receiver was the Linux firewall itself.  There was no window
> scaling or SACK involved.

That it can't be due to some window scaling/SACK handling bug, at least.

> > With your proposed patch, we'd actually drop the oow segment. Could you
> > check that it won't cause problems (besides more logging generated :-)?
>
> I agree -- the oow segment is dropped, but this at least doesn't break
> the communication.  Without this patch, I cannot complete a large (5mb)
> download from this server.  With this patch, it never fails.
>
> Reviewing the ipfilter code, it doesn't seem the author included this check.
> So what was the rationale for including it in the netfilter version?  I
> can't think of what it is protecting us from.

I'm digging my mail folders to find the reports which triggered adding
that code segment.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
