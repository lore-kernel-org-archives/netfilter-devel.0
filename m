From: Amin Azez <azez@ufomechanic.net>
Subject: RE: xt_gateway 20070605 (kernel)
Date: Sat, 16 Jun 2007 10:29:21 +0100
Message-ID: <200706161052.l5GAqYv25389@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
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


From: "Jan Engelhardt" <jengelh@computergmbh.de>
Sent: 16/06/07 08:59
Subject: RE: xt_gateway 20070605 (kernel)

=3DWell, it is as complicated as policy routing
=3D(e.g. using -j MARK and iproute2's fwmark match)
=3D
=3Dip route add 1.3.3.7/32 dev leet0 realm 666
=3Diptables -t nat -A POSTROUTING -m realm --realm 666 -j=20
=3DSNAT --to whatever.

Yeah, you have to have one realm per snat-ip or better, which is more compl=
icated than just using the gateway ip.

It's true that you can use realm to make an association between gateway and=
 snat address, but why bother if you can use gateway to make an association=
 between gateway and snat address.

To use realm requires fiddling with routing tables (which I can do pleasant=
ly as iproute-save supports xml) but gateway match lets users leave routing=
 to be managed by their network scripts instead of managing it by hand.=20

=3D>Xt_gateway is persisted solely with iptables-save. There is no iproute-=
save
=3D>(actually there is, I posted it to the relevant list a few months back =
but
=3D>no-one noticed).

=3Diproute-save would have a problem: it may interfere with
=3D (a) 'proto kernel' rules

My iproute-restore did not restore proto kernel routes, or flush them prior=
 to a restore.

=3D (b) rules from the distribution (e.g. =3D/etc/sysconfig/network/ifroute=
s)
=3D    [lesser a problem]

Likewise, scope helped recognize these.

=3D>I'm not going to try to convince you harder than this. Some directors a=
nd
=3D>shareholders (if they were aware) would probably prefer that you did NO=
T merge
=3D>it to the mainline kernel and I also have a duty to them.

=3DWhat would they care about how it's done?

They might prefer that anything that made things easier were not available =
outside of the source CD that we ship with the box. There is no official co=
mpany policy on this yet, and I prefer it that way.

The gateway match makes things easier for me. All our customers will be usi=
ng it. I'm happy to share it.

If Patrick judges it to be unneccessary then I don't feel very inclined to =
argue the point. I agree that authors cannot insist that their contribution=
s be recommended upstream and linux is not so scarce of features that this =
is remotely necessary.

Like my iptables vlan match and conntrack direction match, account + rate l=
imiting, and probably the same way as my next connroute target all of which=
 are useful to me, I'm disapointed that they won't have wider use, but not =
frantic.

Sam=
