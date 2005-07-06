From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [PATCH] TCP window tracking patch backported from the 2.6 tree
Date: Wed, 06 Jul 2005 14:37:01 +0200
Message-ID: <1120653421.5642.13.camel@nienna.balabit>
References: <Pine.LNX.4.58.0506281201590.12765@blackhole.kfki.hu>
	<42C17443.60909@drugphish.ch>
	<Pine.LNX.4.58.0506290926400.14936@blackhole.kfki.hu>
	<42C26765.2060304@tac.ch>
	<Pine.LNX.4.58.0506291223440.14974@blackhole.kfki.hu>
	<20050629145545.GO26761@insomnia.benzedrine.cx>
	<Pine.LNX.4.58.0506300903350.16566@blackhole.kfki.hu>
	<20050630111344.GP26761@insomnia.benzedrine.cx>
	<Pine.LNX.4.58.0507011150500.19392@blackhole.kfki.hu>
	<20050706111546.GI6024@insomnia.benzedrine.cx>
	<Pine.LNX.4.58.0507061332170.3713@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Daniel Hartmeier <daniel@benzedrine.cx>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Roberto Nibali <ratz@tac.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0507061332170.3713@blackhole.kfki.hu>
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


  Hi,

2005-07-06, sze keltez=E9ssel 13.40-kor Jozsef Kadlecsik ezt =EDrta:
> > What stacks do generate (and accept) this? Do they do this on purpose=
?
> > If so, how well do they react if they get sent malicious SACK section=
s,
> > trying to use up as much buffer space as possible? Sounds like a DoS
> > waiting to happen.
>=20
> Krisztian, could you write the OS type/version on both the server and t=
he
> client?

  The client was Linux 2.4.25 plus a couple of other patches, neither of
which modified core TCP code. On top of that it had Jozsef's TCP window
tracking patch applied (from POM at that time).

  Unfortunately the server was completely out of our control. As it was
a public webserver, we tried Netcraft, and the results were the
following:

OS             Server              Last changed  IP address     Netblock =
Owner
Windows 2000   Microsoft-IIS/5.0   18-Aug-2003   XXX.XX.XX.XXX  XXXXXXXX

  So that's all I know about the server. I can provide the exact URL we
tried if anyone's interested (in private mail only). I have absolutely
no idea whether or not it is still reproducible.

--=20
 Regards,
  Krisztian Kovacs
