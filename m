From: Francesco Sportolari <francesco@unipg.it>
Subject: Re: [PATCH] New behaviour for early_drop()
Date: Mon, 14 Apr 2003 17:34:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304141734.40065.francesco@unipg.it>
References: <200304141140.18647.francesco@unipg.it> <1050329196.11154.244.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1050329196.11154.244.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 14 April 2003 16:06, Martin Josefsson wrote:

> I've thought about something like this as well... The problem is that
> this probably makes it easier to attack a certain chain.=20

I don't think that, because if a chain is under attack, and we have not
reached the ip_conntrack_max limit, the hash collision will expand the li=
st
in each of the two cases (with or without my patch). It's true that my=20
early_drop() free more slots than the previous version, but the attacker,=
=20
when he's doing something nasty against a precise chain, a lot probably w=
ill=20
re-use one of its not-assured connections, keeping the overflow list=20
constantly of the same dimension.

-- Francesco
