Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11042A1BF;
	Wed,  6 Aug 2025 11:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754480101; cv=none; b=uqVTZFEsGjwysygZp/rTKWPUxRoxweBlgf/Hh+lrudb4mUfehJ+dVsFUelXPHoO2oKDlt2G3Uk9DSQ3v99AWJ2mhEDm0mNmIS9KbQHCHhGnWHidPsJU8YYkaWPlLy8ua5Ej9Dn05qCaHyB10PYqgcd1gFVMlolajmR9gZXNJ1q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754480101; c=relaxed/simple;
	bh=W4rwlHaSvDKGl+sStfh9sczWXDZ0ixk9dOW6sS06uEY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uh9g/4GVRiMtRPmMVaMvdoBD1uPJCQHsNAODQRhIMJurXxneOBKikruYxG2sxkN7IcmDHlIQZxnCFJu1f6EWuBtOAeLYd3U34mr/qCEgjPuoP+M0Mz3SkJrGg2QZWxh62BWxLj9K4N93rgnG3IU7tEwam3GA4ZMG/lfU/r3HdH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gX/gPd8L; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ol2GmfxJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gX/gPd8L";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ol2GmfxJ"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 797B160279; Wed,  6 Aug 2025 13:28:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754479719;
	bh=UlOS9o3OABmPZz5lbe2WqHBoS4+IA1g/ww5/IefMcQc=;
	h=Date:From:To:Cc:Subject:From;
	b=gX/gPd8L1TBP7fQ6+rLXjDU6q6EQDPQYckd+vUKRaBB+KDWgG5VwjuF4+/UA0aDAn
	 ejrLQtuCJ3MGB1I8Vc7aeyvl9olHKdxLY3G4FYWGDqRfB21T5/9h+HFP3k7I15R8G7
	 SzggHXKa5xB6j6iZto8rgo2I7NuhIaNA/KAMYYvIu18pW+po4Z5TnbfTOSHn9jA9oE
	 JeYUKnmbmR/m77/XpWr9Cob7pm9m+zJVZBVXFAvBGJ0LwkOfabi3evutTq9JiT9xBe
	 6Gtz/grN271810o5dbK2kwcBdN/DRm/HCVZ8SsC1SvCjn4hYUx5AWJqxfwOetsbODf
	 N8/P8XkTE7ZBw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 99C3860272;
	Wed,  6 Aug 2025 13:28:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754479718;
	bh=UlOS9o3OABmPZz5lbe2WqHBoS4+IA1g/ww5/IefMcQc=;
	h=Date:From:To:Cc:Subject:From;
	b=ol2GmfxJoRS24OCfm60gJTjXOrAVgrptlZcAUfEl32fswZfh9RBuc1LWr39BsrANA
	 hbhNh4XDubq7poSopGug8MJZe0O8YANg7EpeNQ9+EDv1iVPkfRd4xt5SBTiZGNu1FH
	 BSb5bPXuhWAkuxdGKHcl64e/jiEiP6YXnn0EupYeQ6hyVRCEHbJ/PoUP0Z3m3Jq7J6
	 asHLsej8knGVmmztL45QDlf7ntyDhieg/ljW0enymBkIAXq++lrMRYjVys/pZc8z4f
	 QDOrkE8SZp+NDqT8YfxckEXahx4NBp/0+RR2tAyv+2nDUUpZpuCGHPytCv6KDa1UJC
	 wCVFIgWmHfBnw==
Date: Wed, 6 Aug 2025 13:28:36 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net
Subject: [ANNOUNCE] libnftnl 1.3.0 release
Message-ID: <aJM8ZPySLNObX5r8@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CG6Ef307iwJVByZ0"
Content-Disposition: inline


--CG6Ef307iwJVByZ0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnftnl 1.3.0

libnftnl is a userspace library providing a low-level netlink
programming interface (API) to the in-kernel nf_tables subsystem.
This library is currently used by nftables.

This release contains:

- support for conntrack information in traces.
- new set element count.

These feature require Linux kernel >= 6.16.

See ChangeLog that comes attached to this email for more details on
the updates.

You can download it from:

https://www.netfilter.org/projects/libnftnl/downloads.html

Happy firewalling.


--CG6Ef307iwJVByZ0
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-libnftnl-1.3.0.txt"

Florian Westphal (2):
      set: dump set backend name (hash, rbtree...) and elem count, if available
      trace: add support for TRACE_CT information

Pablo Neira Ayuso (1):
      build: libnftnl 1.3.0 release

Phil Sutter (1):
      include: utils.h needs errno.h


--CG6Ef307iwJVByZ0--
