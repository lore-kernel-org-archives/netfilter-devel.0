From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Bug#806130: linux: netlink_sock_destruct() crash in netns
Date: Sat, 28 Nov 2015 23:47:20 +0100
Message-ID: <20151128224720.GA2296@salvia>
References: <144838019931.22302.9425487048881510008.reportbug@deathstar.cica.es>
 <1448576098.27159.62.camel@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	806130@bugs.debian.org, netfilter-devel@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39314 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbbK1Wra convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Nov 2015 17:47:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D87F5B6B9E
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2015 23:47:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CC288DA809
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2015 23:47:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 70105DA801
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Nov 2015 23:47:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1448576098.27159.62.camel@decadent.org.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 26, 2015 at 10:14:58PM +0000, Ben Hutchings wrote:
> On Tue, 2015-11-24 at 16:49 +0100, Arturo Borrero Gonzalez wrote:
> > Source: linux
> > Version: 4.2.6-1
> > Severity: normal
> >=20
> > Dear Maintainer,
> >=20
> > thanks for your work in the linux kernel.
> >=20
> > I'm experimenting reports like this:
> >=20
> > [mar nov 24 16:38:16 2015] ------------[ cut here ]------------
> > [mar nov 24 16:38:16 2015] WARNING: CPU: 1 PID: 22224 at /build/lin=
ux-CrHvZ_/linux-4.2.6/net/netlink/af_netlink.c:946 netlink_sock_destruc=
t+0x103/0x140()
> > [mar nov 24 16:38:16 2015] Modules linked in: nft_nat nft_chain_nat=
_ipv4 nf_nat_ipv4 nf_nat nft_log fuse uas usb_storage nft_counter nf_co=
nntrack_ipv6 nf_defrag_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 nft_ct nf_=
conntrack nft_meta nft_hash nft_rbtree nfnetlink_log nf_tables_inet nf_=
tables_ipv6 nf_tables_ipv4 nf_tables nfnetlink nouveau snd_hda_codec_id=
t snd_hda_codec_generic mxm_wmi wmi video ttm drm_kms_helper drm iTCO_w=
dt i2c_algo_bit iTCO_vendor_support coretemp kvm_intel lpc_ich kvm snd_=
hda_intel mfd_core i2c_i801 snd_hda_codec evdev snd_hda_core pcspkr psm=
ouse serio_raw snd_hwdep snd_pcm sg rng_core tpm_tis tpm 8250_fintek sh=
pchp button snd_timer snd soundcore acpi_cpufreq processor thermal_sys =
parport_pc ppdev lp parport autofs4 ext4 crc16 mbcache jbd2 dm_mod sr_m=
od cdrom sd_mod ata_generic floppy ata_piix e100
> > [mar nov 24 16:38:16 2015]=A0=A0mii libata scsi_mod ehci_pci uhci_h=
cd ehci_hcd usbcore usb_common
> > [mar nov 24 16:38:16 2015] CPU: 1 PID: 22224 Comm: bash Tainted: G=A0=
=A0=A0=A0=A0=A0=A0=A0W=A0=A0=A0=A0=A0=A0=A04.2.0-1-amd64 #1 Debian 4.2.=
6-1
> [...]
> > I can reproduce the issue:
> >=20
> > =A0% sudo ip netns add test
> > =A0% sudo ip netns exec test nft -f test.nft
> > =A0% sudo ip netns del test
> >=20
> > Find attached the test.nft file.

sk       Eth Pid    Groups   Rmem     Wmem     Dump     Locks
Drops     Inode
ffff8800cbb11000 0   0      00000000 0        0        0 2        0 198=
55  =20
ffff88011504f800 4   0      00000000 0        0        0 2        0 198=
77  =20
ffff8801153f7000 9   0      00000000 0        0        0 2        0 198=
76  =20
ffff880030c23000 10  0      00000000 0        0        0 2        0 198=
58  =20
ffff8800cbabb800 12  0      00000000 -4544    0        0 2        0 198=
90  =20

wmem is underflowing.

Could you check if this also happening in older kernel versions?

No need to test under netns, you can just run nft -f and check
/proc/net/netlink.

Let me know, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
