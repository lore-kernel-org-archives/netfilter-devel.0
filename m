From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: TTL target working with 2.6 kernel??
Date: Sun, 1 Feb 2004 01:12:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040201001224.GA13953@zion.homelinux.com>
References: <20040113143806.GA25078@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040113143806.GA25078@zion.homelinux.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Replying to myself as I now have some more information on this
one:
Tonight (just a few minutes ago) I tried to use the TTL target
on a fresh compiled 2.6.2-rc3 kernel, and iptables again=20
segfaulted.
But this time I have a kernel backtrace (maybe I should have
looked in /var/log/messages last time too, the trace probably
has been there too):

Feb  1 00:54:09 zion kernel:  <1>Unable to handle kernel paging request at =
virtual address 676e6191
Feb  1 00:54:09 zion kernel:  printing eip:
Feb  1 00:54:09 zion kernel: f899f010
Feb  1 00:54:09 zion kernel: *pde =3D 00000000
Feb  1 00:54:09 zion kernel: Oops: 0000 [#2]
Feb  1 00:54:09 zion kernel: CPU:    0
Feb  1 00:54:09 zion kernel: EIP:    0060:[<f899f010>]    Not tainted
Feb  1 00:54:09 zion kernel: EFLAGS: 00010286
Feb  1 00:54:09 zion kernel: EIP is at ipt_ttl_target+0x10/0xf0 [ipt_TTL]
Feb  1 00:54:09 zion kernel: eax: 676e616d   ebx: f899f7e0   ecx: c0420e00 =
  edx: f899f7e0
Feb  1 00:54:09 zion kernel: esi: 00000008   edi: d5943c18   ebp: f89a71fc =
  esp: d5943b44
Feb  1 00:54:09 zion kernel: ds: 007b   es: 007b   ss: 0068
Feb  1 00:54:09 zion kernel: Process iptables (pid: 13714, threadinfo=3Dd59=
42000 task=3De48be080)
Feb  1 00:54:09 zion kernel: Stack: f89a7324 00000010 00000005 c0420e80 f89=
9f7e0 f89a726c f89a7000 c0358de4=20
Feb  1 00:54:09 zion kernel:        d5943c18 f89a71fc f89a728c 00000004 000=
00008 f89a7468 f89a7040 c0153770=20
Feb  1 00:54:09 zion kernel:        c0101f88 f89a9000 d5942000 00000001 d59=
43bbc 00000000 f7621ae0 f7621a60=20
Feb  1 00:54:09 zion kernel: Call Trace:
Feb  1 00:54:09 zion kernel:  [<c0358de4>] translate_table+0x5c4/0x7a0
Feb  1 00:54:09 zion kernel:  [<c0153770>] map_vm_area+0x60/0xb0
Feb  1 00:54:09 zion kernel:  [<c0359553>] do_replace+0x193/0x6d0
Feb  1 00:54:09 zion kernel:  [<c035918f>] copy_entries_to_user+0xdf/0x280
Feb  1 00:54:09 zion kernel:  [<c0359d13>] do_ipt_set_ctl+0x73/0x80
Feb  1 00:54:09 zion kernel:  [<c030a676>] nf_sockopt+0x136/0x140
Feb  1 00:54:09 zion kernel:  [<c030a6b7>] nf_setsockopt+0x37/0x40
Feb  1 00:54:09 zion kernel:  [<c03242c2>] ip_setsockopt+0x472/0xdb0
Feb  1 00:54:09 zion kernel:  [<c030a5f8>] nf_sockopt+0xb8/0x140
Feb  1 00:54:10 zion kernel:  [<c030a6f7>] nf_getsockopt+0x37/0x40
Feb  1 00:54:10 zion kernel:  [<c03252d1>] ip_getsockopt+0x6d1/0x7c0
Feb  1 00:54:10 zion kernel:  [<c01aa343>] journal_stop+0x1b3/0x290
Feb  1 00:54:10 zion kernel:  [<c019dba8>] ext3_mark_iloc_dirty+0x28/0x40
Feb  1 00:54:10 zion kernel:  [<c019dcef>] ext3_mark_inode_dirty+0x4f/0x60
Feb  1 00:54:10 zion kernel:  [<c01a2184>] __ext3_journal_stop+0x24/0x50
Feb  1 00:54:10 zion kernel:  [<c019dd69>] ext3_dirty_inode+0x69/0x90
Feb  1 00:54:10 zion kernel:  [<c01409de>] buffered_rmqueue+0xbe/0x160
Feb  1 00:54:10 zion kernel:  [<c0140b24>] __alloc_pages+0xa4/0x350
Feb  1 00:54:10 zion kernel:  [<c014abb8>] do_anonymous_page+0x128/0x210
Feb  1 00:54:10 zion kernel:  [<c014ad05>] do_no_page+0x65/0x360
Feb  1 00:54:10 zion kernel:  [<c0149047>] pte_alloc_map+0x97/0xc0
Feb  1 00:54:10 zion kernel:  [<c014b20e>] handle_mm_fault+0xde/0x180
Feb  1 00:54:10 zion kernel:  [<c011b9d2>] do_page_fault+0x312/0x512
Feb  1 00:54:10 zion kernel:  [<c0347da6>] inet_setsockopt+0x36/0x40
Feb  1 00:54:10 zion kernel:  [<c02f933c>] sys_setsockopt+0x6c/0xc0
Feb  1 00:54:10 zion kernel:  [<c02f9b8b>] sys_socketcall+0x23b/0x2c0
Feb  1 00:54:10 zion kernel:  [<c010b455>] sysenter_past_esp+0x52/0x71
Feb  1 00:54:10 zion kernel:=20
Feb  1 00:54:10 zion kernel: Code: 8b 58 24 0f b6 06 83 f8 01 0f 84 a7 00 0=
0 00 83 f8 01 0f 8e=20

Kernel is 2.6.2-rc3, with just the TTL patch applied from current
pom-ng.
Does anybody have an idea how to resolve this??

Thanks in advance!!!

Sven


On Tue, Jan 13, 2004 at 03:38:06PM +0100, Sven Schuster told us:
>=20
> Resending to netfilter-dev mailinglist as noone replied on the
> users mailing list.
>=20
>=20
> Hello list members,
>=20
> has anybody been using the TTL target from the new patch-o-matic-ng
> with kernel 2.6(.1) yet? I have patched my 2.6.1 kernel with this
> target, recompiled iptables (1.2.9) and wanted to insert a rule
> using the TTL target into mangle-table's FORWARD chain:
>=20
> iptables -t mangle -A FORWARD -j TTL --ttl-inc 1
>=20
> All I'm getting is a Segmentation fault. The ipt_TTL module can be
> loaded into kernel, and everytime I try to add this rule (or try
> to add this rule to the OUTPUT chain in mangle table) the used-
> count shown by lsmod increments by 1.
>=20
> But when I try
>=20
> iptables -t mangle -nL FORWARD
>=20
> I just get the following output:
>=20
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
>=20
> So, the rule doesn't seem to be taken...although the module use
> count increments.
>=20
> Any idea? Maybe the TTL target isn't yet really ready for 2.6?
> Maybe I should try at the developer's mailing list??=3D20
> Any tips welcome!!
>=20
> Sven
>=20

--=20
Linux zion 2.6.2-rc3 #1 Sat Jan 31 18:42:09 CET 2004 i686 athlon i386 GNU/L=
inux
 01:05:58  up 57 min,  1 user,  load average: 0.02, 0.05, 0.13

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAHERoo4FAdB2PneQRArTEAKCAZtCtdDXVcu+aDw22Vd2eeHd2ggCeK4TC
+DX1jm65kWp0dtHAtgz4aqE=
=C9p3
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
