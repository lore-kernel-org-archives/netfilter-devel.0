From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Stange ip_conntrack (newnat) behaviour.
Date: Tue, 4 Jun 2002 10:06:21 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206040957240.6390-100000@blackhole.kfki.hu>
References: <200206031640.g53Ge3j14419@mint.home.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "A. van Schie" <a.van.schie@quicknet.nl>
In-Reply-To: <200206031640.g53Ge3j14419@mint.home.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 3 Jun 2002, A. van Schie wrote:

> > > What I find strange is that it starts with 2 almost the same packets
> > > (except for ip_id), and that they both get the conntrack state NEW!
> >
> > What else state should they got? But those first two packets looks
> > strange, that's true.
>
> I expected that conntrack gives the second packet the state ESTABLISHED,
> because all fields that conntrack checks are equal, or is there some other
> special tcp connection tracking code that I missed.

>From conntrack point of view all parameters of the first two packets are
identical, so the second one is a resent packet. There was no response
yet from the destination, therefore the state remains the same: NEW.

> And I didn't expected the third "response" packet to be DROPPED.

This is the first response. :-). But it should not be dropped. :-(

> > > I think there is a problem in conntrack,
> > > maybe the newnat patch or the "double packet" is introduced in the
> > > kernel.
> >
> > If you suspect something like that, then start tcpdumping both involved
> > interfaces and look at the generated logs.
>
> I'm not to handy with that tool, I hope that the current netfilter logging is enough
> to see what has happend.

If you suspect that the kernel generates packets just out of the blue,
then the netfilter logging alone won't help. One has to compare what one
can catch on the interface itself (by tcpdump) and compare the result with
the netfilter logging.

> > Did you applied other patches from p-o-m?
[..]
>                  extra/tcp-window-tracking

Don't you see any logs about out of window packets?

If yes, I'd suggest to use the new version of the tcp-window-tracking
patch. There were problems with window scaling support in the older
versions of the patch, which could break connections.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
