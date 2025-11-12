Received: from sender-op-o15.zoho.eu (sender-op-o15.zoho.eu [136.143.169.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4892DD5E2
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Nov 2025 22:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762987026; cv=pass; b=cJbQDvaWNlVjQzF6AMBFf92BiNkWXtrUBVIkX7j2UD0o1bh0lcvnpnyeJIixEMtmSPrdgWzCF7IGVM0OQONDtaup+5M98o9f9P6nfliLpvRI0qQmJ8PatFSKYMklt+lPn7tiBmjvt6mgxU3s5kbcD+ufFdp5A7Qfm0p2Ib0QL2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762987026; c=relaxed/simple;
	bh=eoTdYUFxaATAfwIAIUokQ8Rg+W9xI9PG57Rqmj1wr5o=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:Subject:MIME-Version:
	 Content-Type; b=rL6W2mq/nY6gxAnjfjEJm5IOXD3wIikEh3EH0tezUDC8UiknxcZ97dbjKNZj49E/JxZEoTvP1ie7aDkDqqThWFAEEUks3trOWSdeyDQMM1G/wryvyYkWQ9yTorylhoylkwoCwtUlHtEnr6ay3E22Ew3aIMAt6Tbn6IlEUMQkheA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nftban.com; spf=pass smtp.mailfrom=nftban.com; dkim=temperror (0-bit key) header.d=nftban.com header.i=contact@nftban.com header.b=bkUSzky8; arc=pass smtp.client-ip=136.143.169.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nftban.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nftban.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=nftban.com header.i=contact@nftban.com header.b="bkUSzky8"
ARC-Seal: i=1; a=rsa-sha256; t=1762987006; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=YCWcPq2Je3VZkGHqIJfVJ9tVSTyiu2n1RwTybiqIw1OHMVRsWkFbe9ghYKM05GVOJiwRwfgBpnyvpQ4vWihkvTHhR9aJNeH8EsbYGLqj2OdR8QYaUMS8VPDrXsflDOdF3NRWyg+uQhy9zC6FXXx8Zjlm+XwoCMzZ9bCgrWIQ1n4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1762987006; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=eoTdYUFxaATAfwIAIUokQ8Rg+W9xI9PG57Rqmj1wr5o=; 
	b=Y2pGaOnCaS3tj19B3Zd5c9Dq7inWAT809leX2/SVghI0HQVa204P3KL/xAAHkI94vbbmIuZK/QkKrGb/0KjkleyCu3BjQ+veqCQ3eGQRY3DrHCP6E7gxkKkQ42g3Oqzdc+n4tBU+56fuZkPRL9R5zZcXVOsu23fauE3VlT7qYZk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=nftban.com;
	spf=pass  smtp.mailfrom=contact@nftban.com;
	dmarc=pass header.from=<contact@nftban.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1762987006;
	s=dkim; d=nftban.com; i=contact@nftban.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=eoTdYUFxaATAfwIAIUokQ8Rg+W9xI9PG57Rqmj1wr5o=;
	b=bkUSzky8WX0njwc9qhbYctZluRz2YhYXyWJMHk0nA9eR2EMM4U2cOF05jrP6mizo
	TJzL7ISOSBbcTu18cgaFmBl0bspVN9FtmOEAzS2+PMfBt4GwNe3cTr/3oqMmWBR1y/s
	uIA9Ug+smh3bHMjrm2DiG4jXiy94EFdI66Oqy/Qg=
Received: from mail.zoho.eu by mx.zoho.eu
	with SMTP id 1762987005581382.5112374338862; Wed, 12 Nov 2025 23:36:45 +0100 (CET)
Date: Thu, 13 Nov 2025 00:36:45 +0200
From: Antonios Voulvoulis <contact@nftban.com>
To: "netfilter-devel" <netfilter-devel@vger.kernel.org>
Cc: "pablo" <pablo@netfilter.org>, "fw" <fw@strlen.de>
Message-ID: <19a7a36d661.12807b73b363175.6432167163249493689@nftban.com>
In-Reply-To: 
Subject: =?UTF-8?Q?[RFC]_Review_of_NFTBan_nftables_arch?=
 =?UTF-8?Q?itecture_=E2=80=94_DDoS_&_port-scan_handling?=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hello netfilter/nftables maintainers,

I=E2=80=99m the author of **NFTBan**, an adaptive firewall manager built on=
 top of nftables.

I=E2=80=99d like to request a short technical review focused on our DDoS an=
d port-scan handling,
and validation of our nftables usage patterns.

Full document:
https://github.com/nftban/nftban/blob/main/docs/NFTBAN_NFTABLES_ARCHITECTUR=
E_REVIEW.md

NFTBan Sample nftables Configuration:
https://github.com/itcmsgr/nftban/blob/main/docs/sample_nftban.nft

### Quick summary
- Uses `inet` tables; runtime + main table model.
- Atomic reload (rename-swap).
- DDoS protection: SYN rate limits, connection tracking thresholds.
- Port-scan detection via userspace tracking + temporary IP sets.

### Key review questions
1. Best approach to handle large dynamic sets (100k+ IPs) efficiently.
2. Whether `ct count` provides per-IP limits or global counting.
3. Recommended kernel-native way to detect multi-port scans per source IP.
4. Any race/safety issues with rename-swap atomic reloads.
5. Recommended tuning or known pitfalls for high conntrack load.

All details, code snippets, and metrics are in the linked document.

Thank you for your time =E2=80=94 feedback from the nftables maintainers
will help ensure our design follows kernel and nftables best practices.


## Contact

**Maintainer:** Antonios Voulvoulis
**Email:** contact@nftban.com
**Project:** https://nftban.com
**Repository:** https://github.com/itcmsgr/nftban

Thank you for your time and guidance.

---

Antonios Voulvoulis
Founder & Architect =E2=80=94 NFTBan
Security by Design =E2=80=A2 Open Source Transparency
https://nftban.com | https://github.com/itcmsgr/nftban
