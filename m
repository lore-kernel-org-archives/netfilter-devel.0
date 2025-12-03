Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D381D555;
	Wed,  3 Dec 2025 16:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778130; cv=none; b=PqA1ZR8CUC6P8OeAdaaZc0ar2DGVZtduT9Euz4dxeLZ5ETXj5ikaAyWVAElJLpOZlwQDyLSDxqqJjcht5R17oMugk8aImaRcS8xQ0Zuu2oQ7Qu8fLjW2347pJi08BCMLAD6oHQyrNyb99fUl9+hclXitQqDQajIwZjyLtDgwiW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778130; c=relaxed/simple;
	bh=aUs6lQYder+1Mm0Q6gTZnBaAxTkukI4Bt7fVzmsbOLI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nRnfarhVfspfhMoFdXe46VRtqehhHpHdLtWp3jpbODQLD3CqjkZUHsD+ycEzZigh+aJeXpeP9xcYsZqRnUjz6rL8NoDnPTJh6mLUdGNtws0TcXBMP3CfEEGP06ybNp6DIIdxMNF2z2qFeORbuc0SUdZ8zlmxrnrp/zZ8KJ4+QMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S1/7c+dg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S1/7c+dg"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AEEFC60251;
	Wed,  3 Dec 2025 17:08:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764778116;
	bh=RIZH+837axEPMbvjhXwhKSwSV47vc6GEjWwvPWuY5cs=;
	h=Date:From:To:Cc:Subject:From;
	b=S1/7c+dgHHl/kqLOzFScI8bPeSLlUjsD7kBN8zPotQNfzWvXoRpji/6aF+ev93JVg
	 kkYxgdbofai9yklfDmufg5sMpOzXRgQj4gQiKEtWINF0QbstyRyjj/H6Uuz2m5MPCs
	 R44sk9VE6akeaH4IyNXnKsQRCSJnvMgHFcYqFEkj8cxSogl4bwgEaVOLfBG+eORxCM
	 HbpRStOmep1H71p988BIURWY17VYMR6dXHUxYMfyRbnRnhWTrcbZz/AM2r3V66PDuJ
	 PtQoIVP4xI5CbwhPLeRFywiBwdGXIYo6+oMVZxG3+vvdvHsuwhXvkaOZ7TtBadxWnf
	 ZCGIMGTZM/Swg==
Date: Wed, 3 Dec 2025 16:08:34 +0000
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.3.1 release
Message-ID: <aTBggr8_2CS9fa2k@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cI0bsuTuS2bhIJ9G"
Content-Disposition: inline


--cI0bsuTuS2bhIJ9G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.3.1

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

This release contains:

- add meta ibrhwaddr support
- fix for NFTA_DEVICE_PREFIX with asterisk at the end of the string
- new NFTNL_UDATA_TABLE_NFT{VER,BLD} to store build information in userdata
- complete tunnel options support

See ChangeLog that comes attached to this email for more details on
the updates.

You can download it from:

https://www.netfilter.org/projects/libnftnl/downloads.html

Happy firewalling.

--cI0bsuTuS2bhIJ9G
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-libnftnl-1.3.1.txt"

Fernando Fernandez Mancera (2):
      tunnel: add support to geneve options
      expr: meta: introduce ibrhwaddr meta expression

Pablo Neira Ayuso (2):
      tunnel: rework options
      build: libnftnl 1.3.1 release

Phil Sutter (4):
      udata: Introduce NFTNL_UDATA_TABLE_NFT{VER,BLD}
      utils: Add helpers for interface name wildcards
      utils: Drop asterisk from end of NFTA_DEVICE_PREFIX strings
      utils: Introduce nftnl_parse_str_attr()


--cI0bsuTuS2bhIJ9G--
