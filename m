From: "Gary W. Smith" <gary@primeexalia.com>
Subject: RE: pptp-conntrack-nat & kernel 2.6.11
Date: Sat, 15 Oct 2005 19:17:40 -0700
Message-ID: <57F9959B46E0FA4D8BA88AEDFBE582900B586A@pxtbenexd01.pxt.primeexalia.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Antonio" <anton.ananich@gmail.com>, "Harald Welte" <laforge@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Antonio,=20

You are missing the flag to turn on proto_gre.  That's why it's not
available to you.

--- kernel-2.6.9-i686.config.orig       2005-01-05 16:17:41.000000000
-0800
+++ kernel-2.6.9-i686.config    2005-02-22 11:58:30.000000000 -0800
@@ -640,6 +640,14 @@
 CONFIG_IP_NF_CT_PROTO_SCTP=3Dm
 # CONFIG_IP_NF_COMPAT_IPCHAINS is not set
 # CONFIG_IP_NF_COMPAT_IPFWADM is not set
+CONFIG_IP_NF_MATCH_CONNLIMIT=3Dm
+CONFIG_IP_NF_TARGET_TARPIT=3Dm
+CONFIG_IP_NF_NAT_H323=3Dm
+CONFIG_IP_NF_H323=3Dm
+CONFIG_IP_NF_CT_PROTO_GRE=3Dm
+CONFIG_IP_NF_PPTP=3Dm
+CONFIG_IP_NF_NAT_PPTP=3Dm
+CONFIG_IP_NF_NAT_PROTO_GRE=3Dm
=20
 #
 # IPv6: Netfilter Configuration
@@ -947,7 +955,8 @@
 CONFIG_PPP_SYNC_TTY=3Dm
 CONFIG_PPP_DEFLATE=3Dm
 CONFIG_IPPP_FILTER=3Dy
-# CONFIG_PPP_BSDCOMP is not set
+CONFIG_PPP_BSDCOMP=3Dm
+CONFIG_PPP_MPPE=3Dm
 CONFIG_PPPOE=3Dm
 # CONFIG_SLIP is not set

> -----Original Message-----
> From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-
> bounces@lists.netfilter.org] On Behalf Of Antonio
> Sent: Friday, October 14, 2005 2:24 PM
> To: Harald Welte
> Cc: Netfilter Development Mailinglist; Netfilter Mailinglist
> Subject: Re: pptp-conntrack-nat & kernel 2.6.11
>=20
> On 10/13/05, Antonio <anton.ananich@gmail.com> wrote:
> > Dear Harald!
> >
> > On 10/12/05, Harald Welte <laforge@netfilter.org> wrote:
> > > if you compile a kernel with static support for pptpconntrack+nat,
you
> > > will see neither of the two in "lsmod".  Can you please send me
> > > (privately) your kernel .config file that was used for the
"statically
> > > linked" kernel, and (if possible) also the kernel binary itself?
> >
> > To reproduce my kernel configuration you need:
> > 1) kernel 2.6.14-rc3
> > 2) patch for mppe&mppc support (in attachment)
> > 3) .config.old (also in attachment)
> >
> > file .config contains config which works fine
> >
> > --
> > Best Regards,
> > Antonio
> >
>=20
> I'm still trying to make NAT work. Now I'm using kernel 2.6.14-rc3.
> And I whant to say that it almost working! :) My Linux box connects to
> Internet through router. But everyone else (who uses Windows) have not
> this happy possibility...
>=20
> I think that reason is There is no modules ip_conntrack_proto_gre and
> ip_nat_proto_gre anywhere :(  When I was using kernel 2.4 there was
> not such troubles with PPTP and NAT integration...
>=20
> How can I enable connaction tracking & nat for the gre protocol? Is it
> neccessary? Is it a reason of gre packets loss?
>=20
> Additional information:
>=20
> servak linux # cat .config | grep GRE
> CONFIG_NET_IPGRE=3Dy
> # CONFIG_NET_SCH_GRED is not set
> CONFIG_NET_SCH_INGRESS=3Dy
> servak linux # cat .config | grep PPTP
> CONFIG_IP_NF_PPTP=3Dm
> CONFIG_IP_NF_NAT_PPTP=3Dm
> servak linux # cat .config | grep NAT
> CONFIG_IP_NF_NAT=3Dm
> CONFIG_IP_NF_NAT_NEEDED=3Dy
> # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
> CONFIG_IP_NF_NAT_IRC=3Dm
> CONFIG_IP_NF_NAT_FTP=3Dm
> CONFIG_IP_NF_NAT_PPTP=3Dm
> # CONFIG_NATSEMI is not set
>=20
> I'm using the only one rule
> $IPTABLES -t nat -A POSTROUTING -o eth1 -j MASQUERADE
>=20
> I hope it will be helpful to take a look at ethereal output from
attach.
>=20
> --
> Best Regards,
> Antonio
