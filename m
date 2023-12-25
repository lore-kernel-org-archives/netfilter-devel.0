Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE8B524C4
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Dec 2023 15:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="HJyd9Eg0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1703517988; x=1703777188;
	bh=XE0RGXzi7SC+kE8ggyFgj5ePPG5WZgpIAXE6wYhBZ0g=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=HJyd9Eg0y/Xhlcst1raEzRv/+3/TkI2R3v5KA//wCFzZLmv07GVz+LKG556ua1GnI
	 nYd06+pN4Wp5lHpNnWVh+1LtUJdGJc6uXiQy+rGh8ODCGoWU+hRcdQ077sxeLuh2pX
	 yFbzKZJsoD+soJm8oi2dZBOthmwMhRpMUXfqtHb/yHUc9tPpAJMFYuJtZ6xFW4vSAs
	 KJvs520WbWMz7ig1Cz5XAayDCtAQM5xsNeOw5bzECVX4o5LMSOyzRlgkIneFNIUF6f
	 Xg05xFXe+pnS3XJZcXkg+wfIrh3nr9QNhbEEhZ8TBYEW+r5yypMGL10Pm+b8IW+nlG
	 ngbvodmpRDFhw==
Date: Mon, 25 Dec 2023 15:26:13 +0000
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc: "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Subject: GUI Frontend for iptables and nftables Linux firewalls
Message-ID: <F2UgPsJY77kOox0aLlaT8ezVQQdgsDcsP95OPo5wyKzn230KLtlp1R_NHDRcM2FzpUByrp72jC2s1qu-7aV6kNmig0Rxn1Bly-ci51RE7t4=@protonmail.com>
Feedback-ID: 39510961:user:proton
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Subject: GUI Frontend for iptables and nftables Linux firewalls

Good day from Singapore,

Besides Webmin, are there any other good GUI frontends for iptables and nft=
ables?

The GUI frontend needs to allow complex firewall configurations. I think We=
bmin only allows simple firewall configurations.

Please advise.

Thank you.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individual in Singapore





