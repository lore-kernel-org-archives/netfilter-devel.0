Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1BD27815B;
	Tue, 22 Apr 2025 11:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745322251; cv=none; b=lRJmLab1oDPSgVPksV56ZTRzKx91WIjex5QUI9NSk2Rv7R2m1BI7FAkGqy8YOcF5auB+Lpu/sxkxlLClrp6bJJgh7mpeqCUJlAlRk+fzUw17KX+Q3VY44vrJ6yxWwt2jE2whkB8Qq/rWrMpko4A/vsDsEPxVg0XeTNm1ULQKXys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745322251; c=relaxed/simple;
	bh=0SJZ4NFhZXBaM3WznzcAPczPKN69J8Kh0Zkk5FzAszw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=l5j5irONek+t6miSQmDzsWr3rxm4zeBg9l/sTATxtMpCYgRLKONBtyYYEoVx2tuVdhyYAbgrR/9GOvnT2xMs2x5DkeMvI4SShQqCx54TxPsVEtF76DEPvpcU67TpetACz4RrDiArlSVsIR4WB+MZEHDYuUfBSyQOf8xudeLmq2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=t9CwRx3h; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=X5uTpcw5; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="t9CwRx3h";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="X5uTpcw5"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8BC646062F; Tue, 22 Apr 2025 13:44:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745322243;
	bh=2lvC8aBIaC9vo96uZIY6di9kQoFjH1x9H9QBbtx+75c=;
	h=Date:From:To:Cc:Subject:From;
	b=t9CwRx3h3ZLSQoAemtcSHhCVOhFHGbshdxzvvUn5oHOWVhQAefYa00JZuYpSNnSkH
	 NowvuxVoF0o5z4HHKwvGN02jk3iDHX1rgFW4lVUI0NOTuRpo8ZgY+wWietCqmMCavP
	 7tVl/gXjqhJ2NtV9Vkof7ZGec3EgCQlF74V9fWOT0xTMF1lJ4Wd4sPzcIk8X2A8Orn
	 O8PFcQ9mxOf+WmVbsqz99kO5uVz1xYg+W8Mm8PefgyCrXvbuqqGEpeB/apeNz3Ilxo
	 3Ddj/i9GEgYbBd1x/TYcpbmTBPRUfsWVZCUkbnyA36A1LEcGNPdmJzGd8e0lX1r/um
	 7NYaOmW5anZSQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B3ADC6062F;
	Tue, 22 Apr 2025 13:44:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1745322241;
	bh=2lvC8aBIaC9vo96uZIY6di9kQoFjH1x9H9QBbtx+75c=;
	h=Date:From:To:Cc:Subject:From;
	b=X5uTpcw5fuPhnlqEX1HN8GUzZCYCc4kBXN76FAJKidxqklxgvDabgzwTUlSJY+xW7
	 fR5bf4duNLTFnFgcY9l0armM3JycVfk2iwJ+za51PgHN4QkjEvxoy1aZ9lpwsknZuO
	 QKjrcOzPHVFXzGik1l3pc1aZRd1avcmR89PV9p3dCuDVMfLW5KnFjlBFbFhYe/pmDx
	 VRGf0sog/TGSn8dVgyJ2ZLgAOIe4lbKecY97pdxmpDS7+57fVgbmoAMK1is5BP/0zQ
	 bis5HCV1Q53611fqMdZDlM+07WMjSqJcZW/J17LoiN7kP2AXr8KDs9D4zYBK/6Pl02
	 iMGCP90eLMJsQ==
Date: Tue, 22 Apr 2025 13:43:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] nftables 1.1.3 release
Message-ID: <aAeA_6rbRNqpIRE2@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="v0lrDgCn2ghomeXI"
Content-Disposition: inline


--v0lrDgCn2ghomeXI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.1.3

This release contains a few fixes:

- Incorrect bytecode for vlan pcp mangling from netdev family chains
  such as ingress/egress:

     ... vlan pcp set 6 counter

- Bogus element in large concatenated set ranges, leading to:

      16777216 . 00:11:22:33:44:55 . 10.1.2.3 comment "123456789012345678901234567890"

  instead of:

     "lo" . 00:11:22:33:44:55 . 10.1.2.3 comment "123456789012345678901234567890"

- Restore set auto-merge feature with timeouts, disabled in the
  previous v1.1.2 release.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

[ NOTE: We have switched to .tar.xz files for releases. ]

To build the code, libnftnl >= 1.2.9 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--v0lrDgCn2ghomeXI
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.1.3.txt"

Florian Westphal (1):
      evalute: make vlan pcp updates work

Pablo Neira Ayuso (3):
      Revert "intervals: do not merge intervals with different timeout"
      netlink: bogus concatenated set ranges with netlink message overrun
      build: Bump version to 1.1.3


--v0lrDgCn2ghomeXI--
