From: Amin Azez <azez@ufomechanic.net>
Subject: RE: xt_gateway 20070605 (kernel)
Date: Sat, 16 Jun 2007 08:34:30 +0100
Message-ID: <200706160857.l5G8vhv24743@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

From: "Patrick McHardy" <kaber@trash.net>
Sent: 15/06/07 18:27
Subject: Re: xt_gateway 20070605 (kernel)

=3DSo far I don't intend to merge it, but I'm also not very opposed
=3Dto it (only reason against it is that its another file to take
=3Dcare of when changing say function signatures and it doesn't
=3Doffer anything that we can't already do). Its up to you to
convince me :)

It does one thing well and simply.
For most iptables users, realms is more complicated than replicating route =
information in the nat table.

Realms are perhaps suitable with a large routing infrastructure under one a=
dministration.

Xt_gateway removes the need for the more advanced explanations of the SNAT =
target that are required from time to time.

Xt_gateway is simple to manage snat when the gateways are out of administra=
tive control.

Xt_gateway is persisted solely with iptables-save.
There is no iproute-save (actually there is, I posted it to the relevant li=
st a few months back but no-one noticed).

I'm not going to try to convince you harder than this. Some directors and s=
hareholders (if they were aware) would probably prefer that you did NOT mer=
ge it to the mainline kernel and I also have a duty to them.

However I thank you (and more particularly Jan) for the time you have spent=
 on this.

Sam=
