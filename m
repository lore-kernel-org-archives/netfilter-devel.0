From: thomasmkling@arcor.de
Subject: Re: buckets-byte per conntrack
Date: Tue, 28 Jun 2005 13:11:53 +0200 (CEST)
Message-ID: <17682079.1119957113822.JavaMail.ngmail@webmail-07.arcor-online.net>
References: <20050627151027.GI4225@eychenne.org>
	<29003954.1119882475361.JavaMail.ngmail@webmail-07.arcor-online.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: rv@eychenne.org
In-Reply-To: <20050627151027.GI4225@eychenne.org>
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

 > I wrote a little document that might partially answer your questions:
> http://www.wallfire.org/misc/netfilter_conntrack_perf.txt


Thanks, this helps a lot. I am going to play around with these values and w=
atch what happens.

But one last thing, I did not yet understand:

>On systems with enough memory and where performance really matters, you ca=
n
>really consider trying to get an average of one conntrack entry by hash bu=
cket,
>that means HASHSIZE =3D CONNTRACK_MAX.
...
>So, on i386, kernel 2.6.5, size_of_mem_used_by_conntrack is around
>CONNTRACK_MAX * 300 + HASHSIZE * 8 (bytes).

When I compare the mem_used_by_conntrack in case of:
a) HASHSIZE =3D CONNTRACK_MAX and=20
b) default CONN_MAX=3DHASHSIZE * 8

I get almost no difference. Why is there not HASHSIZE =3D CONNTRACK_MAX by =
default?



Machen Sie aus 14 Cent spielend bis zu 100 Euro!
Die neue Gaming-Area von Arcor - =FCber 50 Onlinespiele im Angebot.
http://www.arcor.de/rd/emf-gaming-1
