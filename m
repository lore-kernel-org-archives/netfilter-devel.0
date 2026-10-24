Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792871993;
	b=oNMRM1/3/ISkPczQb3atJQtNL/92+Mcki+KHV4l4NC2zDCSXAqPeVoUiXlEoal4eDM6A
	 9ScFL37Mkzc2gfbe/sy7yVrXO6X7Z6lxruQ9iopwp1cmjD3D6b7ovACKc9OK5GloubxW4
	 rt3qHx1juQa/tfq1kM4tMpxmY85svW1JgcGGECURaY8mqCOVCHrWwRdlKpw5v26X8COop
	 zegGe+ve62S/X4gZn+47/Nqcac21vreUjP1PB7BQ9uA7xFcC8y16Rvye4jR5UeB2bakEd
	 E2vub4a5b7sMSYp/lcvE1cWc7CcfURY6R9bTp9dBuvmkLqdDXZR2AeRYZyeMhaIFsCg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792871993;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=Y1aeuq5wlLtNW10aX5s7oc69ZfKy5Qflu3xHauiEe9A=;
	b=uDvF4/BZghUrK69ikPo8NXZTk12VqfVyQp7lGudfxpwtegLz0Bc7cYbbW/ZM+I4QThDA
	 Nr8FXPvVbQdT8+LdYMFRcDA985NV/XydyHNfz4J1rStJVuWQarkNig8qVDXX/TG+qmij/
	 nD1/ZA5o9+hRGHXL5hSNTN+z5qNGXnYhzfilpZ+5nPU2msQUpKiHE2zxw8QNXRLgVmlVJ
	 e24vw+abm52I+eN9/j4nEoYI7981rp6tv5PA9+KrevAnjnFaM/1fmiL1EuRIYkKlx7wNb
	 IPGltIyezY8OqFYkO3hkD3KEXOybfi4hWDWDVFwD0MW2rXlFiQ318ihPYW1N1+FInFQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oeGZHUqt;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CA0606A31A
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 19:59:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10CA0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oeGZHUqt
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c450ab1483cso255600966b.3
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 12:59:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792871991; cv=none;
        d=google.com; s=arc-20260327;
        b=hpE7ZBGY7BUrFTHRXvGdRrqMtKjZCqXLOp7Tgp9J0PITH2iNkfh2MXSBDm+WTgj7fV
         yCPEkYrL8biJiXy+qr603mVlhGfkf7M3FoVh72svrGY7wxAQvdF1USiTbdZCu3vYsncV
         i6SGZFWqKpYfpX76O7KkaxF47JPZxFjPy4VKJouYoGZPoW+iSVp05mOAjKZWw3X1PntH
         RNR9wO3F2xfj1ulzhr6YZDjDMAr3bT2OFDuRNzVM481RnaQVPulOSdwaSyE5KGBM8+F2
         yJ+cjpPjLSsMQadAcgo1nyDXwOSUuMHp9/8X0alW3VOpD2li1hDRzrGCJbEnjIugaTbY
         6e3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Y1aeuq5wlLtNW10aX5s7oc69ZfKy5Qflu3xHauiEe9A=;
        fh=k3fAqSwxy2PStUpKDEWXqbPYl0kz+2snMRWcyogk38Q=;
        b=HAiKUQhKgsHgXwqLDnmECY8oxteNxtol7IkrGgVQE7WxJaUO7C9Ipz8LM1a5C+nvFO
         NzM6Nc/4Rjhzzb+8oserbidW1fW99a0hEbVlECNk3HReLO0/pOmo9chEme1KvnjQt5aC
         Yk2HUes0i8ih3HXNqN2fWWWGtceVV0Z1E19Nsi953PYwC+ZttSl+0CTfRp/O2PoBjNiN
         BmGyMRRceeiALbqy0j4ssli07gt2mv3iIUQyVWZMFd7gKcNCC081xsAXNmJpVJfr6qEZ
         OAWah4ReBRBlrlGQpjgTQM3g8WITCK/Ft9bo39iquAYxqdyGsyQ5gCBhmF75VYut9Whm
         IeHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792871991; x=1793476791; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y1aeuq5wlLtNW10aX5s7oc69ZfKy5Qflu3xHauiEe9A=;
        b=oeGZHUqtNRxLiXBkTBCO2H3SZjbsAOzlkT0/FutVM4CrafajSE7+0NsLHmW560LJIY
         U73RqnfpeHeMO/8B0NOk+A0uj+XdJRpuKu26BRvTEgURR7JQOUaJPtZA1BWdfut77q9a
         QM3cQ6o5XbzTwC6vk+O13gqUBO97j9Gd7+rlp4uU3MncJl8PY4MITIRR/YdR454dPkHm
         BqMdFn2YpluWrB6/3ZB0VyKrwQBaBj/fJeCerGqhqYZnQGbMAXOfJ+9pvMO4pN/DoSPe
         irqjjJw9yeaZmcyjl/YEzr1uFKYXIPP73AuKGTyiVIAFjg2l5+6MX6dUrEQbLpUITVcI
         vPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792871991; x=1793476791;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Y1aeuq5wlLtNW10aX5s7oc69ZfKy5Qflu3xHauiEe9A=;
        b=V6pWP2fI1gw7fFt0zqwzGuWirudOY3EhxNKkLXzseGSdiQXmmoK3dhKFzaUGatruJE
         NRfTmsdwkAYFlNsclP7v9/JN3hiFBo5em+SwSv5zytIW1e6uyuLB8Hn/PUER3xit7KKP
         IstsxZDE0dRsNnkRPgTl9MLkL2fTeHTuAEqGm/f1PDfykmW44dB1WpYbPeo9LqETLiru
         gBcMS+o3tQ8rR8o3aV8r6Y33HB8uWasVvxi759UopoEcxlm3nCvgVK6Yy/6vqCnd/eU5
         otMpeMfT2yfhm7o7Z60/009YjPj26INaKFp/vXzcuNQxCz59S1ewy2zEUcPridUuQCgk
         Stwg==
X-Forwarded-Encrypted: i=1; AKwUvBybcBzGxHnxL/SQ/IENKzu+fInX7Pd7+6xkVJX7clRMwtmHrQc75Ry23Iqr4G71c1aLcpEjhux2MH1vZgky0rQ=@vger.kernel.org
X-Gm-Message-State: AFq9FYIj+H60hOsJdWOxzreGCkDpDwgXPk6qjoPkR1tQE3D+NCsu6Wzf
	s/GR2GqaVAtOMlQUldeWJBTJkWqfLp4PG8MDxBajRGB/bppotbBS2bmvXuLmH5gNFt6Pa2k65Kd
	/lHp/gMN2deS9uumEmqmE4n9ioi49mF0=
X-Gm-Gg: AYBFou3uE5ACM2dX+yRXTEpcFVvHnV+Yt3InMnhk7SNiTFO9nfzWoNGn64PGWXU3IUK
	8p/d/ULgcQ3kDJomlhmXZHqeAK/J1oPMJ8ue425z8zIFW1AelYQRujJchVsRUyea+VSR1y0ivMC
	pQlmvGQeSdha9RgqTiOiJ87C8ARsoFsssdgzxL8lHwq86HzQEPR7EA7Ay6teJB7L/AKWpZyduky
	zNwsYDM5bM3StcSIaM4rQ0CR97l3z2U/RcZuBwEFDsEAyZlZgiTJi24xlANuVFb4mTrbcOxEbZq
	3fi/3JZzHLod4nr1T6hXW6gwkssnLfkotcfxiERAIS6YEaPfBwU17sZl1GSk5ixdHmZuqxv6+iz
	QMWZCkoyg6Kk5BVq3IuH8otXZDTnYEYPq1i+1ZEvXF5Kcuot1XV37HV94UMeW8g1ATb5K
X-Received: by 2002:a17:907:7fa2:b0:c34:e9fe:82ed with SMTP id
 a640c23a62f3a-c46bde53641mr320816366b.28.1792871991404; Sat, 24 Oct 2026
 12:59:51 -0700 (PDT)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Jalen <jalen.lin@gmail.com>
Date: Sun, 25 Oct 2026 03:59:38 +0800
X-Gm-Features: AclHuK9KkBjBGWoRa_ld4FWISRsVfgthwdP-vuacjeJMzEpkEd5BKVmYyQ84xBs
Message-ID: <CAHqkChbVoGHrWtaFyGFaLQDiAunWw1qOpW-vKSgkKxWEfQ_tCg@mail.gmail.com>
Subject: [REGRESSION] netfilter: flowtable: HW offloaded flows are not removed
 from hardware on flowtable deletion since 13210fc63f35
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
	=?UTF-8?Q?Paul=2DLouis_Charri=C3=A8re?= <plcharriere@gmail.com>, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

Since 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable
binding"), deleting a flowtable with "flags offload" leaves its flows
in hardware. FLOW_BLOCK_UNBIND now runs at commit time, before
nf_flow_table_free(), so the FLOW_CLS_DESTROY calls made by the free
find no driver callback. The hardware keeps forwarding (and NATing)
those flows with no flowtable or ruleset left. Current master is
affected. Seen on mtk_eth_soc and mlx5.

This is the ordering that 5acab91458ce ("netfilter: nf_tables: unbind
callbacks from flowtable destroy path") fixed in 2020:

  Callback unbinding needs to be done after nf_flow_table_free(),
  otherwise entries are not removed from the hardware.

In current master the UNBIND is in nft_unregister_flowtable_ops(),
still called from the commit path. Stable trees with 13210fc63f35
(from the source, not runtime tested): v5.15.180, v6.1.125+,
v6.6.72+, v6.12.10+.

Results
-------

BPI-R3 (MT7986A, mtk_eth_soc PPE), vanilla kernels, each run from a
fresh boot. BND = grep -c BND /sys/kernel/debug/ppe*/entries

  A  4f619d518db9  parent of 13210fc63f35
  B  13210fc63f35
  C  5b0764a53235  master, 2026-10-23
  D  C + the patch mentioned below

  step                                  A     B     C     D
  1. no table                           0     0     0     0
  2. load the table below            1000  1000  1000  1000
  3. nft delete table inet t,
     40 s idle                          0     0     0     0
  4. same 1000 5-tuples again           0  1000  1000     0
  5. 1000 new 5-tuples                  0     0     0     0

A/B differ only in nf_tables_api.c and C/D only in
nf_flow_table_offload.c; each pair uses the same .config. In step 2
all four show 1000 [HW_OFFLOAD] conntrack entries. In step 4 B and C
have no flowtable and no [HW_OFFLOAD] entry, yet the PPE forwards the
old flows in hardware.

On-board ConnectX-7 of an NVIDIA DGX Spark (GB10, arm64; PSID
NVD0000000087, fw 28.45.4028; Ubuntu 6.17.0-1022-nvidia), not a
standalone card. mlx5 in switchdev, flowtable on two VF
representors, traffic VF to VF, 1000 UDP flows,
mlx5e_delete_flower() calls counted with kprobes:

                                   stock   patched
  deletes on "nft delete table"        0      4000
  old flows still forwarded          yes        no
  next 1000 flows offloaded          864      1000
  eswitch mode change to legacy     busy        ok

4000 = 1000 flows x 2 directions x 2 representors. With the flowtable
gone and ip_forward=0, the old 5-tuples still reach the other VF with
the masquerade source address. The 136 missing flows get -EEXIST from
leftover driver entries. "patched" is an out-of-tree nf_flow_table.ko
built from the same distro source; an unmodified rebuild gives the
same numbers as stock.

(On this setup mlx5 only hits FT rules once some tc rule exists on
chain 0, so the forwarding check used a dummy flower rule there. It
looks like esw_chains_create() creates the chain 0 root table, and
its miss rule, before mlx5_chains_set_end_ft() sets the FT chain. I
have not looked into it further.)

Reproduction
------------

  table inet t {
    flowtable ft {
      hook ingress priority filter
      devices = { lan0, lan1 }
      flags offload
    }
    chain ft_forward {
      type filter hook forward priority filter; policy accept;
      ip protocol { tcp, udp } flow add @ft
    }
    chain post {
      type nat hook postrouting priority srcnat; policy accept;
      oifname "lan1" masquerade
    }
  }

1000 UDP flows, 10.0.0.100+i:1024 -> 192.168.200.2:7, 64B, 200 kpps,
lan0 -> lan1 (MT7531 DSA ports). Scripts and raw logs on request.

Fix
---

The tested patch is from an OpenWrt fork, carried there as a MediaTek
target patch although the change is generic. It deletes the device's
hardware flows in nf_flow_table_offload_setup() before
FLOW_BLOCK_UNBIND, as nf_flow_table_indr_cleanup() does, and runs the
GC once more for flows whose offload work was still pending:

  https://github.com/plcharriere/openwrt/pull/1 (commit f36e21492a)

It applies to current master. I have not checked that it keeps the
BIND/UNBIND balance for all the cases 13210fc63f35 fixed.

Paul-Louis (Cc'd), would you be willing to send it to netfilter-devel
on its own? If the maintainers prefer a different fix, I can test it
on both setups.

The same symptom on Qualcomm PPE (IPQ9570, hardware table full after
about 10 firewall reloads):
https://github.com/perceival/openwrt-flint3/issues/115

This was investigated with help from an AI coding assistant (Claude
Opus 5.5 in Claude Code). It read the kernel and driver code, ran the
reproducers and kprobe counts on my hardware, and drafted this
report. I reviewed the analysis and the results and can answer
questions about them.

#regzbot introduced: 13210fc63f35

Thanks,
Jalen
