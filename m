From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: SACK out of window segments?
Date: Wed, 20 Jul 2005 22:24:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0507202219360.26391@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0507201213110.25054@blackhole.kfki.hu>
	<20050720.122652.28782810.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>,
	KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <20050720.122652.28782810.davem@davemloft.net>
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

On Wed, 20 Jul 2005, David S. Miller wrote:

> From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Date: Wed, 20 Jul 2005 12:34:02 +0200 (CEST)
>
> > https://lists.netfilter.org/pipermail/netfilter-devel/2005-July/020292.html
>  ...
> > It seems that at least Linux 2.4.25 accepts and (S)ACKs segments which
> > otherwise looks to be out of window ones. In order to cope with that I had
> > to add code to the TCP connection tracking part of netfilter.
> >
> > The question is wether that was a SACK bug in 2.4.25? Or there's something
> > in the RFCs we overlook and what looks like a violation is actually an RFC
> > conformant feature?
>
> What is running on the sender in that trace in the quoted URL above?
>
> That last packet is definitely out of window, from the trace's point
> of view, but I'm very suspicious that any stack would do that,
> especially Linux.

According to Krisztian's last mail in the thread:

>>>>>>

> Krisztian, could you write the OS type/version on both the server and
> the client?

  The client was Linux 2.4.25 plus a couple of other patches, neither of
which modified core TCP code. On top of that it had Jozsef's TCP window
tracking patch applied (from POM at that time).

  Unfortunately the server was completely out of our control. As it was
a public webserver, we tried Netcraft, and the results were the
following:

OS             Server              Last changed  IP address     Netblock
Owner
Windows 2000   Microsoft-IIS/5.0   18-Aug-2003   XXX.XX.XX.XXX  XXXXXXXX

  So that's all I know about the server. I can provide the exact URL we
tried if anyone's interested (in private mail only). I have absolutely
no idea whether or not it is still reproducible.
<<<<<<<

So I believe the trace was produced on the client itself, running Linux
2.4.25.

Krisztian, is that assumption correct? Or did you run tcpdump on the
perimeter somewhere?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
