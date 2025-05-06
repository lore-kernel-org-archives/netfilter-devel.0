Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A661A24E014
	for <netfilter-devel@vger.kernel.org>; Tue,  6 May 2025 10:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746529059; cv=none; b=JWpCDi8neuJ+kjhf2K+FbBkLTjfnvADkoGK30GS+jRSynCTmrwqEVcz5mSB0QZD6CV7CPOD63WT79swG2wtILPB7+gmKnl+fXIHPkmcVxiU8nbnTJMSnTcR3FDYrnLF8jaeNLrjViq4/uNQh6KnXMFcdlyuTzHplJW1UvBLtJis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746529059; c=relaxed/simple;
	bh=2GYxXu59M+SEH8c+ffJ03wJ1z/QjSwlMO07vIr1GbBA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=eLWsI3LLQz5WYmUQVuvOJUYi4JizR9iFN9gTtZaOtPsbOnqSZ0cP4EsIYVbx9cLQJr8wg7BlKVbGUn7FpnQDGnNRMkbzhOJSwhLT6FkpNbxzkCezywP9eG8DwqWRRoD4dJ9uPHQw9jEJKwudtjOlfHDyAIJVSsyn/gzBulkM/fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jMs08Y//; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jMs08Y//"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-30bee278c2aso70615071fa.0
        for <netfilter-devel@vger.kernel.org>; Tue, 06 May 2025 03:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746529055; x=1747133855; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2GYxXu59M+SEH8c+ffJ03wJ1z/QjSwlMO07vIr1GbBA=;
        b=jMs08Y//oIWNF1isxGdXahFrYLIwTX803nMbT+nhUUsXGqaveDxF5FcM2w0AdG8bmV
         Sjz8R76PTXt9dj1PGJlnxbdKVDknAV0sYCEhnbus/u6WDRjesTJ3qXzwa1NqQ3g+q3Vk
         5ssfiZZiOH0ql6+0a8vBeEqfejv0jWhIs6eIoRnBid5ILfGouiBzYN/yVVgXEqklNKPc
         s8faC6O1PQlqkop2Q0cN2rFjax8S74WixrNuOTbhxISE/UVTz2cejpMmYqdku6Poscz3
         s3P4+EPSZ4KayBbbtYbK5141bwesVM4FFdNDtN+29FPr2J2L82YpPg6w5QtS91TZslqr
         bQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746529055; x=1747133855;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2GYxXu59M+SEH8c+ffJ03wJ1z/QjSwlMO07vIr1GbBA=;
        b=EKeM+8BdJtjXW2rMuUmP7xE95rVSugxp4gHVMdKYM2icIJfFxKvLZ1PD7GZ4xlfp3m
         yvKFOhW7gHeNxbomJ2vfDj/gna4drSDQcZhpPD7HIbkWHs0XedV2INar6frI7lr7+lCA
         9BFrCH78qPdWF0kv/9OXf/4MMM/SYFQhDex0NhCMhuR+SjC6Yss5cEcpIBbGRTUN7SuR
         CKs7e3lmZhbAk2JC9JHkyfWDmVY6o0VrrAeSatqLrcgBsxgRveeILWnt7UF66RdH2oxh
         ZPvxAIsngWfaPEElxPk2m+bSr2o2uuqekPTvrp0FpEUiR2Q0F/BULaZoQilebfn5R3PS
         YXog==
X-Gm-Message-State: AOJu0YxU3OO3fl7O7/esQbnmHVpEgfAfHGikzzYxQfGKa8tYslF8HkaM
	ZFb8LqNZel2STX8AN/+GJMZLFoq5tgOVEg+1kSa4+HIhEoba5ruL6tbdUkSFyn7X7z0FlOcY5Xd
	X/7L/Rg2cY5uAloCswxQghI1wDmM80bNYi/ZU4w==
X-Gm-Gg: ASbGnctpmjLlXsA+vwxFIwZkPGUxVRFRQ/4sQSW+ZxN2gQ4GCzjn88MlORzHUyQ2bw7
	JLuQlImHdJKyIVmTuXWKS7SXyVLdK2thrIX6AVYGtILx316bS/ab3RCTXZxvFcnbIMuAv3z9++t
	2Xz6AhEHRophx+X5KVGk6IwNTj
X-Google-Smtp-Source: AGHT+IFHnX3ZHUbsivFMPjhprGQ35rwsHx2wvTF1oNq+oW+Qb8QPv74wAA8U6ldALl1S9moEmiOjOBFl0CRTTrqsd0c=
X-Received: by 2002:a05:651c:554:b0:30b:9f7b:c186 with SMTP id
 38308e7fff4ca-326451f2355mr12415451fa.1.1746529055266; Tue, 06 May 2025
 03:57:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Monib <monib619@gmail.com>
Date: Tue, 6 May 2025 15:57:23 +0500
X-Gm-Features: ATxdqUFfzRlN5R5gdOiZLUcxV7BjRX5q-rRgBsJFcUVSv4RumZE7F8aB0LNPUcc
Message-ID: <CAJV_tgbKEHTn9T+AZSduNe4YdxQxe8aeriteuYzBmjUm9vNnyg@mail.gmail.com>
Subject: nftables netlink cache initialization failure with dnsmasq
To: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

An OpenWRT user here who has been trying to set up split tunneling
using https://docs.openwrt.melmac.net/pbr/, which uses dnsmasq and
nftables, but I am having some issues.

I am encountering an error =E2=80=94 "netlink: Error: cache initialization
failed: Protocol error" =E2=80=94 which seems to be produced by nftables. T=
his
error message was introduced in the following commit:
https://git.netfilter.org/nftables/commit/?id=3Da2ddb38f7eb818312c50be78028=
bc35145c039ae.
The commit message says: "cache initialization failure (which should
not ever happen) is not reported to the user."

The issue starts happening semi-randomly but seems to occur when too
many DNS requests are made in a short period. Once it appears, the
relevant nftables sets stop being populated by dnsmasq.

Here is what I see in the logs:

Sun Mar 23 17:52:24 2025 daemon.err dnsmasq[4]: nftset inet fw4
pbr_wg_xray_4_dst_ip_cfg066ff5 netlink: Error: cache initialization
failed: Protocol error
Sun Mar 23 17:52:33 2025 daemon.err dnsmasq[4]: nftset inet fw4
pbr_wg_xray_4_dst_ip_cfg046ff5 netlink: Error: cache initialization
failed: Protocol error
Sun Mar 23 17:52:58 2025 daemon.err dnsmasq[4]: nftset inet fw4
pbr_wg_xray_4_dst_ip_cfg066ff5 netlink: Error: cache initialization
failed: Protocol error
Sun Mar 23 17:54:08 2025 daemon.err dnsmasq[4]: nftset inet fw4
pbr_wg_xray_4_dst_ip_cfg066ff5 netlink: Error: cache initialization
failed: Protocol error
Sun Mar 23 17:54:22 2025 daemon.err dnsmasq[4]: nftset inet fw4
pbr_wg_xray_4_dst_ip_cfg076ff5 netlink: Error: cache initialization
failed: Protocol error
Sun Mar 23 17:54:22 2025 daemon.err dnsmasq[4877]: nftset inet fw4
pbr_wg_xray_4_dst_ip_cfg076ff5 netlink: Error: cache initialization
failed: Protocol error
Sun Mar 23 17:54:53 2025 daemon.err dnsmasq[4]: nftset inet fw4
pbr_wg_xray_4_dst_ip_cfg066ff5 netlink: Error: cache initialization
failed: Protocol error
Sun Mar 23 17:54:53 2025 daemon.err dnsmasq[4]: nftset inet fw4
pbr_wg_xray_4_dst_ip_cfg066ff5 netlink: Error: cache initialization
failed: Protocol error
... (many similar entries)

I ran dnsmasq under strace, hoping to gather more insight:
https://github.com/user-attachments/files/19410818/strace.log.tar.gz

I am still unsure where the actual problem is between dnsmasq and
nftables, but since the error message seems to be coming from
nftables, I am hoping someone here can help me figure out what is
going on or point me in the right direction.

Hardware:
- Router: Linksys EA8100
- SoC: MediaTek MT7621 ver:1 eco:3

Software:
- OpenWRT Version: 24.10.0 (r28427-6df0e3d02a)
- Kernel: 6.6.73
- Dnsmasq: 2.90 (Compile options: IPv6 GNU-getopt no-DBus UBus no-i18n
no-IDN DHCP DHCPv6 no-Lua TFTP conntrack no-ipset nftset auth
cryptohash DNSSEC no-ID loop-detect inotify dumpfile)
- Nftables: v1.1.1 (Commodore Bullmoose #2)

For additional context:
Originally, I thought this was an issue with the PBR packages, so I
posted this on the OpenWRT forum:
https://forum.openwrt.org/t/policy-based-routing-pbr-package-discussion/140=
639/1961?u=3Dlov432
https://forum.openwrt.org/t/policy-based-routing-pbr-package-discussion/140=
639/1987?u=3Dlov432

However, they seemed to think it might be related to dnsmasq, then I
created an issue on the OpenWRT GitHub:
https://github.com/openwrt/openwrt/issues/18333

And then finally this post here.

I am sorry for such a scattered post, but I wanted to provide as much
information as possible. Please let me know if you have any questions
or if there is anything else I can do to help make this more clear.

Thanks,
LoV432
