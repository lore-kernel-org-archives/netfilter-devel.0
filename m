From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PPTP conntrack with CONFIG_NETFILTER_DEBUG is broken (was:
	newnat and patch-o-matic)
Date: 22 Sep 2002 12:30:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1032690651.9594.13.camel@tux>
References: <87d6r9jaa4.fsf@sensi.yemanja.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?C=E9dric?= Rivard <cedric@yemanja.net>
In-Reply-To: <87d6r9jaa4.fsf@sensi.yemanja.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2002-09-20 at 11:11, C=E9dric Rivard wrote:
> Hi all,
>=20
> As I've already reported, there is a problem with the PPTP conntrack modu=
le of pom. It can't be built with the option CONFIG_NETFILTER_DEBUG. And I =
still receive questions about the first thread I started on this problem bu=
t without pointing the cause.
> I hope that everyone is now aware of this issue.

This issue came to my attention in the end of August, I produced a patch
and I never heard from that person again. The patch is quite ugly but it
does solve this specific problem. I was waiting for some more input from
other developers before submitting it to cvs but now I've given up on
that and I've submitted it. patch-o-matic in cvs now works with
debugging enabled.

or you can apply this patch on your kernel after patching with the
patch-o-matic you are currently using:

http://www.netfilter.org/~gandalf/patches/ip_conntrack_proto_gre.c-lockfix

--=20
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
