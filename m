From: "Nishit Shah" <nishit@elitecore.com>
Subject: kernel panic with ip_conntrack with kernel 2.6.16.13
Date: Fri, 5 Feb 2010 00:15:04 +0530
Message-ID: <001301caa5ca$2b50e8a0$81f2b9e0$@com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:60537 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757629Ab0BDSka convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:40:30 -0500
Received: from unknown (HELO elitecore3) (nishit.shah@[10.12.13.3])
          (envelope-sender <nishit@elitecore.com>)
          by elitecore.com (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 4 Feb 2010 18:40:25 -0000
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

	Please find the panic below. I am not able to reproduce it but I am
getting it very frequently.
	Kernel version is =96 2.6.16.13
	Any suggestions/directions ??


Unable to handle kernel NULL pointer dereference at virtual address 000=
00079

=A0printing eip:

*pde =3D 00000000

Oops: 0000 [#1]

Modules linked in: tun md5 sha512 sha256 sha1 crypto_null ip_nat_ftp
ip_conntrack_ftp ip_nat_h323 ip_conntrack_h323 ip_nat_irc ip_conntrack_=
irc
ip_nat_pptp ip_conntrack_pptp ip_nat_tftp ip_conntrack_tftp ipt_REJECT
ipt_iprange ip_NFQUEUE nfnetlink_queue ipt_mport ipt_IMQ ipt_TCPMSS
ipt_l4proto xt_pkttype des blowfish cast5 serpent twofish aes ipsec ipt=
_set
sch_sfq sch_hfsc imq ipt_ipp2p ipt_REDIRECT ipt_MASQUERADE xt_state
ip_set_iphash ipt_hashlimit ipt_unclean ipt_recent ipt_NOTRACK xt_tcpud=
p
af_packet iptable_nat ip_conntrack_netlink ip_nat iptable_mangle fuse
iptable_filter iptable_raw ip_tables ip_set ipt_ULOG ip_conntrack nfnet=
link
e1000 arptable_filter arp_tables x_tables 8021q ata_piix libata

CPU:=A0=A0=A0 0

EIP:=A0=A0=A0 0060:[<c010fef7>]=A0=A0=A0 Not tainted VLI

EFLAGS: 00010002=A0=A0 (2.6.16.13-1 #92)=20

EIP is at do_page_fault+0x97/0x5a7

eax: c0356000=A0=A0 ebx: 00000001=A0=A0 ecx: 0000007b=A0=A0 edx: 000000=
01

esi: f7c09740=A0=A0 edi: c010fe60=A0=A0 ebp: 000000e4=A0=A0 esp: c03560=
10

ds: 007b=A0=A0 es: 007b=A0=A0 ss: 0068

Process =DC=F10=C0=DC=F10=C0=E4=F10=C0=D4=F10=C0=C8 (pid: 0, threadinfo=
=3Dc0354000 task=3Dc030f0a0)

Stack: <0>c037fad0 0000000d c0356038 c014e36b 00030001 f62e2680 000000e=
4
00000001=20

=A0=A0=A0=A0=A0=A0 00000000 c035606c c035606c c02d035e 00000000 0000000=
e 0000000b
e0acf424=20

=A0=A0=A0=A0=A0=A0 00000296 f8972570 00000001 f7c09740 c010fe60 000000e=
4 c0102e73
00000001=20

Call Trace:

=A0[<c014e36b>] __cache_free+0x3b/0x40

=A0[<f8972570>] death_by_timeout+0x0/0x50 [ip_conntrack]

=A0[<c010fe60>] do_page_fault+0x0/0x5a7

=A0[<c0102e73>] error_code+0x4f/0x54

=A0[<c010fe60>] do_page_fault+0x0/0x5a7

=A0[<c010fef7>] do_page_fault+0x97/0x5a7

=A0[<f8972570>] death_by_timeout+0x0/0x50 [ip_conntrack]

=A0[<c010fe60>] do_page_fault+0x0/0x5a7

=A0[<c0102e73>] error_code+0x4f/0x54

=A0[<c010fe60>] do_page_fault+0x0/0x5a7

=A0[<c010fef7>] do_page_fault+0x97/0x5a7

=A0[<f8972570>] death_by_timeout+0x0/0x50 [ip_conntrack]

=A0[<f8972570>] death_by_timeout+0x0/0x50 [ip_conntrack]

=A0[<c010fe60>] do_page_fault+0x0/0x5a7

=A0[<c0102e73>] error_code+0x4f/0x54

=A0[<c014c5d8>] kmem_freepages+0x78/0xb0

=A0[<c014c6ed>] slab_destroy+0x3d/0xa0

=A0[<c014d5c9>] free_block+0xb9/0xd0

=A0[<c014d634>] cache_flusharray+0x54/0xd0

=A0[<c014e36b>] __cache_free+0x3b/0x40

=A0[<f8972570>] death_by_timeout+0x0/0x50 [ip_conntrack]

=A0[<c014d7ee>] kmem_cache_free+0x1e/0x30

=A0[<f8972f2e>] ip_conntrack_free+0x1e/0x30 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f8972526>] destroy_conntrack+0xc6/0x110 [ip_conntrack]

=A0[<f89725b7>] death_by_timeout+0x47/0x50 [ip_conntrack]

=A0[<c011dd26>] run_timer_softirq+0xc6/0x1b0

=A0[<c0119dab>] __do_softirq+0x7b/0x90

=A0[<c0119de6>] do_softirq+0x26/0x30

=A0[<c0104a3e>] do_IRQ+0x1e/0x30

=A0[<c0102e16>] common_interrupt+0x1a/0x20

=A0[<c0100e4c>] mwait_idle+0x2c/0x40

=A0[<c0100d90>] cpu_idle+0x50/0x60

=A0[<c0358778>] start_kernel+0x178/0x1c0

=A0[<c03582d0>] unknown_bootoption+0x0/0x1e0

Code: 00 e0 ff ff 21 e0 8b 10 81 fd ff ff ff bf c7 44 24 10 01 00 03 00=
 89
54 24 1c 0f 87 c5 04 00 00 f7 40 14 ff ff ff ef 8b 54 24 1c <8b> 5a 78 =
0f 85
f0 03 00 00 85 db 0f 84 e8 03 00 00 8d 73 34 8b=20

=A0<0>Kernel panic - not syncing: Fatal exception in interrupt

Rgds,
Nishit Shah.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
