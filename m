From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: GnomeMeeting STUN
Date: Mon, 5 Jan 2004 12:47:42 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0401051236450.15139-100000@blackhole.kfki.hu>
References: <1072370922.680.6.camel@golgoth01>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Damien Sandras <dsandras@seconix.com>
In-Reply-To: <1072370922.680.6.camel@golgoth01>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 25 Dec 2003, Damien Sandras wrote:

> > I assume all we have to offer is ip_conntrack/nat_h323, which is in
> > patch-o-matic but has been reported not to work with gnomemeeting (but
> > with netmeeting) in the past ?  We'd be happy to receive any feedback
> > you would have regarding that subject.
>
> I will do my best. I already had sent some information to Joszef a long
> time ago, but I think it was lost.

No, it was not lost (if I did not respond to you, then I'm sorry): I put
h323-conntrack-nat aside as there was more important issues to be dealt
with. (And since then the ethereal code has been released with an H.323
parser, written in pure C...)

> The problem with the conntrack approach is that we will also have to do
> the same kind of connection tracker for the SIP protocol :(

It's not so bad at all: the nfnetlink/ctnetlink interface is about to be
finished, which will give us the full power to solve such problems, in the
most efficient way:

- we can keep the kernel modules for the simple cases
- can delegate the problem to userspace processes for complicated ones
  (DNS lookups, ets.)

Just time and some human resources are required :-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
