Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD4C5474F;
	Mon, 31 Aug 2026 17:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788197957; cv=none; b=skEAobZz6kvGMRUALs3YEDPTD7jgfQNu7tJf0Kq29qr748GQwZa/K7h4zoQWjUqx5MOWNl33gfFjdTOpO60SGX6lZxM8BJ0wGR05FdXYNR4gaRhjkF3LxS8BR0HHOixPfcCOXhj6Oj+7n/C9+WDpbQ1OmnJhseuyUn2Kuccncfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788197957; c=relaxed/simple;
	bh=csqSwyhefTIzkKmCj7qQ+cfvJTmkPUFMOWQoj8Qgqu4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eRhMZ3elWzjkori7eFvOl02s5oaJFEKlXsEB7jX63ciD2x8SBq1ads5dcpyLO94SfcSNSiBSXFDTCrXDRg2kXvn0KzHbHcAHWJCiTmO1rnAdgiIZiUO5IqF46C4TXDTKR1+GTC+hpfj5mfoPCFOr3mrYXlAREEfRr7duyU8Kr1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dRLmM6rU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dRLmM6rU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788197946;
	bh=0bpU+GRbtJlvCX9ZJt5x8GoB/+iu61+0H8Mpxv3TMJ8=;
	h=Date:From:To:Cc:Subject:From;
	b=dRLmM6rUJD6uisrwXYzvlxcbJSYwtnrwuNZKNqcOiCNUFYGrchDgCjUbnVuxHagQ8
	 sgi8oIeGlKoZBfSTQbe+VA4IJuKK1uhFt69npvAR3QKyAr7M5FyNWSzQ4lgVOOzC60
	 BhyKAY3QwC1u5wC7Q2aRuLiFAhGnn0ZXBDovISNGjl0Xqb8xHBtvMNRgvxKksUoDye
	 j1H4B13KMsa0gl//XKE26hAumNcP7C80wy519Al+6SwGzQ+Y3/gt+DXb6ahPIC550r
	 x020xDimW55RQeE9JFKzoCOWnqhpeiaCLtFwcl3MlFIydKJckDCingFUa099IGQQBp
	 4xFnxkOMNOWtA==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 04E4860052;
	Mon, 31 Aug 2026 19:39:06 +0200 (CEST)
Date: Mon, 31 Aug 2026 19:39:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.3.2 release
Message-ID: <apW8N9X8ptmF9fIo@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2RAc12NeVxEjd7v6"
Content-Disposition: inline


--2RAc12NeVxEjd7v6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.3.2

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

This release contains:

- Support for connlimit stateful objects
- Fix compilation of examples for musl libc
- Validate geneve class and type attribute size in setter
- Validate kernel does not provide too long geneve data attribute
- Remove internal nftnl_set{,_elem}_clone() function
- Do not print userdata content through snprintf API
- Enhancements for the snprint API to display data according to
  size and byteorder, this includes new functions
  nftnl_{expr,set_elem}_set_imm() to decorate the data.
- Remove a trailing whitespace in snprintf() API for
  expressions.
- More improvements for the snprintf() API for set elements:
  no colon is printed if data is not provided, print object names
  in maps and print flags only if non-zero.

See ChangeLog that comes attached to this email for more details on
the updates.

You can download it from:

https://www.netfilter.org/projects/libnftnl/downloads.html

Happy firewalling.

--2RAc12NeVxEjd7v6
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-libnftnl-1.3.2.txt"

Anna Wilcox (1):
      examples: nft-rule-add: Fix compile on musl libc

Fernando Fernandez Mancera (1):
      src: add connlimit stateful object support

Pablo Neira Ayuso (1):
      build: libnftnl 1.3.2 release

Pengpeng Hou (2):
      tunnel: check kernel does not provide too large geneve data
      tunnel: validate geneve class and type from setter

Phil Sutter (12):
      set_elem: Review debug output
      expr: data_reg: Avoid extra whitespace
      expr: Pass byteorder to struct expr_ops::set callback
      data_reg: Introduce struct nftnl_data_reg::byteorder field
      data_reg: Introduce struct nftnl_data_reg::sizes array
      Introduce nftnl_{expr,set_elem}_set_imm()
      data_reg: Respect data byteorder when printing
      data_reg: Support concatenated data
      udata: Store u32 udata values in Big Endian
      Revert "udata: Store u32 udata values in Big Endian"
      src: Do not include userdata content in debug output
      set{,_elem}: Drop nftnl_set{,_elem}_clone()


--2RAc12NeVxEjd7v6--
