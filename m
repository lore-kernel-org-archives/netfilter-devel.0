From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: libipt_physdev.c?
Date: Thu, 5 Dec 2002 19:13:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200212051913.38091.bdschuym@pandora.be>
References: <20021205141016.36016.qmail@web40905.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Chapman <kakadu_croc@yahoo.com>,
	Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021205141016.36016.qmail@web40905.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Forgive my ignorance, but what does ipt_physdev.c do in the kernel? Wha=
t
> does it match?

This matches on the physical in and out device of bridges when one uses t=
he=20
bridge and netfilter in the 2.5 kernel.
So, if the (logical) bridge device br0 has the (physical) ports eth0 and =
eth1=20
and a IP packet arrives on the bridge via the eth0 port, the ipt_physdev.=
c=20
module allows you to filter this IP packet by specifying the eth0 physica=
l=20
in-dev. Without ipt_physdev.c one can only filter on the logical br0 devi=
ce,=20
which is not good enough for various reasons.

--=20
cheers,
Bart
