Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5596C1991DA;
	Wed,  2 Oct 2024 22:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727909861; cv=none; b=P25y2bJOiIIi3P8CZkWCyN8jrKThE2ZRBDnFGtR+O1j0Fw20+7dI4rTGhfkUM3nx5okD0mF0LVKdLQvZ7Sr+h3H6nG0p1ZKGDPljCiIxGSZ99MI2T4q16NjiQ1aLelX593mO4ymYhp3oN4aJiB3kOTiRgintK/pSX3aT5dHIQeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727909861; c=relaxed/simple;
	bh=kUD2s873Tx7+RzMOHZIWcwXdNSnOmu/rAeRsLHE/jrc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=EsHV7MtDm2MOG1CGE8c7a8/kXF4AaERJnvnsomDonpIkSrkoqywSyicsf+1TRHOCDnNLUs8cXqA19sr9yV/qc7NE2P+GoWPZBYqxwK5uxS2SYysN52JL0XJgEvbHaRceZt7bQXp+TbNZ/hlHQmgxIH68CtX7Dx4DA686n407RGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=42854 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sw8Hi-00CTgm-7G; Thu, 03 Oct 2024 00:57:32 +0200
Date: Thu, 3 Oct 2024 00:57:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] nftables 1.1.1 release
Message-ID: <Zv3P2VdIqSG2xUmE@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="va7Ua4rSdMdHbrRm"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.7 (-)


--va7Ua4rSdMdHbrRm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.1.1

This release contains mostly fixes, listed in no particular order:

- reduce netlink cache dependencies to speed up incremental updates.
- fix UDP packet mangling when checksum field is zero.
- several fixes for nft reset command.
- JSON parser fixes.
- variables are not supported by -o/--optimize.
- allow zero burst in byte ratelimiter.

  table netdev filter {
       set test123 {
               typeof ip saddr
               limit rate over 1 mbytes/second
               elements = { 1.2.3.4 limit rate over 1 mbytes/second }
       }
  }

- fix double-free when users call nft_ctx_clear_vars() first, then nft_ctx_free().
- document that tproxy statement is non-terminal (compared to iptables).
  This allows for tproxy+log and tproxy+mark combos, see man nft(8) for details.
- add egress support for 'list hooks'.

  # nft list hooks netdev device eth0
  family netdev {
          hook ingress device eth0 {
                   0000000000 chain inet ingress in_public [nf_tables]
                   0000000000 chain netdev ingress in_public [nf_tables]
          }
          hook egress device eth0 {
                   0000000000 chain netdev ingress out_public [nf_tables]
          }
  }

- fix listing inconsistencies in "nft list hooks".
- "nft list hooks netdev" now iterates all interfaces and then list all of them.
- document "nft list hooks" command, see man nft(8).

... including manpage updates too and tests enhancements.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

[ NOTE: We have switched to .tar.xz files for releases. ]

To build the code, libnftnl >= 1.2.8 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--va7Ua4rSdMdHbrRm
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.1.1.txt"
Content-Transfer-Encoding: 8bit

Florian Westphal (16):
      src: remove decnet support
      tests: shell: move flowtable with bogus priority to correct location
      tests: shell: resolve check-tree.sh errors
      optimize: compare meta inner_desc pointers too
      src: mnl: clean up hook listing code
      src: mnl: make family specification more strict when listing
      src: drop obsolete hook argument form hook dump functions
      src: add egress support for 'list hooks'
      doc: add documentation about list hooks feature
      src: mnl: prepare for listing all device netdev device hooks
      src: mnl: always dump all netdev hooks if no interface name was given
      tests: shell: add test for kernel stack recursion bug
      tests: shell: extend vmap test with updates
      tests: shell: add test case for timeout updates
      tests: py: fix up udp csum fixup output
      tests: shell: more randomization for timeout parameter

Pablo Neira Ayuso (34):
      optimize: skip variables in nat statements
      Revert "cache: recycle existing cache with incremental updates"
      tests: shell: skip vlan mangling testcase if egress is not support
      datatype: reject rate in quota statement
      datatype: improve error reporting when time unit is not correct
      tests: shell: add a few tests for nft -i
      cache: rule by index requires full cache
      cache: populate chains on demand from error path
      cache: populate objects on demand from error path
      cache: populate flowtables on demand from error path
      cache: do not fetch set inconditionally on delete
      parser_bison: allow 0 burst in limit rate byte mode
      src: remove DTYPE_F_PREFIX
      datatype: replace DTYPE_F_ALLOC by bitfield
      parser_json: fix handle memleak from error path
      cache: reset filter for each command
      cache: accumulate flags in batch
      cache: add filtering support for objects
      cache: only dump rules for the given table
      cache: consolidate reset command
      tests: shell: cover anonymous set with reset command
      tests: shell: cover reset command with counter and quota
      cache: assert filter when calling nft_cache_evaluate()
      cache: clean up evaluate_cache_del()
      cache: remove full cache requirement when echo flag is set on
      cache: relax requirement for replace rule command
      cache: position does not require full cache
      tests: shell: extend coverage for meta l4proto netdev/egress matching
      tests: shell: stabilize packetpath/payload
      proto: use NFT_PAYLOAD_L4CSUM_PSEUDOHDR flag to mangle UDP checksum
      src: support for timeout never in elements
      doc: tproxy is non-terminal in nftables
      cache: initialize filter when fetching implicit chains
      build: Bump version to 1.1.1

Phil Sutter (2):
      tests: shell: Extend table persist flag test a bit
      libnftables: Zero ctx->vars after freeing it

Sebastian Walz (sivizius) (3):
      parser_json: release buffer returned by json_dumps
      parser_json: fix several expression memleaks from error path
      parser_json: fix crash in json_parse_set_stmt_list

谢致邦 (XIE Zhibang) (1):
      doc: update outdated route and pkttype info


--va7Ua4rSdMdHbrRm--
