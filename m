From: Jakub Wartak <vnulllists@pcnet.com.pl>
Subject: Re: hashlimit module parameters
Date: Sun, 25 Sep 2005 09:19:31 +0200
Message-ID: <200509250919.32532.vnulllists@pcnet.com.pl>
References: <43329209.8040607@astral.ro>
	<20050922215104.GU26520@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Imre Gergely <imre.gergely@astral.ro>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050922215104.GU26520@sunbeam.de.gnumonks.org>
Content-Disposition: inline
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

Dnia czwartek, 22 wrze=B6nia 2005 23:51, Harald Welte napisa=B3:
> On Thu, Sep 22, 2005 at 02:14:17PM +0300, Imre Gergely wrote:
> > hi
> >
> > i was wondering about something. i want to use this hashlimit module,
> > and the doc says the --hashlimit parameter is just like the one in the
> > limit match, but when i want to do
> >
> > /usr/local/iptables-1.3.3-20050921/sbin/iptables -A INPUT -s 1.1.1.1 -m
> > hashlimit --hashlimit ! 5/sec --hashlimit-mode srcip --hashlimit-name
> > test -j ACCEPT
> >
> > it gives me an error:
> >
> > iptables v1.3.3-20050921: hashlimit does not support invert
> > Try `iptables -h' or 'iptables --help' for more information.
> >
> > is there a way to specify an invert to this ?
>
> I don't think so, sorry :(  Seems like I forgot to take care of limit
> inversion.  Patches welcome.

I resolved it using RETURN target, examples here:
http://vnull.pcnet.com.pl/nf/pomysly_netfilter3.pdf

It is written in polish, but I think that the examples are easy to=20
understand :)

=2D-=20
Jakub Wartak
=2Dvnull
=46reeBSD/OpenBSD/Linux/Solaris/Network Administrator
http://vnull.pcnet.com.pl/
