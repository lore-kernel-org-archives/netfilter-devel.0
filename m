Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CAC28A1E5;
	Mon, 14 Apr 2025 17:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744652373; cv=none; b=UY1foWf/F3Z0zySbbkTubC9E1HpG2X3edYMCvMgwIP6CFV17DsrIQvIkgMrB52LvhzjRe2bdFqZkEjulNuxzfdq5X/srJaI4rV/zlueqm46YEEE7fLrLHKbNltjSmyCbzIUooHSiRPz1UuXc24LestrFl2419ZD7ss/Dlym7gKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744652373; c=relaxed/simple;
	bh=qSEYZ9UOT/jHJcybbv9GFveiaYx/sjtPhSOlaOh95bc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rnmQp7zVZt2LVG63mI54aYeZKkJLiJ+ItOe1yjZbBhihIRQcK2ngXdGzIOHE8gtsvCAdkjWJZbjGt1cJjA9TUNW4M8TUP/H4dgplRs6KYa8YGJOXPd6ELCQ1gvbeoC2OyQPNO952vLUgvT3Tj8byyDiv+/kYgb3y4kGjp4ht51g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hm6QQ+du; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hm6QQ+du; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hm6QQ+du";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hm6QQ+du"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DEEDD6055F; Mon, 14 Apr 2025 19:39:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744652360;
	bh=8jHBEsasF/8IMpOg4nCUTh2+TOhhG0UQgIPklSrnDp8=;
	h=Date:From:To:Cc:Subject:From;
	b=hm6QQ+dusEWONa2r50Z6kDsnHssjCxDK+8IRDzeY+296Czyx4G+fV7a46sKj9aqlD
	 BiNJwzRwMCxTt0mePIsKCrAZaejlead167UyRCWYzAclz3ZHNRjauQEqClGD62Ot+w
	 rzhEvYaPZTghjN9OqLo8N4NizJMZI8wji9BjrTGHMMHVV4gyVki6eU096GDdD2bwuq
	 18BOkqpS2IhQINJ7iXQX99wJqULzoE0QCmCUKi3l1+rgFRZ5GYTETWpG3JoYuiQ8mC
	 IF4fvr1gO9Bwi04cBSBdIiStCpJMKMjWdmYOOYqNqHMLNP/NVd6qIs+dEy+WE/Uskj
	 eprlTg5CW3eQw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 016866055F;
	Mon, 14 Apr 2025 19:39:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744652360;
	bh=8jHBEsasF/8IMpOg4nCUTh2+TOhhG0UQgIPklSrnDp8=;
	h=Date:From:To:Cc:Subject:From;
	b=hm6QQ+dusEWONa2r50Z6kDsnHssjCxDK+8IRDzeY+296Czyx4G+fV7a46sKj9aqlD
	 BiNJwzRwMCxTt0mePIsKCrAZaejlead167UyRCWYzAclz3ZHNRjauQEqClGD62Ot+w
	 rzhEvYaPZTghjN9OqLo8N4NizJMZI8wji9BjrTGHMMHVV4gyVki6eU096GDdD2bwuq
	 18BOkqpS2IhQINJ7iXQX99wJqULzoE0QCmCUKi3l1+rgFRZ5GYTETWpG3JoYuiQ8mC
	 IF4fvr1gO9Bwi04cBSBdIiStCpJMKMjWdmYOOYqNqHMLNP/NVd6qIs+dEy+WE/Uskj
	 eprlTg5CW3eQw==
Date: Mon, 14 Apr 2025 19:39:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.2.9 release
Message-ID: <Z_1IRQHhW_RbRrcZ@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="GTgtj1GOOm22bIjI"
Content-Disposition: inline


--GTgtj1GOOm22bIjI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.2.9

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

This release contains:

* add support for kernel space AND, OR and XOR operations (for Linux kernel >= 6.13)
* fix for vxlan tunnel options
* fix ct id printed as 'unknown' key
* fix device array overrun
* remove deprecated unused functions
* improved test coverage

See ChangeLog that comes attached to this email for more details on
the updates.

You can download it from:

https://www.netfilter.org/projects/libnftnl/downloads.html

Happy firewalling.

--GTgtj1GOOm22bIjI
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-libnftnl-1.2.9.txt"

Fernando Fernandez Mancera (1):
      tunnel: add missing inner nested netlink attribute for vxlan options

Jeremy Sowden (5):
      include: add new bitwise boolean attributes to nf_tables.h
      expr: bitwise: rename some boolean operation functions
      expr: bitwise: add support for kernel space AND, OR and XOR operations
      tests: bitwise: refactor shift tests
      tests: bitwise: add tests for new boolean operations

Pablo Neira Ayuso (2):
      include: refresh nf_tables.h copy
      build: libnftnl 1.2.9 release

Phil Sutter (5):
      Introduce struct nftnl_str_array
      Use SPDX License Identifiers in headers
      set: Fix for array overrun when setting NFTNL_SET_DESC_CONCAT
      tests: Extend set test by NFTNL_SET_DESC_CONCAT
      tests: Fix for ASAN

Zhongqiu Duan (3):
      expr: payload: print tunnel header
      expr: ct: print key name of id field
      src: remove unused str2XXX helpers


--GTgtj1GOOm22bIjI--
