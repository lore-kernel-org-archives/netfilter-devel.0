From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Bug#806130: linux: netlink_sock_destruct() crash in netns
Date: Thu, 26 Nov 2015 22:14:58 +0000
Message-ID: <1448576098.27159.62.camel@decadent.org.uk>
References: <144838019931.22302.9425487048881510008.reportbug@deathstar.cica.es>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Q+LUz1B/+5lMfLVbCy7R"
Cc: 806130@bugs.debian.org, netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51095 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823AbbKZWPO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 17:15:14 -0500
In-Reply-To: <144838019931.22302.9425487048881510008.reportbug@deathstar.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-Q+LUz1B/+5lMfLVbCy7R
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-11-24 at 16:49 +0100, Arturo Borrero Gonzalez wrote:
> Source: linux
> Version: 4.2.6-1
> Severity: normal
>=20
> Dear Maintainer,
>=20
> thanks for your work in the linux kernel.
>=20
> I'm experimenting reports like this:
>=20
> [mar nov 24 16:38:16 2015] ------------[ cut here ]------------
> [mar nov 24 16:38:16 2015] WARNING: CPU: 1 PID: 22224 at /build/linux-CrH=
vZ_/linux-4.2.6/net/netlink/af_netlink.c:946 netlink_sock_destruct+0x103/0x=
140()
> [mar nov 24 16:38:16 2015] Modules linked in: nft_nat nft_chain_nat_ipv4 =
nf_nat_ipv4 nf_nat nft_log fuse uas usb_storage nft_counter nf_conntrack_ip=
v6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nft_ct nf_conntrack nft_=
meta nft_hash nft_rbtree nfnetlink_log nf_tables_inet nf_tables_ipv6 nf_tab=
les_ipv4 nf_tables nfnetlink nouveau snd_hda_codec_idt snd_hda_codec_generi=
c mxm_wmi wmi video ttm drm_kms_helper drm iTCO_wdt i2c_algo_bit iTCO_vendo=
r_support coretemp kvm_intel lpc_ich kvm snd_hda_intel mfd_core i2c_i801 sn=
d_hda_codec evdev snd_hda_core pcspkr psmouse serio_raw snd_hwdep snd_pcm s=
g rng_core tpm_tis tpm 8250_fintek shpchp button snd_timer snd soundcore ac=
pi_cpufreq processor thermal_sys parport_pc ppdev lp parport autofs4 ext4 c=
rc16 mbcache jbd2 dm_mod sr_mod cdrom sd_mod ata_generic floppy ata_piix e1=
00
> [mar nov 24 16:38:16 2015]=C2=A0=C2=A0mii libata scsi_mod ehci_pci uhci_h=
cd ehci_hcd usbcore usb_common
> [mar nov 24 16:38:16 2015] CPU: 1 PID: 22224 Comm: bash Tainted: G=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0W=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A04.2.0-1-amd64 #1 Debian 4.2.6-1
[...]
> I can reproduce the issue:
>=20
> =C2=A0% sudo ip netns add test
> =C2=A0% sudo ip netns exec test nft -f test.nft
> =C2=A0% sudo ip netns del test
>=20
> Find attached the test.nft file.

I can also reproduce this warning with Linux 4.3. =C2=A0I was also able to
simplify your sample quite a lot and still reproduce it:

--- BEGIN ---
flush ruleset
table ip nat {
	chain postrouting {
		ip saddr 192.168.5.0/24 snat 1.1.1.1
	}
}
table inet inet-filter {
	chain input {
		ct state new accept
	}

	chain forward {
		type filter hook forward priority 0; policy drop;
		ip saddr {1.1.1.1, 2.2.2.2} ip daddr {2.3.4.5, 2.3.4.6} tcp dport 22 coun=
ter accept
		ip saddr {1.1.1.1, 2.2.2.2} ip daddr {2.3.4.5, 2.3.4.6} tcp dport 22 coun=
ter accept
		ip saddr {1.1.1.1, 2.2.2.2} ip daddr {2.3.4.5, 2.3.4.6} tcp dport 22 coun=
ter accept
		counter accept
	}
}
--- END ---

I'm cc'ing this to the netfilter developers so they can investigate
this.

Ben.

--=20
Ben Hutchings
Unix is many things to many people,
but it's never been everything to anybody.
--=-Q+LUz1B/+5lMfLVbCy7R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVleEYue/yOyVhhEJAQpV+BAApXBwnsw+PbvYs2lJcg+hvBc+xHaB15eS
jv7Zx4npqX8oVS/RVOzA/Mcc9Y/ceOgNQQYEhsacBbIBOIJapYgIaXIQGhaj5IR+
g5fIOGHD+aUXwzOd7m8tey7zWDbCGH6Tad7hlrOh64Boax/4OK4O05E6ue3vetRM
MsnfcsxhPuWFCnjs9GMW6MyZX5XQgTHr5777wqsxI/TWRndfThHkf2K2IUfNw05e
kzRuuIxAqoHfv6Ynml9iJR1kmZYNknpbna2TmBiGhFbn1L0NbeZQaoGsMaPG2gpc
klC7tkXUVqHU1grmxiPzYEmHkfO5kCtj/5imsFlReJHOVWr66D0XKgC46h7Fh13R
e3UiLLwkwognK+CoKtBGW7ehJlFmuyFD6ZsIqcdWzDliAsu0seXzHMRSKszd2D5B
04xt7yit1MVkYJEezvvZqQHWHIY7pCNqmxK0m+/qVe/ryjg4Mu+nF1d5+XDaoEzP
ILR1gXhCw538piTmR72L8ONWSVYBwTjEfveDcj5JjVVt3wBmPH9nPE3P3oW43n1n
0ZXbESctFk10t6yNAhBx9z2Qi6GJs1g7Xx3iyeWtH+XRH0LS36UswghaXcUzGtNe
UTBKL8g5YqCPTmifH2KNKKgBbkgGZZs83wmI4ISD7GQQN2C+ro5WKaUbf4uGQ2jB
aPIZWi/bT0Q=
=T6qL
-----END PGP SIGNATURE-----

--=-Q+LUz1B/+5lMfLVbCy7R--
