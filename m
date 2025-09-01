Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0966122172E;
	Mon,  1 Sep 2025 23:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756767925; cv=none; b=NEvGvNhg8P7ScG3dovgcg3Homd3h+mrt1c0puF2/+AFR5uubcmjqUyz0X3yLXbC9O0GmmZCscUMa6ZqP5ouTmWaipsxNnIfQ/slGI24+s9vYZCoUiSeT3EMnuAZlH0QkYfgCI7gXzarkg42ba10w9CiYteGkLxH+BIT0ROLU/7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756767925; c=relaxed/simple;
	bh=jMrxSG6YjV05PFEkVHfrnkGHoy5fn1qlIIScXNBzjqc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=E1Gg2Rt5bhPvoUchQprRYZ1Wj6MbIR/m3QC5G7YWOztLC44IoqqC1IzBdA1E76fbh9HRqiZirY/+znV7Mr/UKCzAQ3AFmKvNS2Yi9LETw4V9l1QzvU6VhZGuHqGExgnyhvsjfcqj84xR9gQbgV7glM61Voth4m8Wrd3lhRzbkjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=oHvDWVOz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lqcyZRhL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="oHvDWVOz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lqcyZRhL"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8BB4460705; Tue,  2 Sep 2025 01:05:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756767919;
	bh=LGOTBFLTQ64xHq3BeJB0z2EMAd97rWZ4DC2vyliQ4J4=;
	h=Date:From:To:Cc:Subject:From;
	b=oHvDWVOzXG8Y0LgRgp8nYBq2eF+ngFa0Qej2gRG82Cu6QnMeZfjOf7JxI3fkelMwA
	 5m3SqNnL7JtwwUEl6xZcl1F6RLmGdr9cUYQhBZHrYbTKWq20Jywb/fe/mjOuezt/9T
	 RKM7ldAnMJgVfDQ+/epg5PQjcaKYs4zLfBPm9/me9cS4lLdxTpPaw8xw1F452eWYrI
	 Y1Adpu3qKRO7PTbNfKFPEEzyumzXuXwnyAfhn0cfdGYzoY+totzBA2nLjWeiC1Kguu
	 99Ds9s868L43AyyOjSnC0WngBqIyhFXxi/2wx6dWSUyzvARlwJV9Ku7IeiZLulNSEH
	 Okpll1a/1LS6A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 38DE8606E7;
	Tue,  2 Sep 2025 01:05:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756767913;
	bh=LGOTBFLTQ64xHq3BeJB0z2EMAd97rWZ4DC2vyliQ4J4=;
	h=Date:From:To:Cc:Subject:From;
	b=lqcyZRhLwXdbs/Rlny5l43orPnTiaVXBrmkk1d6d9Khts8FBjqxbLelHIBu3NFRlc
	 OtqskVH9/ngjo3C+s4JcjaIziNQdaS+AUD5FN//S3VmPNwN8mLRVHWObBgKjafgPwC
	 qOaa+nAse3kXw23TnTX01esy/V4SpmtlGhIlflJeyPQbgXhCj3MrPDaoyo/joa9IhL
	 H3Bvvkk9T+oxa7cfDFceJooFzakPCwtILYfeHMOq6zG6laYfiuxzr5mCDweyDZ55cA
	 MjyPeMS358QbdwwDyA0OA1FwZ5oXHflwaWCZHAYql6mhLIrFErkKrUapdhE9meOhuU
	 zi7PZMRp72Awg==
Date: Tue, 2 Sep 2025 01:05:10 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] nftables 1.0.6.1 (stable) release
Message-ID: <aLYmiX_VmROr6x1o@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="aYQ5M71G5vH4bx82"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


--aYQ5M71G5vH4bx82
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.6.1

This is a -stable release containing 412 backported fixes available up to
the nftables 1.1.4 release (from 2025-Aug-06).

This release is paired with libnftnl >= 1.2.4, and Linux kernel 6.1 -stable.

This includes:

- general fixes, mostly targeted at the evaluation phase.

- backported speed up for incremental updates and listing by relaxing
  internal object cache requirements.

- -o/--optimize fixes.

- json support fixes.

- list hooks command fixes.

- Print fallback for unsupported expressions coming from iptables-nft.

    | # iptables-nft -A FORWARD -p tcp -m osf --genre linux
    | # nft list ruleset | nft -f -
    | # Warning: table ip filter is managed by iptables-nft, do not touch!
    | /dev/stdin:4:29-31: Error: syntax error, unexpected osf, expecting string
    |               meta l4proto tcp xt match osf counter packets 0 bytes 0
    |                                         ^^^

- CPython bindings are available for nftables under the py/ folder.
  They can be installed using pip:

        python -m pip install py/

  A legacy setup.py script can also be used:

        ( cd py && python setup.py install )

... among many others.

This -stable release is funded through the NGI0 Entrust established
by NLnet (https://nlnet.nl) with support from the European Commission's
Next Generation Internet programme.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

To build the code, libnftnl >= 1.2.4 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of regressions in this release, file them via:

* https://bugzilla.netfilter.org

... else report them to netfilter-devel@vger.kernel.org.

Happy firewalling.

--aYQ5M71G5vH4bx82
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.6.1.txt"
Content-Transfer-Encoding: 8bit

Eric Long (1):
      libnftables-json: fix raw payload expression documentation

Florian Westphal (139):
      evaluate: set eval ctx for add/update statements with integer constants
      netlink: restore typeof interval map data type
      cache: include set elements in "nft set list"
      evaluate: do not abort when prefix map has non-map element
      parser: don't assert on scope underflows
      parser: reject zero-length interface names
      parser: reject zero-length interface names in flowtables
      netlink: delinearize: copy set keytype if needed
      tests: fix inet nat prio tests
      parser: allow ct timeouts to use time_spec values
      parser: permit gc-interval in map declarations
      evaluate: fix get element for concatenated set
      libnftables: refuse to open onput files other than named pipes or regular files
      scanner: restrict include directive to regular files
      tests: never merge across non-expression statements redux
      rule: never merge across non-expression statements
      tests: never merge across non-expression statements redux 2
      meta: fix hour decoding when timezone offset is negative
      evaluate: fix rule replacement with anon sets
      evaluate: guard against NULL basetype
      evaluate: error out if basetypes are different
      evaluate: reject attempt to update a set
      evaluate: catch implicit map expressions without known datatype
      evaluate: fix double free on dtype release
      parser: tcpopt: fix tcp option parsing with NUM + length field
      evaluate: validate chain max length
      parser_bison: fix objref statement corruption
      parser_bison: fix memleak in meta set error handling
      meta: don't crash if meta key isn't known
      netlink: add and use nft_data_memcpy helper
      evaluate: fix bogus assertion failure with boolean datatype
      evaluate: prevent assert when evaluating very large shift values
      evaluate: turn assert into real error check
      parser_bison: make sure obj_free releases timeout policies
      parser_bison: fix ct scope underflow if ct helper section is duplicated
      parser_bison: fix memory leaks on hookspec error processing
      evaluate: stmt_nat: set reference must point to a map
      evaluate: fix gmp assertion with too-large reject code
      netlink: don't crash if prefix for < byte is requested
      evaluate: exthdr: statement arg must be not be a range
      src: reject large raw payload and concat expressions
      netlink: fix stack buffer overflow with sub-reg sized prefixes
      evaluate: fix stack overflow with huge priority string
      tcpopt: don't create exthdr expression without datatype
      intervals: BUG on prefix expressions without value
      parser_bison: error out on duplicated type/typeof/element keywords
      evaluate: don't crash if object map does not refer to a value
      netlink: fix stack overflow due to erroneous rounding
      datatype: do not assert when value exceeds expected width
      evaluate: error out when expression has no datatype
      evaluate: tproxy: move range error checks after arg evaluation
      payload: only assert if l2 header base has no length
      parser: reject raw payload expressions with 0 length
      evaluate: error out when store needs more than one 128bit register of align fixup
      rule: fix sym refcount assertion
      evaluate: don't assert on net/transport header conflict
      netlink_delinearize: move concat and value postprocessing to helpers
      src: permit use of constant values in set lookup keys
      parser_json: allow 0 offsets again
      parser: compact interval typeof rules
      parser: compact type/typeof set rules
      parser: allow typeof in objref maps
      netlink: allow typeof keywords with objref maps during listing
      parser: deduplicate map with data interval
      parser: allow to define maps that contain ct helpers
      src: do not merge a set with a erroneous one
      rule: do not crash if to-be-printed flowtable lacks priority
      src: allow to map key to nfqueue number
      rule: make cmd_free(NULL) valid
      netlink_delinarize: fix bogus munging of mask value
      src: add and use payload_expr_trim_force
      payload: return early if dependency is not a payload expression
      segtree: fix string data initialisation
      expression: tolerate named set protocol dependency
      json: prevent null deref if chain->policy is not set
      tests: shell: move flowtable with bogus priority to correct location
      evaluate: don't allow nat map with specified protocol
      netlink: fix stack buffer overrun when emitting ranged expressions
      json: make sure timeout list is initialised
      parser_bison: ensure all timeout policy names are released
      src: do not allow to chain more than 16 binops
      evaluate: don't allow merging interval set/map with non-interval one
      evaluate: move interval flag compat check after set key evaluation
      parser_bison: reject non-serializeable typeof expressions
      rule: return error if table does not exist
      evaluate: fix assertion failure with malformed map definitions
      evaluate: reject sets with no key
      evaluate: don't update cache for anonymous chains
      meta: fix tc classid parsing out-of-bounds access
      json: work around fuzzer-induced assert crashes
      json: fix error propagation when parsing binop lhs/rhs
      expression: don't try to import empty string
      evaluate: fix crash when generating reject statement error
      parser_json: only allow concatenations with 2 or more expressions
      evaluate: compact STMT_F_STATEFUL checks
      evaluate: only allow stateful statements in set and map definitions
      evalute: make vlan pcp updates work
      tests: py: remove huge-limit test cases
      tests: py: add missing json.output data
      tests: py: add payload merging test cases
      tests: py: fix up udp csum fixup output
      tests: py: extend raw payload match tests
      payload: don't kill dependency for proto_th
      netlink_delinerize: add more restrictions on meta nfproto removal
      tests: py: fix json single-flag output for fib & synproxy
      json: return error if table does not exist
      ct timeout: fix 'list object x' vs. 'list objects in table' confusion
      ct expectation: fix 'list object x' vs. 'list objects in table' confusion
      json: don't BUG when asked to list synproxies
      evaluate: bail out if ct saddr/daddr dependency cannot be inserted
      src: remove bogus empty file
      src: netlink: fix crash when ops doesn't support udata
      doc: add nat examples
      mnl: catch bogus expressions before crashing
      evaluate: don't BUG on unexpected base datatype
      evaluate: rename recursion counter to recursion.binop
      evaluate: restrict allowed subtypes of concatenations
      src: BASECHAIN flag no longer implies presence of priority expression
      json: reject too long interface names
      evaluate: make sure chain jump name comes with a null byte
      evaluate: avoid double-free on error handling of bogus objref maps
      evaluate: check that set type is identical before merging
      evaluate: prevent merge of sets with incompatible keys
      evaluate: check element key vs. set definition
      tests: bogons: fix missing file name when logging
      evaluate: fix crash with invalid elements in set
      json: BASECHAIN flag no longer implies presence of priority expression
      evaluate: maps: check element data mapping matches set data definition
      parser_json: reject non-concat expression
      parser_json: fix assert due to empty interface name
      parser_bison: fix memory leak when parsing flowtable hook declaration
      rule: allow src/dstnat prios in input and output
      src: remove utf-8 character in printf lines
      src: remove decnet support
      src: mnl: clean up hook listing code
      src: mnl: make family specification more strict when listing
      src: drop obsolete hook argument form hook dump functions
      src: mnl: prepare for listing all device netdev device hooks
      src: mnl: always dump all netdev hooks if no interface name was given

Jeremy Sowden (10):
      scanner: treat invalid octal strings as strings
      evaluate: insert byte-order conversions for expressions between 9 and 15 bits
      netlink_delinearize: add postprocessing for payload binops
      evaluate: don't eval unary arguments
      netlink_delinearize: correct type and byte-order of shifts
      evaluate: handle invalid mapping expressions in stateful object statements gracefully.
      evaluate: add support for variables in map expressions
      py: move package source into src directory
      py: use setup.cfg to configure setuptools
      py: add pyproject.toml to support PEP-517-compatible build-systems

Jose M. Guisado Gomez (1):
      py: replace distutils with setuptools

Maks Mishin (1):
      evaluate: Fix incorrect checking the `base` variable in case of IPV6

Pablo Neira Ayuso (177):
      evaluate: fix shift exponent underflow in concatenation evaluation
      ct: use inet_service_type for proto-src and proto-dst
      intervals: restrict check missing elements fix to sets with no auto-merge
      optimize: wrap code to build concatenation in helper function
      optimize: fix incorrect expansion into concatenation with verdict map
      rule: add helper function to expand chain rules into commands
      optimize: select merge criteria based on candidates rules
      rule: expand standalone chain that contains rules
      optimize: ignore existing nat mapping
      optimize: infer family for nat mapping
      evaluate: print error on missing family in nat statement
      evaluate: infer family from mapping
      evaluate: expand value to range when nat mapping contains intervals
      src: expand table command before evaluation
      tests: shell: cover rule insertion by index
      parser_bison: allow to use quota in sets
      intervals: use expression location when translating to intervals
      optimize: assert nat type on nat statement helper
      optimize: support for redirect and masquerade
      evaluate: bogus missing transport protocol
      netlink_delinearize: do not reset protocol context for nat protocol expression
      evaluate: allow stateful statements with anonymous verdict maps
      evaluate: skip optimization if anonymous set uses stateful statement
      optimize: do not remove counter in verdict maps
      evaluate: set NFT_SET_EVAL flag if dynamic set already exists
      expression: define .clone for catchall set element
      libnftables: Drop cache in -c/--check mode
      evaluate: do not remove anonymous set with protocol flags and single element
      evaluate: revisit anonymous set with single element optimization
      evaluate: expand sets and maps before evaluation
      limit: display default burst when listing ruleset
      datatype: initialize TYPE_CT_LABEL slot in datatype array
      datatype: initialize TYPE_CT_EVENTBIT slot in datatype array
      tests: py: add map support
      json: expose dynamic flag
      netlink_linearize: skip set element expression in map statement key
      json: add missing map statement stub
      evaluate: validate maximum log statement prefix length
      src: expand create commands
      evaluate: clone unary expression datatype to deal with dynamic datatype
      json: deal appropriately with multidevice in chain
      evaluate: handle invalid mapping expressions gracefully
      monitor: add support for concatenated set ranges
      evaluate: reject set definition with no key
      tests: shell: use /bin/bash in sets/elem_opts_compat_0
      evaluate: support shifts larger than the width of the left operand
      evaluate: relax type-checking for integer arguments in mark statements
      evaluate: set up integer type to shift expression
      evaluate: honor statement length in bitwise evaluation
      netlink_delinerize: incorrect byteorder in mark statement listing
      payload: set byteorder when completing expression
      evaluate: bail out if new flowtable does not specify hook and priority
      json: allow to specify comment on table
      json: allow to specify comment on chain
      evaluate: perform mark datatype compatibility check from maps
      evaluate: reject set in concatenation
      evaluate: fix memleak in prefix evaluation with wildcard interface name
      evaluate: place byteorder conversion before rshift in payload statement
      evaluate: reset statement length context only for set mappings
      evaluate: place byteorder conversion before rshift in payload expressions
      evaluate: bogus error when adding devices to flowtable
      doc: incorrect datatype description for icmpv6_type and icmpvx_code
      evaluate: add missing range checks for dup,fwd and payload statements
      evaluate: skip anonymous set optimization for concatenations
      evaluate: do not fetch next expression on runaway number of concatenation components
      evaluate: bail out if anonymous concat set defines a non concat expression
      evaluate: release key expression in error path of implicit map with unknown datatype
      evaluate: release mpz type in expr_evaluate_list() error path
      datatype: display 0s time datatype
      evaluate: skip byteorder conversion for selector smaller than 2 bytes
      netlink_linearize: add assertion to catch for buggy byteorder
      evaluate: permit use of host-endian constant values in set lookup keys
      expression: missing line in describe command with invalid expression
      proto: use hexadecimal to display ip frag-off field
      rule: fix ASAN errors in chain priority to textual names
      parser: allow to define maps that contain timeouts and expectations
      netlink_delinearize: restore binop syntax when listing ruleset for flags
      netlink_delinearize: reverse cross-day meta hour range
      evaluate: display "Range negative size" error
      datatype: use DTYPE_F_PREFIX only for IP address datatype
      netlink_delinearize: unused code in reverse cross-day meta hour range
      src: disentangle ICMP code types
      evaluate: bogus protocol conflicts in vlan with implicit dependencies
      cache: check for NFT_CACHE_REFRESH in current requested cache too
      scanner: inet_pton() allows for broader IPv4-Mapped IPv6 addresses
      monitor: too large shift exponent displaying payload expression
      cmd: skip variable set elements when collapsing commands
      evaluate: set on expr->len for catchall set elements
      segtree: set on EXPR_F_KERNEL flag for catchall elements in the cache
      intervals: fix element deletions with maps
      parser_bison: recursive table declaration in deprecated meter statement
      optimize: clone counter before insertion into set element
      parser_json: use stdin buffer if available
      libnftables: skip useable checks for /dev/stdin
      optimize: skip variables in nat statements
      datatype: reject rate in quota statement
      datatype: improve error reporting when time unit is not correct
      cache: rule by index requires full cache
      src: improve error reporting for unsupported chain type
      evaluate: honor statement length in integer evaluation
      netlink_linearize: use div_round_up in byteorder length
      meta: stash context statement length when generating payload/meta dependency
      cmd: provide better hint if chain is already declared with different type/hook/priority
      cache: populate chains on demand from error path
      cache: populate objects on demand from error path
      cache: populate flowtables on demand from error path
      cache: do not fetch set inconditionally on delete
      parser_bison: allow 0 burst in limit rate byte mode
      parser_json: fix handle memleak from error path
      cache: reset filter for each command
      cache: accumulate flags in batch
      cache: only dump rules for the given table
      cache: assert filter when calling nft_cache_evaluate()
      cache: clean up evaluate_cache_del()
      cache: remove full cache requirement when echo flag is set on
      cache: relax requirement for replace rule command
      cache: position does not require full cache
      proto: use NFT_PAYLOAD_L4CSUM_PSEUDOHDR flag to mangle UDP checksum
      cache: initialize filter when fetching implicit chains
      optimize: compare expression length
      evaluate: reset statement length context before evaluating statement
      intervals: set internal element location with the deletion trigger
      scanner: better error reporting for CRLF line terminators
      exthdr: incomplete type 2 routing header definition
      datatype: clamp boolean value to 0 and 1
      ipopt: use ipv4 address datatype for address field in ip options
      parser_bison: turn redundant ip option type field match into boolean
      evaluate: auto-merge is only available for singleton interval sets
      evaluate: optimize zero length range
      evaluate: release existing datatype when evaluating unary expression
      segtree: incomplete output in get element command with maps
      netlink: bogus concatenated set ranges with netlink message overrun
      optimize: incorrect comparison for reject statement
      optimize: compact bitmask matching in set/map
      optimize: expand expression list when merging into concatenation
      optimize: invalidate merge in case of duplicated key in set/map
      parser_bison: add selector_expr rule to restrict typeof_expr
      json: disallow empty concatenation
      Backport nftables tests/shell from 2a38f458f12b
      Revert "json: Print single set flag as non-array"
      Revert "src: print set element with multi-word description in single one line"
      Revert "evaluate: allow to re-use existing metered set"
      Revert mptcp tests for sets/typeof_sets_0
      Partial revert in testcase/sets/set_stmt to remove last statement coverage
      Revert "evaluate: translate meter into dynamic set"
      Partial revert "tests: py: move meter tests to tests/shell"
      Revert "tests: shell: move flowtable with bogus priority to correct location"
      Amend "tests: shell: Fix ifname_based_hooks feature check"
      tests: py: extend ip frag-off coverage
      tests: py: debloat frag.t.payload.netdev
      tests: py: missing json output in never merge across non-expression statements
      tests: py: missing json output in meta.t with vlan mapping
      tests: py: complete icmp and icmpv6 update
      tests: py: drop redundant JSON outputs
      Revert "tests: py: fix json single-flag output for fib & synproxy"
      tests: py: fix WARNING with JSON
      evaluate: simplify payload statement evaluation for bitfields
      evaluate: reject unsupported expressions in payload statement for bitfields
      parser_json: reject empty jump/goto chain
      parser_json: allow statement stateful statement only in set elements
      parser_json: bail out on malformed statement in set
      mnl: flowtable support for extended netlink error reporting
      mnl: handle singleton element in netdevice set
      rule: skip fuzzy lookup if object name is not available
      cache: assert name is non-nul when looking up
      parser_bison: allow delete command with map via handle
      rule: print chain and flowtable devices in quotes
      evaluate: validate set expression type before accessing flags
      tests: monitor: enclose device names in quotes
      segtree: incorrect type when aggregating concatenated set ranges
      src: Add GPLv2+ header to .c files of recent creation
      mnl: set SO_SNDBUF before SO_SNDBUFFORCE
      update INSTALL file
      py: remove setup.py integration with autotools
      INSTALL: provide examples to install python bindings
      cache: chain listing implicitly sets on terse option
      build: Bump version to 1.0.6.1

Phil Sutter (59):
      optimize: Clarify chain_optimize() array allocations
      netlink: Fix for potential NULL-pointer deref
      meta: parse_iso_date() returns boolean
      mnl: dump_nf_hooks() leaks memory in error path
      optimize: Do not return garbage from stack
      netlink_delinearize: Sanitize concat data element decoding
      xt: Fix fallback printing for extensions matching keywords
      xt: Fix translation error path
      tests: shell: Fix for unstable sets/0043concatenated_ranges_0
      tests: shell: Stabilize sets/0043concatenated_ranges_0 test
      evaluate: Drop dead code from expr_evaluate_mapping()
      tests: monitor: Fix monitor JSON output for insert command
      tests: monitor: Fix time format in ct timeout test
      tests: monitor: Fix for wrong syntax in set-interval.t
      tests: monitor: Fix for wrong ordering in expected JSON output
      parser_json: Catch wrong "reset" payload
      parser_json: Fix typo in json_parse_cmd_add_object()
      parser_json: Proper ct expectation attribute parsing
      parser_json: Fix flowtable prio value parsing
      parser_json: Fix limit object burst value parsing
      parser_json: Fix synproxy object mss/wscale parsing
      parser_json: Wrong check in json_parse_ct_timeout_policy()
      parser_json: Catch nonsense ops in match statement
      parser_json: Default meter size to zero
      parser_bison: Fix for broken compatibility with older dumps
      tproxy: Drop artificial port printing restriction
      json: Support sets' auto-merge option
      cache: Optimize caching for 'list tables' command
      cache: Always set NFT_CACHE_TERSE for list cmd with --terse
      json: Order output like nft_cmd_expand()
      json: Support maps with concatenated data
      parser: json: Support for synproxy objects
      json: Accept more than two operands in binary expressions
      mergesort: Avoid accidental set element reordering
      json: Fix for memleak in __binop_expr_json
      doc: nft.8: Fix markup in ct expectation synopsis
      doc: nft.8: Highlight "hook" in flowtable description
      libnftables: Zero ctx->vars after freeing it
      json: Support typeof in set and map types
      netlink: Do not allocate a bogus flowtable priority expr
      netlink: Fix for potential crash parsing a flowtable
      netlink: Avoid crash upon missing NFTNL_OBJ_CT_TIMEOUT_ARRAY attribute
      tests: py: Document JSON mode in README
      tests: py: Fix some JSON equivalents
      tests: py: Warn if recorded JSON output matches the input
      tests: py: Drop needless recorded JSON outputs
      tests: py: Fix for storing payload into missing file
      tests: py: Properly fix JSON equivalents for netdev/reject.t
      doc: Fix typo in nat statement 'prefix' description
      netlink: Avoid potential NULL-ptr deref parsing set elem expressions
      netlink: Catch unknown types when deserializing objects
      netlink_delinearize: Replace some BUG()s by error messages
      netlink: Pass netlink_ctx to netlink_delinearize_setelem()
      netlink: Keep going after set element parsing failures
      cache: Tolerate object deserialization failures
      monitor: Recognize flowtable add/del events
      json: Dump flowtable hook spec only if present
      doc: nft.8: Minor NAT STATEMENTS section review
      src: netlink: netlink_delinearize_table() may return NULL

Quan Tian (1):
      doc: clarify reject is supported at prerouting stage

Sam James (1):
      Makefile.am: don't silence -Wimplicit-function-declaration

Sebastian Walz (sivizius) (3):
      parser_json: release buffer returned by json_dumps
      parser_json: fix several expression memleaks from error path
      parser_json: fix crash in json_parse_set_stmt_list

Son Dinh (1):
      dynset: avoid errouneous assert with ipv6 concat data

Sriram Rajagopalan (1):
      nftables: do mot merge payloads on negation

Thomas Haller (13):
      evaluate: fix check for truncation in stmt_evaluate_log_prefix()
      include: drop "format" attribute from nft_gmp_print()
      datatype: fix leak and cleanup reference counting for struct datatype
      netlink: handle invalid etype in set_make_key()
      parser_bison: fix length check for ifname in ifname_expr_alloc()
      netlink: fix buffer size for user data in netlink_delinearize_chain()
      json: fix use after free in table_flags_json()
      netlink_linearize: avoid strict-overflow warning in netlink_gen_bitwise()
      expression: cleanup expr_ops_by_type() and handle u32 input
      py: fix exception during cleanup of half-initialized Nftables
      json: use strtok_r() instead of strtok()
      rule: fix "const static" declaration
      mergesort: avoid cloning value in expr_msort_cmp()

Xiao Liang (1):
      fib: Change data type of fib oifname to "ifname"

Yi Chen (1):
      test: shell: Don't use system nft binary

谢致邦 (XIE Zhibang) (2):
      evaluate: fix check for unknown in cmd_op_to_name
      doc: update outdated route and pkttype info


--aYQ5M71G5vH4bx82--
