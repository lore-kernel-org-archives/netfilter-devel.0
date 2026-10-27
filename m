Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793124581;
	b=o3uuM7uUtmHvjfD0lxCs2T5eR9UV9W2BmJFTMZhE46K2zOPvS/CVZRSSYuqNpOoJQCCb
	 1LKreA4ZQNgSkJe8nu+/iolYp7+Jnv1lnyv1v0i9VQrhqKNW+QF30MnAqVZM+cvcv2qze
	 nb0VpOIbhLSVXm1wdb5ifgeJdCHXjV6CcUnXXaMYEG3vUYZeiKF6xcullaLEhBwoZz42k
	 xfEwRFOAZjeR1UbRGE5bngKkglGGHNgL8Ke5ZO/9bjZn2cV1zQlK8Gt/0cQallsJTtMZB
	 Xx+BmAlyDcygytLqQ+hS9OeDs+DZK9yDbtrQEMhRAmYm75puK6yBCNf6knS3FFFve8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793124581;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=qMQ9ZdfUMCMdYGyBA3fjjloJNqgajHGaTShYy9SZdNY=;
	b=DpQ497RUHxlR4sNYAnvauHiWfBZzDdS9+rvkC53MmaCOHGnRgtbdvbeUYS6xJErFeuVw
	 2Uo1zef98guxHHprq3M7IlCLXGEOYTdqfcf0p2CqPW8cJqhGRxMfin+KlKkemTJg1kTS7
	 oImY0untCxfxABys4pUVM2iFgzHCZV2s4BqheNKshIC86rJrPIyoIToa96KlYFzmGydim
	 VOyWFITNnaaGRB+bHHrgTEkA/DqhPaVFGhWTYWarx5uwK5iwSIxX7BPHwgAi8PWmbtqWx
	 fbICc0En8UA0DY4oNTZ9+Iuvk4lUZIgSpi+xMV/ceQz9ndZczaQIkJDtF6rw7zvsaKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=none smtp.mailfrom=master.debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.master header.b=KPfNmUjb;
	arc=none smtp.remote-ip=82.195.75.110
Received: from master.debian.org (master.debian.org [82.195.75.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B09606A31A
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Oct 2026 18:09:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76B09606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=master.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.master header.b=KPfNmUjb
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.master; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description;
	bh=qMQ9ZdfUMCMdYGyBA3fjjloJNqgajHGaTShYy9SZdNY=; b=KPfNmUjbOBg1+u9h309TKiAODm
	yoTTiyHGoWsucfXDKInkqJaJEbTIvX+4tfM+nh/b/fUdbrxRcv6Sek4izgqbymRbqHUQnzVnFo0w+
	aD1wFWuFt+1WgbyyE3ziXr1sf+uogG9/tXRv4zC8EmOhtUQR4IO3b+abjwvN1vGwDbz1mTu3VeGBL
	TlVzjovOB3pzZeYoyEelwZzOziMqfcIaOMfLOU137l101FttoMFcrR0Ca0x238GwV1VoH3OZN5aXE
	VeyXcCDQ2MX+y6uOV2jdpnUQRwYpeL4EjjyQWzRIvSCseEnAvdPuI6Jj4XfwniC0KwgKeL0QFFsfK
	ROfo+kaw==;
Received: from ukleinek by master.debian.org with local (Exim 4.96)
	(envelope-from <ukleinek@master.debian.org>)
	id 1xLlc5-0032pq-0t;
	Tue, 27 Oct 2026 18:09:33 +0000
Date: Tue, 27 Oct 2026 19:09:32 +0100
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@debian.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>
Cc: Philip Dodd <orange.spyderman@gmail.com>, 1149525@bugs.debian.org, 
	netfilter-devel@vger.kernel.org
Subject: invalid pointer in nf_conntrack
Message-ID: <auDhy6OW5SrGg3jv@monoceros>
References: <179076304109.1376.1522422117778282591.reportbug@bellecote.private.montagnes.net>
 <59d64272-e162-486c-99c2-6f61feead01b@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hfdrksrpcv5wm3p4"
Content-Disposition: inline
In-Reply-To: <59d64272-e162-486c-99c2-6f61feead01b@gmail.com>


--hfdrksrpcv5wm3p4
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: invalid pointer in nf_conntrack
MIME-Version: 1.0

Control: forwarded 1149525 https://lore.kernel.org/netfilter-devel/auDhy6OW=
5SrGg3jv@monoceros

Hello,

this is about a bug report filed against the Debian 7.2.12 kernel. Further
context can be found at https://bugs.debian.org/1149525.

Note this is an arm64 machine, and the problem doesn't reproduce on 7.3.

On Mon, Oct 26, 2026 at 08:36:01AM +0100, Philip Dodd wrote:
> 7.2.12+deb14-arm64 is affected in the same way, reproduced by just loading
> the nf_conntrack module shortly after boot.
>=20
> After the failure:
> =A0 =A0 nf_conntrack module use count: 0
> =A0 =A0 net.netfilter.nf_conntrack_count: 0
> =A0 =A0 nf_conntrack hashsize: 65536
> =A0 =A0 /proc/sys/kernel/tainted: 128
>=20
> No nf_nat or xt_* modules were loaded.
>=20
> This time the fault occurred on CPU 1 rather than CPU 4. The faulting
> address is 0xfff8, with x24 again containing 0x10000.
>=20
> Trace :
>=20
> [=A0 234.152118] Unable to handle kernel paging request at virtual addres=
s 000000000000fff8
> [=A0 234.152884] Mem abort info:
> [=A0 234.153151]=A0 =A0ESR =3D 0x0000000096000007
> [=A0 234.153502]=A0 =A0EC =3D 0x25: DABT (current EL), IL =3D 32 bits
> [=A0 234.153993]=A0 =A0SET =3D 0, FnV =3D 0
> [=A0 234.154283]=A0 =A0EA =3D 0, S1PTW =3D 0
> [=A0 234.154580]=A0 =A0FSC =3D 0x07: level 3 translation fault
> [=A0 234.155031] Data abort info:
> [=A0 234.155302]=A0 =A0ISV =3D 0, ISS =3D 0x00000007, ISS2 =3D 0x00000000
> [=A0 234.155807]=A0 =A0CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
> [=A0 234.156343]=A0 =A0GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0
> [=A0 234.156774] user pgtable: 4k pages, 48-bit VAs, pgdp=3D000000000fdf4=
000
> [=A0 234.157367] [000000000000fff8] pgd=3D0800000010988403, p4d=3D0800000=
010988403, pud=3D0800000010987403, pmd=3D080000000d349403, pte=3D0000000000=
000000
> [=A0 234.158531] Internal error: Oops: 0000000096000007 [#1]=A0 SMP
> [=A0 234.159050] Modules linked in: nf_conntrack nf_defrag_ipv6 nf_defrag=
_ipv4 snd_soc_hdmi_codec snd_soc_core snd_compress snd_pcm_dmaengine snd_pc=
m snd_timer snd soundcore dw_hdmi_cec dw_hdmi_i2s_audio gpio_ir_recv hantro=
_vpu leds_gpio binfmt_misc rockchipdrm panfrost rockchip_vdec dw_hdmi_qp gp=
u_sched v4l2_jpeg dw_mipi_dsi rockchip_rga drm_shmem_helper dw_hdmi v4l2_vp=
9 v4l2_h264 videobuf2_dma_contig analogix_dp realtek v4l2_mem2mem videobuf2=
_dma_sg phy_package videobuf2_memops drm_dp_aux_bus ofpart videobuf2_v4l2 d=
rm_display_helper videodev dwmac_rk spi_nor stmmac_platform rockchip_saradc=
 cec rockchip_thermal stmmac mtd rc_core industrialio_triggered_buffer vide=
obuf2_common drm_client_lib kfifo_buf coresight_cpu_debug drm_dma_helper co=
resight_etm4x mc industrialio pcs_xpcs drm_kms_helper coresight phylink cpu=
freq_dt evdev cfg80211 rfkill nf_tables dm_mod efi_pstore configfs ext4 crc=
16 mbcache jbd2 xhci_plat_hcd xhci_hcd fusb302 tcpm aux_hpd_bridge drm dwc3=
 reset_gpio rk808_regulator udc_core typec ulpi fan53555 ghash_ce
> [=A0 234.159475]=A0 gpio_rockchip dwc3_of_simple gf128mul pwm_regulator p=
wm_fan fixed gpio_keys phy_rockchip_inno_usb2 ohci_platform sdhci_of_arasan=
 ehci_platform phy_rockchip_emmc phy_rockchip_pcie sdhci_pltfm io_domain eh=
ci_hcd ohci_hcd sdhci usbcore dw_mmc_rockchip rockchip_dfi pwm_rockchip dw_=
mmc_pltfm dw_wdt spi_rockchip pl330 phy_rockchip_typec cqhci nvmem_rockchip=
_efuse dw_mmc usb_common i2c_rk3x autofs4 aes_ce_blk aes_neon_bs
> [=A0 234.170887] CPU: 1 UID: 0 PID: 50 Comm: kworker/1:1 Not tainted 7.2.=
12+deb14-arm64 #1 PREEMPTLAZY=A0 Debian 7.2.12-1
> [=A0 234.171846] Hardware name: Pine64 RockPro64 v2.1 (DT)
> [=A0 234.172322] Workqueue: events_power_efficient gc_worker [nf_conntrac=
k]
> [=A0 234.173021] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> [=A0 234.173652] pc : gc_worker+0x13c/0x780 [nf_conntrack]
> [=A0 234.174191] lr : process_one_work+0x17c/0x4d8
> [=A0 234.174600] sp : ffff800080313d40
> [=A0 234.174905] x29: ffff800080313d40 x28: 0000000000003a98 x27: ffffcb2=
f7fce6a00
> [=A0 234.175568] x26: 0000000000000064 x25: 0000000000000000 x24: 0000000=
000010000
> [=A0 234.176238] x23: 000000000000fff0 x22: 00000000000124f7 x21: 0000000=
00000b770
> [=A0 234.176911] x20: ffffcb2f04df7968 x19: ffffcb2f04dfae08 x18: 0000000=
000000001
> [=A0 234.177587] x17: 000000040044ffff x16: ffffcb2f7d51d7d0 x15: ffffcb2=
f7fcf2218
> [=A0 234.178263] x14: 0000000000000000 x13: 0000000000000030 x12: 0101010=
101010101
> [=A0 234.178938] x11: 7f7f7f7f7f7f7f7f x10: feff736d64686268 x9 : 0000000=
000000038
> [=A0 234.179613] x8 : 8080000000000000 x7 : ffffcb2f7fce6000 x6 : fefefef=
efefefeff
> [=A0 234.180291] x5 : ffff000000e44388 x4 : ffffcb2f04df7970 x3 : 0000000=
000010000
> [=A0 234.180968] x2 : fffffffffffffff0 x1 : 0000000000000000 x0 : fffffff=
ffffffff0
> [=A0 234.181629] Call trace:
> [=A0 234.181862]=A0 gc_worker+0x13c/0x780 [nf_conntrack] (P)
> [=A0 234.182415]=A0 process_one_work+0x17c/0x4d8
> [=A0 234.182790]=A0 worker_thread+0x194/0x2f8
> [=A0 234.183139]=A0 kthread+0x134/0x150
> [=A0 234.183445]=A0 ret_from_fork+0x10/0x20
> [=A0 234.183787] Code: 37000a78 3940df00 9ba98800 8b000317 (b9400ae1)
> [=A0 234.184341] ---[ end trace 0000000000000000 ]---

The problematic code location is

	if (nf_ct_is_expired(tmp)) {

in net/netfilter/nf_conntrack_core.c with

	static inline bool nf_ct_is_expired(const struct nf_conn *ct)
	{
		return (__s32)(READ_ONCE(ct->timeout) - nfct_time_stamp) <=3D 0;
	}

=2E

In assembly that is:

    2f78:       9a812000        csel    x0, x0, x1, cs  // cs =3D hs, nlast
    2f7c:       cb1c0000        sub     x0, x0, x28
    2f80:       9ada0c00        sdiv    x0, x0, x26
    2f84:       8b00039c        add     x28, x28, x0
    2f88:       f94042e0        ldr     x0, [x23, #128]
    2f8c:       37180300        tbnz    w0, #3, 2fec <gc_worker+0x184>
    2f90:       f9400318        ldr     x24, [x24]
    2f94:       37000a78        tbnz    w24, #0, 30e0 <gc_worker+0x278>
    2f98:       3940df00        ldrb    w0, [x24, #55]
    2f9c:       9ba98800        umsubl  x0, w0, w9, x2
    2fa0:       8b000317        add     x23, x24, x0
*   2fa4:       b9400ae1        ldr     w1, [x23, #8]
    2fa8:       f940036b        ldr     x11, [x27]

I think the original issue was a few lines above (i.e.
ldrb w0, [x24, #55]), because the tripping address was 0000000000010037
(with 55 =3D 0x37). That is in nf_ct_tuplehash_to_ctrack(h).

All in all it looks like `h` is invalid.

Does that ring a bell? After starring at the code for a while I don't
spot the culprit. Also looking over the changes between 7.2.12 and 7.3
I don't spot a suspicious commit.

Best regards
Uwe

--hfdrksrpcv5wm3p4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmrg6NkACgkQj4D7WH0S
/k6WyAf7BNKRr2eFxlWCFzdgMdyo8r4kRT5LrfpD01f22gR/55f0tmReKbaiifKw
bqq3nQV5KYVYHAIe6stNSBI1uJpE2eB2HdEBnbid2gnrbTa8yO9cqC93m4VzpIck
KdtozhMRK7WAWwKXRtNPhBydeQV0OhJPvjDFGPZM2qAELFcj27GM6QmhORhRkK47
MK3IXYzJ6vLcYGEBKsWuMZ4kwEQ5L8xiGuI63f1UWklwnIMECpcwEjfxxEjMmUog
fwzXPCNs98F0lF9GR6LnILKSVAIQYQjKgjNBCzrwtiguYW+ulod8XCACBFntgcaD
PuE99cSQbo+xboYB5TjvQzNFVE/+Dw==
=DjP5
-----END PGP SIGNATURE-----

--hfdrksrpcv5wm3p4--
