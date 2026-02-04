Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8770B1534EC;
	Wed,  4 Feb 2026 00:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770165550; cv=none; b=RY5Zn4To+wyHc2gh/+d00eOPFxOfi2zSTXVkq+I22LkGwWdfIKrbJTRFnQKdKXQvqN6kTRxMMN2MOykUI37o5R2Fl5340OfcYS38CgwVtBXDNgT/6eXMc1sDhC+RchM2+5iOxgqF+/Vr44bTzowoycYQDQKi00iRd3pNWv2aqZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770165550; c=relaxed/simple;
	bh=DbmVBOrTDaaWAI3H2cZYqRJnneSW8n7DafFIcg16ZSU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=CDuK0PUD3VXdG46IdWAAMDcrcDmGZnhnO4/x6P6VVTszvgjHsb/daxMRXQtQcF5bSgrVa6Wfzs02ize0dgp6oZCTf6tWBvifY1JZYCbUOCO/9kWvILiQVyXhvhPHpKjpbbODQonSOJJlvB764+ZuYPlm+3edmNxTd8TiAK76Qe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Z+LPmYyx; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Z+LPmYyx"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3216D60262;
	Wed,  4 Feb 2026 01:39:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770165545;
	bh=hODZ8pCredpBly+ZZRlxRnbNjQ8zTK4Fc3O0XoBLw4E=;
	h=Date:From:To:Cc:Subject:From;
	b=Z+LPmYyxH9QZTrac1f4n1omkVUyV4+RL7J+FRXThSJi1/Uc3OghQXTBa9k5AGIRBI
	 5KjnfHNF1G3oe/BBbSQzLPftP3A+NJwYkBNCgmCFMWnFcFaxVUaSpUYZtNE/3dTcl5
	 zmqcx9OtDNW7Sxh2TdjSmV+0ByNveP01CpBfwBisF5/xhPXaM5nIsjHhUjCha5waao
	 4stfnP6JF/Zj/9hy9yM0raDCcxA1jymx6pijMPrdXMR6KnczpPwxnGP7LepICeiuOK
	 ltVuEwsJkzCRDL6cXk2RV5suxQmg/7AaFP2b3PIv8J0qoawOWn993zldtJd7u+DD5/
	 YBWNEMAqWo6bg==
Date: Wed, 4 Feb 2026 01:39:02 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	lwn@lwn.net
Subject: [ANNOUNCE] libnetfilter_conntrack 1.1.1 release
Message-ID: <aYKVJu8myzrGdn1-@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xV+QKYKpyIX7vA9Q"
Content-Disposition: inline


--xV+QKYKpyIX7vA9Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project presents:

        libnetfilter_conntrack 1.1.1

This release includes:

- Support for the new CTA_TIMESTAMP_EVENT attribute, available since
  Linux kernel >= 6.14

See ChangeLog that comes attached to this email for more details.

You can download it from:

https://www.netfilter.org/projects/libnetfilter_conntrack/downloads.html

NB: This release has switched to tar.xz files.

--xV+QKYKpyIX7vA9Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment;
	filename="changes-libnetfilter_conntrack-1.1.1.txt"

Florian Westphal (1):
      src: add support for CTA_TIMESTAMP_EVENT

Pablo Neira Ayuso (1):
      libnetfilter_conntrack: bump version to 1.1.1


--xV+QKYKpyIX7vA9Q--
