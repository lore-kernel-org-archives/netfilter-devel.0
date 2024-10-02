Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D925A84A36;
	Wed,  2 Oct 2024 22:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909642; cv=none; b=DfoXtB5/CJlJUhPEhSc1xccUNIpKPUXrUddehgeY+sLFCwHAClBYmOgsRWSJS58JkdvF4o3UIc9ADlpeW+4Ilw7opTVmJW2x+Kzods134Zz2QkqLcwnMgYDieytGuOoTK35iske7E6sRGtHAgj1lyBIv7ckkpv65hHLQbzLCfxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909642; c=relaxed/simple;
	bh=0zjMo9uus+vZLntPQs1e06U24r/4GzaUI1aeovRWxRU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XfVr2lRsRmQxU1HMX3YFI2fyJABQ6aS9Ij1m8AEWUXOH6tjjSeT1kjpKMK8TPlRMzCNYAIX+UySaAnO5HIwDhGWN833Jnz7Qxdks2d4ic1Chw99igtBGA7U9g7tMknV3UXIJyQ5jUnFvuS3xY5KsfIiDrqQ5k4FD1Fc/JTs49jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=56532 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sw8EB-00CTXI-Js; Thu, 03 Oct 2024 00:53:53 +0200
Date: Thu, 3 Oct 2024 00:53:50 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.2.8 release
Message-ID: <Zv3O_lxf0Rh450_T@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GhNsXPny9S+yJ+VV"
Content-Disposition: inline
X-Spam-Score: -1.9 (-)


--GhNsXPny9S+yJ+VV
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.2.8

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

This release contains a few fixes only:

* incorrect validation of dynset netlink attribute from the kernel.
* don't append a newline when printing a rule.

See ChangeLog that comes attached to this email for more details on
the updates.

You can download it from:

https://www.netfilter.org/projects/libnftnl/downloads.html

Happy firewalling.

--GhNsXPny9S+yJ+VV
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-libnftnl-1.2.8.txt"

Florian Westphal (1):
      expr: dynset: validate expressions are of nested type

Pablo Neira Ayuso (2):
      src: remove scaffolding around deprecated parser functions
      build: libnftnl 1.2.8 release

Phil Sutter (1):
      rule: Don't append a newline when printing a rule


--GhNsXPny9S+yJ+VV--
