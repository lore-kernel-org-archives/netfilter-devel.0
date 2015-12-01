From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#806130: linux: netlink_sock_destruct() crash in netns
Date: Tue, 01 Dec 2015 23:25:35 +0000
Message-ID: <1449012335.30642.44.camel@decadent.org.uk>
References: <144838019931.22302.9425487048881510008.reportbug@deathstar.cica.es>
	 <1448576098.27159.62.camel@decadent.org.uk> <20151128224720.GA2296@salvia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-b50YUnS4XLWxRFtsJ7F/"
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	806130@bugs.debian.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47881 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757286AbbLAXZu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2015 18:25:50 -0500
In-Reply-To: <20151128224720.GA2296@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-b50YUnS4XLWxRFtsJ7F/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2015-11-28 at 23:47 +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 26, 2015 at 10:14:58PM +0000, Ben Hutchings wrote:
> > On Tue, 2015-11-24 at 16:49 +0100, Arturo Borrero Gonzalez wrote:
> > > Source: linux
> > > Version: 4.2.6-1
> > > Severity: normal
> > >=20
> > > Dear Maintainer,
> > >=20
> > > thanks for your work in the linux kernel.
> > >=20
> > > I'm experimenting reports like this:
> > >=20
> > > [mar nov 24 16:38:16 2015] ------------[ cut here ]------------
> > > [mar nov 24 16:38:16 2015] WARNING: CPU: 1 PID: 22224 at /build/linux=
-CrHvZ_/linux-4.2.6/net/netlink/af_netlink.c:946 netlink_sock_destruct+0x10=
3/0x140()
> > > [mar nov 24 16:38:16 2015] Modules linked in: nft_nat nft_chain_nat_i=
pv4 nf_nat_ipv4 nf_nat nft_log fuse uas usb_storage nft_counter nf_conntrac=
k_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nft_ct nf_conntrack =
nft_meta nft_hash nft_rbtree nfnetlink_log nf_tables_inet nf_tables_ipv6 nf=
_tables_ipv4 nf_tables nfnetlink nouveau snd_hda_codec_idt snd_hda_codec_ge=
neric mxm_wmi wmi video ttm drm_kms_helper drm iTCO_wdt i2c_algo_bit iTCO_v=
endor_support coretemp kvm_intel lpc_ich kvm snd_hda_intel mfd_core i2c_i80=
1 snd_hda_codec evdev snd_hda_core pcspkr psmouse serio_raw snd_hwdep snd_p=
cm sg rng_core tpm_tis tpm 8250_fintek shpchp button snd_timer snd soundcor=
e acpi_cpufreq processor thermal_sys parport_pc ppdev lp parport autofs4 ex=
t4 crc16 mbcache jbd2 dm_mod sr_mod cdrom sd_mod ata_generic floppy ata_pii=
x e100
> > > [mar nov 24 16:38:16 2015]=C2=A0=C2=A0mii libata scsi_mod ehci_pci uh=
ci_hcd ehci_hcd usbcore usb_common
> > > [mar nov 24 16:38:16 2015] CPU: 1 PID: 22224 Comm: bash Tainted: G=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0W=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A04.2.0-1-amd64 #1 Debian 4.2.6-1
> > [...]
> > > I can reproduce the issue:
> > >=20
> > > =C2=A0% sudo ip netns add test
> > > =C2=A0% sudo ip netns exec test nft -f test.nft
> > > =C2=A0% sudo ip netns del test
> > >=20
> > > Find attached the test.nft file.
>=20
> sk=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Eth Pid=C2=A0=C2=A0=C2=A0=C2=
=A0Groups=C2=A0=C2=A0=C2=A0Rmem=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Wmem=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0Dump=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Locks
> Drops=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0Inode
> ffff8800cbb11000 0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
00000000 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A00 19855=C2=A0=C2=A0=C2=A0
> ffff88011504f800 4=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
00000000 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A00 19877=C2=A0=C2=A0=C2=A0
> ffff8801153f7000 9=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
00000000 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A00 19876=C2=A0=C2=A0=C2=A0
> ffff880030c23000 10=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A000000=
000 0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A00 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A00 19858=C2=A0=C2=A0=C2=A0
> ffff8800cbabb800 12=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A000000=
000 -4544=C2=A0=C2=A0=C2=A0=C2=A00=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A00 2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A00 19890=C2=A0=
=C2=A0=C2=A0
>=20
> wmem is underflowing.
>=20
> Could you check if this also happening in older kernel versions?

Same happens on 3.18. =C2=A0The current version of nft doesn't run on 3.17
or earlier.

Ben.

> No need to test under netns, you can just run nft -f and check
> /proc/net/netlink.
>=20
> Let me know, thanks.
--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers
--=-b50YUnS4XLWxRFtsJ7F/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVl4sb+e/yOyVhhEJAQp8mxAAlVu9xYPmUoG6MI9KOinaelpB/mNrcGnd
9+9EDXYJw6sHb6Jtz/v+sAeoxcqkW8gzUM1rk8JP3bRa78jBVWysa4tTyvucLcZj
xGsOSUfZNrE5hP155IBd53uddGkVYuC4gMR3Q8dNP9DMRQpbTjpGbPyh3KE/hIpx
V7b705anpblqQ1uiIqpEwEHs16vZx6nxOIxegUtE06QHryCoKYi6My2HdokHA2BR
1n2YwpYCzUZjfiGZIo2TPcC2jW4fVci4kq1UDknoyhRlBHy7HB3lpp5er/cpeK/T
F9qogJT54rKSdA4Z3qOq36T32K14Wk6cHstWIfq4ma3HK914shVcLEdQCF3YNSEb
jQ/VbnrXGPOMgaXWnE+WcLB64HyaViLcUlEbzjy62ESUMk389XdUuDmoxBlfVDcY
OqdsKEqDGi1FJFH/ou2PNzRIn+Icvvnw2IB4Kxb9/GjIbScuuBGiQDwyq6NEo8jm
4lkXgAAaRRKEGTkfY89bCtVusvuXwn2JT7dQeEpjb5IzWmoHeJUqG2KcnSEvM60N
nE6INUz/oU2Gyxb6XtJkuyA5lGcLf8BwutEwhVFcJR/AofDFwmrA/s0ORxgstxLe
Z+KBmduPurnxYnuBv4Ti5VSk4hJVk8LLpMTybmRq/0mWrpPQuixIJ7/TaZ1PNzRq
KSPbP+4L+/Y=
=j8JC
-----END PGP SIGNATURE-----

--=-b50YUnS4XLWxRFtsJ7F/--
