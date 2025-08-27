Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9337030CD85;
	Wed, 27 Aug 2025 21:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756330332; cv=none; b=G3QmFK3/SDVHx9DF7hKuYni8EPAq1gXGFQVPkwOlqKifbfjemflJmQ3ogbC7wY0ehsKc5XrktvWD1GLfLKyi4+FWne1ppSU5VR0CN6it/dhxA+RLHt0fVytaOxncRuVQnVMRh/wRzv7DTIureXO7TQnTyYbLUkiXV5cXZtTO4aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756330332; c=relaxed/simple;
	bh=fPktTsvc+5rj6kVjcZ9RgUjeMGnA6cFBiR+ev0o78gc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=biGQogrGf+72ssbotUK5s6lcgEUsrTceyEk0aMQbM7eHfTvFuubSkowllGf+4FVi/KfzatmjsbsyMFtltK4GIwQdu0CWmuXkQeqXv2NYbtc3z9o2Am974uriWrUSUD9q8zkSPXZPrs19verFuWh2WuE2jG+eIuvtOFugylC4hvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=pEC9ybAt; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KjHzhC49; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="pEC9ybAt";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KjHzhC49"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 1512560288; Wed, 27 Aug 2025 23:32:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756330328;
	bh=0ELUVWyjP4IjrZ67OFFVa2EqcuCxlf48GkN8m243Uzg=;
	h=Date:From:To:Cc:Subject:From;
	b=pEC9ybAtC5xUiBaKTWfcUHR6BCLwodruuYZZjNKwXxulLMOjfQB1bOU02fXW+u0ru
	 EobdPZzu1nQ+EtHEJ/MFk6CA+lxzhAUOPZbGct7ptd4nCFDNl761B1ySEUse7JoIsX
	 zvLovr/s8BhLjI8ykwKn0ZCIG5BhFJ1AJqQdZumF6JWEICVVUBaW8bHlpZrVe/BrU9
	 PVcFmYQO5kkTNkF24MrBJfkjRHKIAjs4tISm1w+WlPZ5mopzxSmxi2tXVOfXB/w770
	 qHqIALXBUm9F3y+wfoQhetU5CWlF46qIOJpWwYsLjMzSthy9CTLfb3EWzm7Vgd4jbN
	 BQVFcMXRDPufw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D3EA36027E;
	Wed, 27 Aug 2025 23:32:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756330327;
	bh=0ELUVWyjP4IjrZ67OFFVa2EqcuCxlf48GkN8m243Uzg=;
	h=Date:From:To:Cc:Subject:From;
	b=KjHzhC49hBG47Dw7cJVsn0SFff/BOD57X9gkjKfkkgCMUniA1g/hwqK5j/bcvkfNJ
	 cftobgT0mDF6Yrn0THASH/F70wJiCEccCTyEbnC/pHd+l+5deBpKkKoa0ttTm5fZYw
	 RTmL/xtYOpkjK5sf24Eex8Do3glRmgQ2bVKQ+QabGnzAdHaqV65yw4DIb0oc4gFxfd
	 BpNaH+uf7risnyExFhJ3RjeFg5sGUep2S9avLVSoXQ+RZ+qOoIRgXIdcaE+3gba5dt
	 aLwz32R60OG/nXNiRU49/DtwQ0vL0FV2OeAI735fCKHoGj4lvWlk0d1FRuXhzcaQdz
	 hI02jAu/9kWmw==
Date: Wed, 27 Aug 2025 23:32:04 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] nftables 1.1.5 release
Message-ID: <aK95VLv5qvd-RbGf@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KvBgT5VujLnxGQF8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


--KvBgT5VujLnxGQF8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.1.5

This release contains fixes:

- Fix regressions in JSON ruleset listing, restore set flags to display
  single item with array:

    -                    "flags": "interval"
    +                    "flags": ["interval"]

  ... and use "oif" result type instead of the new check for simple
  matching on fib:

    -                    "result": "check"
    +                    "result": "oif"

  to restore third party JSON parsers.

- Add new --with-unitdir=PATH option for ./configure to install the
  nftables systemd unit file. If PATH is not specified, then auto-detect
  systemd unit path. Check man(8) nftables.service for more information.

- Fix misleading "No buffer space available" error when kernel reports
  too many errors back to userspace.

... and a handful more of small fixes.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

To build the code, libnftnl >= 1.3.0 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--KvBgT5VujLnxGQF8
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.1.5.txt"
Content-Transfer-Encoding: 8bit

Florian Westphal (6):
      tests: py: revert dccp python tests
      tests: shell: update comment to name the right commit.
      evaluate: check XOR RHS operand is a constant value
      tests: shell: add parser and packetpath test
      src: fix memory leak in anon chain error handling
      mnl: silence compiler warning

Jan Engelhardt (1):
      tools: add a systemd unit for static rulesets

Pablo Neira Ayuso (8):
      segtree: incorrect type when aggregating concatenated set ranges
      src: ensure chain policy evaluation when specified
      fib: restore JSON output for relational expressions
      tests: shell: cover sets as set elems evaluation
      tests: shell: coverage for simple verdict map merger
      mnl: continue on ENOBUFS errors when processing batch
      build: disable --with-unitdir by default
      build: Bump version to 1.1.5

Phil Sutter (19):
      tests: shell: Fix packetpath/rate_limit for old socat
      src: netlink: netlink_delinearize_table() may return NULL
      tests: py: Drop duplicate test in any/meta.t
      tests: py: Drop stale entries since redundant test case removal
      tests: py: Drop stale payload from any/rawpayload.t.payload
      tests: py: Drop duplicate test from inet/geneve.t
      tests: py: Drop duplicate test from inet/gre.t
      tests: py: Drop duplicate test from inet/gretap.t
      tests: py: Drop stale entry from inet/tcp.t.json
      tests: py: Drop duplicate test from inet/vxlan.t
      tests: py: Drop redundant payloads for ip/ip.t
      tests: py: Drop stale entry from ip/snat.t.json
      tests: py: Drop stale entries from ip6/{ct,meta}.t.json
      tests: py: Drop stale entry from ip/snat.t.payload
      tests: py: Fix tests added for 'icmpv6 taddr' support
      json: Do not reduce single-item arrays on output
      tests: monitor: Fix for flag arrays in JSON output
      trace: Fix for memleak in trace_alloc_list() error path
      Makefile: Fix for 'make distcheck'

Łukasz Stelmach (1):
      doc: Add a note about route_localnet sysctl


--KvBgT5VujLnxGQF8--
