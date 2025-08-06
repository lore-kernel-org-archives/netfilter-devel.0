Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD3C4C6C;
	Wed,  6 Aug 2025 12:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754482625; cv=none; b=OZG4WMgPEWcQ1Z4B7fwl5XY+gOpmhNmWkdNkJeed60Yx0xiaAdsMQV++6ojKp7PuAM5UHBpojlijjM0rkFT3kTyCqZNDQkLSwikXo/fr01AcOpnRFe6NtFN/Bba3Sntrl8MAe6rkvVzHtjIPJt7bsDy/XcQh3S1wNFCA++FujKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754482625; c=relaxed/simple;
	bh=dSOKqDDzuevLp1W0TODEwCEq8lthGjuFrCrxcLGoRGc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YvruZ70BOzBLMyZwpXFtPKOMqmrcnv3AO6FNC5+IC8ltP7I5BiH+Te4chM6v7lKrO92tD/d6yyLJ6a91d76oTxlNzOpom7QDifaMVEJ6zu6+HG8bhulN5O4gPAivySTkdOEh1GmZYXIDiGYn+nyMR2L3WtzJLd/JlbgT1k2kKxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uTChAu2A; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f263jrA3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uTChAu2A";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f263jrA3"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 302FD606F4; Wed,  6 Aug 2025 14:17:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754482621;
	bh=dq+TO8bD2wG8lnphJhK28CSdTd2AARlYcVvzVKJKCPg=;
	h=Date:From:To:Cc:Subject:From;
	b=uTChAu2AzeQ9sLn+wq6NCCCy5GRs2yq+MVnO14TJJz/Nn2rcbG03kJUpHfxt+4ni0
	 CB5SPxf08jY1IkJXC8CjH79tvobulvlT74nhyaxHJZh/BVhBX0pyAzE6g9ruPPwead
	 22/QsED0M5IICEY9i7rQ37x5P+xGBElVW6VyVcCBs2+u8Bl0mn1C/CXkKxES2v/bpS
	 N/S7V/SMRYEg3DTA1U7akg910c6VXmMcDvCSkAviGL+BFcQUtWYfIoEmy4C91B/zJe
	 IDp4hDefpiM4uKYTfIctHQksmcO/CMi/F0Lg2/OL9nPntRtA1ZZGa7USqzm080QnJG
	 Y0Dy9ECQZ0lOg==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1E544606F4;
	Wed,  6 Aug 2025 14:16:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1754482618;
	bh=dq+TO8bD2wG8lnphJhK28CSdTd2AARlYcVvzVKJKCPg=;
	h=Date:From:To:Cc:Subject:From;
	b=f263jrA3kkB3L+Shxl0jyQeh6nxhqDFN3e5j2/24EKYM1S/NJ8y6AA47i17mtg2L2
	 AumaEnUeyVFc7nQHumvjUB8U9p5CuxNu8lIFyL6A/a8Z+Jav5xA7jouXK1FWoEbPPn
	 re7mUpGrUi5avwXAL9+MuRHy0Xu3mBoW7LRWeBp2F1jaBqT2dVU8Ktajeyr3jBaKZi
	 zZXvPQoEflFuB3yZMS7VvEeCwtB7VRUlupF/d3J9xkFJQDUXcazST8natpbMAxLly4
	 GRD/jnlNzy7lTC8kbVzfxLAaXY28rEiXmboQTG6NiG+9YQy4WWNHwY+BWOeAuVoQ69
	 q/g8SENko6AUg==
Date: Wed, 6 Aug 2025 14:16:55 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] nftables 1.1.4 release
Message-ID: <aJNHt1OW7w6SBmsv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pE61WAFevUauYNJP"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


--pE61WAFevUauYNJP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.1.4

This release contains enhancements and fixes:

- Add conntrack information to monitor trace command.

    Example output ("conntrack: " lines are new):

    trace id 32 t PRE_RAW packet: iif "enp0s3" ether saddr [..]
    trace id 32 t PRE_RAW rule tcp flags syn meta nftrace set 1 (verdict continue)
    trace id 32 t PRE_RAW policy accept
    trace id 32 t PRE_MANGLE conntrack: ct direction original ct state new ct id 2641368242
    trace id 32 t PRE_MANGLE packet: iif "enp0s3" ether saddr [..]
    trace id 32 t ct_new_pre rule jump rpfilter (verdict jump rpfilter)
    trace id 32 t PRE_MANGLE policy accept
    trace id 32 t INPUT conntrack: ct direction original ct state new ct status dnat-done ct id 2641368242
    trace id 32 t INPUT packet: iif "enp0s3" [..]
    trace id 32 t public_in rule tcp dport 443 accept (verdict accept)

- Add a 'check' fib result to check for routes:

     ... fib daddr . iif check exists
     ... fib daddr . iif check missing

  Allow to use it in maps:

     ... fib daddr check vmap { missing : drop, exists : accept }

  and set statements too:

     ... meta mark set fib daddr check . ct mark map { exists . 0x00000000 : 0x0000000a, missing . 0x00000001 : 0x0000000b }

- Better error reporting with re-declarations set/map with different types:

     Error: Cannot merge set with existing datamap of same name
      set z {
          ^

- Reduce memory consumption in sets consisting of a concatenation of intervals:

     table inet x {
            set y {
                    typeof ip saddr . tcp dport
                    flags interval
                    elements = {
                            0.1.2.0-0.1.2.240 . 0-1,
                            ...
                    }
            }
     }

    Using the set that appears in this example above, with 100k elements.

    Before: 123.80 Mbytes
    After:   80.19 Mbytes (-35.23%)

- Reduce memory consumption in maps with intervals:

      table inet x {
             map y {
                        typeof ip saddr : ip saddr
                        flags interval
                        elements = {
                            1.0.2.0-1.0.2.240 : 1.0.2.10,
                            ...
             }
      }

    Using the set that appreas in this example above, with 100k elements.

    Before: 74.36 Mbytes
    After: 62.39 Mbytes (-16.10%)

- Restore meta hour matching on ranges spanning date boundaries, eg.

    ...meta hour "21:00"-"02:00"

  N.B: This broke in the previous nftables 1.1.3 release.

- Display number of set elements in listing:

    table ip t {
       set s {
           type ipv4_addr
           size 65535      # count 1
           flags dynamic
           counter
           elements = { 1.1.1.1 counter packets 1 bytes 11 }
       }

- Allow to delete map via handle

    delete map t handle 4000

  N.B: In previous version, this is already possible for sets, this is
       fixing an inconsistency.

- Harden json parser detected via fuzzy testing.

- Simplify json flag field representation when single flags is used,
  so instead:

        "flags": [
          "interval"
        ],

  use:

        "flags": "interval",

- Quote device name in basechain and flowtable declarations, eg.

 table netdev filter2 {
        chain Main_Ingress2 {
               type filter hook ingress devices = { "eth0", "lo" } priority -500; policy accept;
        }
 }

... as well as man nft(8) documentation updates, and improvements in
tests/py and tests/shell for better coverage.

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

--pE61WAFevUauYNJP
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.1.4.txt"
Content-Transfer-Encoding: 8bit

Florian Westphal (43):
      src: remove bogus empty file
      src: netlink: fix crash when ops doesn't support udata
      tests: py: fix json single-flag output for fib & synproxy
      json: prevent null deref if chain->policy is not set
      json: work around fuzzer-induced assert crashes
      tests: helpers: suppress mount error messages
      mnl: catch bogus expressions before crashing
      evaluate: don't BUG on unexpected base datatype
      test: shell: nat_ftp: test files must be world-readable
      evaluate: rename recursion counter to recursion.binop
      evaluate: restrict allowed subtypes of concatenations
      src: BASECHAIN flag no longer implies presence of priority expression
      tests/py: prepare for set debug change
      debug: include kernel set information on cache fill
      src: print count variable in normal set listings
      tests: shell: add feature check for count output change
      tests/py: clean up set backend support fallout
      json: reject too long interface names
      evaluate: make sure chain jump name comes with a null byte
      evaluate: avoid double-free on error handling of bogus objref maps
      evaluate: check that set type is identical before merging
      evaluate: prevent merge of sets with incompatible keys
      tests: shell: add bitwise json dump files
      tests: shell: add optimize dump files
      tests: shell: add sets dumps
      tests: shell: add nft-i dumps
      tests: shell: add maps dumps
      tests: shell: add include dumps
      tests: shell: add a few nodump files
      tests: shell: move bogons to correct directory
      tests: shell: add json dump files
      Merge branch 'tests_shell_check_tree_fixes'
      src: split monitor trace code into new trace.c
      src: add conntrack information to trace monitor mode
      evaluate: check element key vs. set definition
      doc: expand on gc-interval, size and a few other set/map keywords
      tests: bogons: fix missing file name when logging
      evaluate: fix crash with invalid elements in set
      json: BASECHAIN flag no longer implies presence of priority expression
      evaluate: maps: check element data mapping matches set data definition
      parser_json: reject non-concat expression
      parser_json: fix assert due to empty interface name
      parser_bison: fix memory leak when parsing flowtable hook declaration

Michal Koutný (1):
      doc: Clarify cgroup meta variable

Pablo Neira Ayuso (21):
      tests: shell: skip egress in netdev chain release path test
      tests: shell: check if kernel supports for cgroupsv2 matching
      tests: shell: check for features not available in 5.4
      rule: skip fuzzy lookup if object name is not available
      cache: assert name is non-nul when looking up
      cache: pass name to cache_add()
      parser_bison: only reset by name is supported by now
      parser_bison: allow delete command with map via handle
      src: use constant range expression for interval+concatenation sets
      expression: constant range is not a singleton
      src: use EXPR_RANGE_VALUE in interval maps
      fib: allow to check if route exists in maps
      fib: allow to use it in set statements
      rule: print chain and flowtable devices in quotes
      evaluate: mappings require set expression
      evaluate: validate set expression type before accessing flags
      src: convert set to list expression
      src: detach set, list and concatenation expression layout
      tests: monitor: enclose device names in quotes
      build: add trace.h to Makefile
      build: Bump version to 1.1.4

Phil Sutter (31):
      tests/shell: Skip netdev_chain_dev_addremove on tainted kernels
      parser_json: Introduce parse_flags_array()
      doc: Fix typo in nat statement 'prefix' description
      json: Print single set flag as non-array
      json: Print single fib flag as non-array
      json: Print single synproxy flags as non-array
      json: Introduce json_add_array_new()
      tests: shell: Add test case for JSON 'flags' arrays
      tests: shell: Include kernel taint value in warning
      netlink: Avoid potential NULL-ptr deref parsing set elem expressions
      netlink: Catch unknown types when deserializing objects
      netlink_delinearize: Replace some BUG()s by error messages
      netlink: Pass netlink_ctx to netlink_delinearize_setelem()
      netlink: Keep going after set element parsing failures
      cache: Tolerate object deserialization failures
      doc: Basic documentation of anonymous chains
      netlink: Fix for potential crash parsing a flowtable
      netlink: Do not allocate a bogus flowtable priority expr
      monitor: Correctly print flowtable updates
      json: Dump flowtable hook spec only if present
      tests: monitor: Fix for single flag array avoidance
      tests: shell: Adjust to ifname-based hooks
      tests: py: Properly fix JSON equivalents for netdev/reject.t
      netlink: Avoid crash upon missing NFTNL_OBJ_CT_TIMEOUT_ARRAY attribute
      tests: shell: Fix ifname_based_hooks feature check
      mnl: Support NFNL_HOOK_TYPE_NFT_FLOWTABLE
      mnl: Call mnl_attr_nest_end() just once
      expression: Introduce is_symbol_value_expr() macro
      parser_json: Parse into symbol range expression if possible
      evaluate: Fix for 'meta hour' ranges spanning date boundaries
      doc: nft.8: Minor NAT STATEMENTS section review

Yi Chen (7):
      tests: shell: Update packetpath/flowtables
      tests: shell: Add a test case for FTP helper combined with NAT.
      test: shell: Don't use system nft binary
      test: shell: Introduce $NFT_TEST_LIBRARY_FILE, helper/lib.sh
      test: shell: Add wait_local_port_listen() helper to lib.sh
      test: shell: Add rate_limit test case for 'limit statement'.
      tests: shell: add type route chain test case

Zhongqiu Duan (2):
      tests: shell: use binary defined by run-tests.sh
      tests: py: re-enables nft-test.py to load the local nftables.py


--pE61WAFevUauYNJP--
