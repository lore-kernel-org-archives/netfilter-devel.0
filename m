From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: CONNMARK Patching Problem
Date: 12 Nov 2002 11:11:34 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1037095894.4403.25.camel@tux>
References: <005a01c287e5$2d0862a0$0200000a@parseerror.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matias =?ISO-8859-1?Q?Bj=F8rling?= <mb@ncparty.dk>
In-Reply-To: <005a01c287e5$2d0862a0$0200000a@parseerror.dk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2002-11-09 at 12:43, Matias Bj=F8rling wrote:
> Hey! :D
>=20
> I'm having a very anoying problem.
>=20
> I have patched 2.4.18-19 kernels where both have the same problem, when i
> run patch-o-magic on a fresh kernel, then when i come to where i can patc=
h
> the CONNMARK module into the kernel, it always fail, even if it's the onl=
y
> thing i select, and with both kernels, even they both are fresh installed=
.

> iptables 1.2.7a
> patch-o-magic 20021008
> have tried with newer cvs image patch-o-magic and did'nt even work
> kernel 2.4.18-19 both have the same problem.
>=20
> Does anybody know if theres a workaround for this thingie?.. or am i just
> lost in my dreams until a new release come? Is there a way i can check wh=
at
> the error is?

You've failed to read the docs :)

you didn't run ./runme --batch pending
after that CONNMARK works fine.

(two patches in pending won't apply correctly, they need to be applied
after the newnat patch and not before (just run the same command one
more time and they should apply), I've just fixed it in cvs)

--=20
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
