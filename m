Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D0E61FCE;
	Tue, 16 Jul 2024 20:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721162991; cv=none; b=n/4FJlZJkgMWdl0M0/RsrmN5aqzAG+eDfeqiEBypA6d4zXY/3b7jdHRNrs6TvSJKqJm8VewYf58HVHCY5mHtTUwVqMPWz5PY9mjwrLRzDPvc8xT+PckrSW8baieeqhzJQQeuMDUM8uaggtcmRt5AUmJeh9tk+1JsWp5RAj+fYgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721162991; c=relaxed/simple;
	bh=Rgt34UCblaLY/FGFw9Mfb5EUIBdtElLfjQoQLxlAmC8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BVFCphiHlVngo2qo3olYAqSKf8hSsvCr3ADqPawnOmJMvHO86tguVCu9R0BOKOXnoM7YmyF9oLe3uWd5srF4gLaeK0B4+su9PW8I4iRiqazyNKJNBznaq+80mpSmgvJjAgaZw08mIeVa1y7KodaWIJAQ4mBjy0NGOLSUn3wuSGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=58524 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sTp74-008N5R-K8; Tue, 16 Jul 2024 22:49:34 +0200
Date: Tue, 16 Jul 2024 22:49:29 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] nftables 1.1.0 release
Message-ID: <Zpbc2XtUExOCriMP@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5sKcLUB2g6pQQvAa"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Score: -1.5 (-)


--5sKcLUB2g6pQQvAa
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi!

The Netfilter project proudly presents:

        nftables 1.1.0

... after a release cycles of 8 months.

This release contains mostly fixes, listed in no particular order:

- Restore compatibility set element dump with <= 0.9.8

   add element t s { 23 counter packets 10 bytes 20 timeout 10s }
   add element t s { 42 timeout 10s counter packets 10 bytes 20 }

- Disallow ifname less than zero

   meta iifname “”
   Error: Empty string is not allowed

- Do not omit tproxy port for non-value expressions

   tproxy ip to 127.0.0.1:8000
   meta l4proto 6 tproxy ip to 127.0.0.1:symhash mod 2 map { 0 : 8000, 1 : 8010 }

- Listing meta hour with negative time offset

   TZ=UTC-4 nft add rule x y meta hour “22:00”

- Byteorder conversion with {ct,meta} statements

   map mapv6 {
      typeof ip6 dscp : meta mark;
   }
   meta mark set ip6 dscp map @map1

   # resulting bytecode:
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
   [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
   [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
   [ lookup reg 1 set mapv6 dreg 1 ]
   [ meta set mark with reg 1 ]

- Unbreak create set command

   define ip-block-4 = { 1.1.1.1 }
   create set netdev filter ip-block-4-test {
      type ipv4_addr
      flags interval
      auto-merge
      elements = $ip-block-4
   }

- Restore rule replace command

   replace rule ip t1 c1 handle 3 'jhash ip protocol . ip saddr mod 170 vmap { 0-94 : goto wan1, 95-169 : goto wan2, 170-269 }"

- Restore addition of netdevice to flowtable

   create flowtable inet filter f1 { hook ingress priority 0; counter }
   add flowtable inet filter f1 { devices = { dummy1 } ; }

- Byteorder conversion in set with concatenation and ranges

    map ipsec_in {
        typeof ipsec in reqid . iif : verdict
        flags interval
   }

   ipsec in reqid . iif vmap @ipsec_in

   # resulting bytecode:
   [ xfrm load in 0 reqid => reg 1 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ meta load iif => reg 9 ]
   [ byteorder reg 9 = hton(reg 9, 4, 4) ]
   [ lookup reg 1 set ipsec_in dreg 0 ]

- Support for chain multidevice in JSON

- Lots of fixes to address input sanitization (UB):

  * turn valuation assert() into errors
  * turn evaluation error instead of crash
  * parser crash
  * expression with no datatype & incompatible key with datatype in set,
  * OOB
  * memleaks

- Fix monitor mode with set intervals & concatenation

- Unbreak tcp option with numbers

    tcp option 254

- Unbreak {meta,ct} mark statement with maps

    meta mark set vlan id map { 1 : 0x00000001, 4095 : 0x00004095 }

- Reject large raw payload and concat expression

    Error: Concatenation of size 544 exceeds maximum size of 512
    udp length . @th,0,512 . @th,512,512 { 47-63 . 0xe373135363130 . 0x33131303735353203 }

- Search for group, rt_mark, rt_realms at:

    /etc/iproute2/
    /use/share/iproute2/
    … and display values via nft describe

    # nft describe meta rtclassid
    meta expression, datatype realm (routing realm) (basetype integer), 32 bits

    pre-defined symbolic constants from /etc/iproute2/rt_realms (in decimal):
        cosmos                                             0
    Reject statement with range
        meta mark set 0-100

- Support for auto-merge flag in sets in JSON

- Print 0s in time datatype

- Speed up list tables by fetching tables only

- Skip byteorder conversion with 8-byte fields

   set test {
      type ipv4_addr . ether_addr . inet_proto
      flags interval
   }
   ip saddr . ether saddr . meta l4proto @test counter

- Honor -t/--terse with list table and list set to speed up listing
- Allow for host-endian in set lookups

    map ipsec_in {
       typeof ipsec in reqid . iif : verdict
       flags interval
    }
    ipsec in reqid . 100 @ipsec_in

- Better error report when destroy command is not supported (requires >= 6.3)

- Allow to define maps with:
  * ct timeout
  * ct expectation
  * ct helper

- Translate meter into dynamic set

   add rule t c tcp dport 80 meter m size 128 { ip saddr timeout 2s limit rate 10/second }

  now becomes:

   set m {
      type ipv4_addr
      size 128
      flags dynamic,timeout
   }
   tcp dport 80 update @m { ip saddr timeout 2s limit rate 10/second burst 5 packets }

- No payload merge on negation

  tcp sport != 22 tcp dport != 23

- JSON updates:
  - List empty chain early before set/maps
  - Support for maps with concatenated data
  - Support for synproxy objects

- Restore binop syntax for flags for listing

    tcp flags & (fin | syn | rst | ack ) == syn

- Cross-day meta hour issues

    TZ=EADT $NFT add rule t c meta hour "03:00"-"14:00"

- Remove prefix notation from mark

    meta mark & 0xffffff00 == 0xffffff00

  instead of

    meta mark 0xffffff00/24

- Use numeric icmp codes in listings (ICMP codes are dependent of ICMP type)

- Add table persist flag to JSON

- Support for variables in map expressions

   define dst_map = { ::1234 : 5678 }

   table ip6 nat {
      map dst_map {
         typeof ip6 daddr : tcp dport;
         elements = $dst_map
      }
      chain prerouting {
         ip6 nexthdr tcp redirect to ip6 daddr map @dst_map
      }
   }

- VLAN support:

   # payload statement
   ip saddr 10.1.1.1 icmp type echo-request vlan id set 321

   # payload expression (QinQ matching)
   ether type 8021ad vlan id 10 vlan type 8021q vlan id 100 vlan type ip accept

- Recycle existing cache if generation ID did not change, to speed up
  incremental updates.

- Better error reporting when redefining chain

   ruleset.nft:7:9-52: Error: Chain "input" already exists in table ip 'filter' with different declaration
                 type filter hook postrouting priority filter;
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Issues with variables

   define m = { 3, 4 }
   add element ip a x \$m
   add element ip a x { 5 }

- Broader IPv4-Mapped IPv6 (similar to iptables)

   aaaa::1.2.3.4

- -f/--filename includes path relative to the current (the including) file's directory

- -I/--include: default include path now searched at the end.

- New string preprocessor (only for log statement)

   define message=”test”
   log prefix “my $message”

- Fix set element deletion is maps:

      map m {
               typeof ct bytes : meta priority
               flags interval
               elements = { 2048001-4000000 : 1:2 }
       }
       meta priority set ct bytes map @m

- Unbreak -o/--optimize with counter statements

   # nft -c -o -f ruleset.nft
   Merging:
   ruleset.nft:5:17-45:                 ct state invalid counter drop
   ruleset.nft :6:17-59:                 ct state established,related counter accept
   into:
        ct state vmap { invalid counter : drop, established counter : accept, related counter : accept }

   Merging:
   ruleset.nft:7:17-43:                 tcp dport 80 counter accept
   ruleset.nft:8:17-44:                 tcp dport 123 counter accept
   into:
        tcp dport { 80, 123 } counter accept

   Merging:
   ruleset.nft:9:17-64:                 ip saddr 1.1.1.1 ip daddr 2.2.2.2 counter accept
   ruleset.nft:10:17-62:                 ip saddr 1.1.1.2 ip daddr 3.3.3.3 counter drop
   into:
          ip saddr . ip daddr vmap { 1.1.1.1 . 2.2.2.2 counter : accept, 1.1.1.2 . 3.3.3.3 counter : drop }

... including manpage updates too and tests enhancements.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

[ NOTE: We have switched to .tar.xz files for releases. ]

To build the code, libnftnl >= 1.2.7 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--5sKcLUB2g6pQQvAa
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.1.0.txt"
Content-Transfer-Encoding: 8bit

Florian Westphal (87):
      check-tree.sh: check and flag /bin/sh usage
      meta: fix hour decoding when timezone offset is negative
      evaluate: fix rule replacement with anon sets
      tests: shell: skip ct expectation test if feature is missing
      tests: shell: skip maps delete test if dynset lacks delete op
      tests: shell: skip meta time test meta expression lacks support
      tests: shell: add test case for catchall gc bug
      evaluate: reject sets with no key
      tests: shell: add missing .nodump file
      evaluate: prevent assert when evaluating very large shift values
      evaluate: turn assert into real error check
      evaluate: handle invalid mapping expressions gracefully
      evaluate: guard against NULL basetype
      evaluate: error out if basetypes are different
      evaluate: disable meta set with ranges
      evaluate: reject attempt to update a set
      evaluate: catch implicit map expressions without known datatype
      evaluate: fix double free on dtype release
      tests: shell: add test case for sets without key
      parser: tcpopt: fix tcp option parsing with NUM + length field
      tests: rename file to lowercase
      evaluate: validate chain max length
      parser_bison: fix objref statement corruption
      parser_bison: fix memleak in meta set error handling
      netlink: add and use nft_data_memcpy helper
      evaluate: fix bogus assertion failure with boolean datatype
      parser_bison: make sure obj_free releases timeout policies
      parser_bison: fix ct scope underflow if ct helper section is duplicated
      parser_bison: close chain scope before chain release
      parser_bison: fix memory leaks on hookspec error processing
      evaluate: stmt_nat: set reference must point to a map
      evaluate: error out when existing set has incompatible key
      meta: fix tc classid parsing out-of-bounds access
      evaluate: fix gmp assertion with too-large reject code
      Revert "evaluate: error out when existing set has incompatible key"
      netlink: don't crash if prefix for < byte is requested
      evaluate: exthdr: statement arg must be not be a range
      src: reject large raw payload and concat expressions
      netlink: fix stack buffer overflow with sub-reg sized prefixes
      evaluate: fix stack overflow with huge priority string
      intervals: set_to_range can be static
      tcpopt: don't create exthdr expression without datatype
      intervals: BUG on prefix expressions without value
      parser_bison: error out on duplicated type/typeof/element keywords
      evaluate: don't crash if object map does not refer to a value
      netlink: fix stack overflow due to erroneous rounding
      src: do not allow to chain more than 16 binops
      parser_bison: ensure all timeout policy names are released
      tests: shell: prefer project nft to system-wide nft
      datatype: do not assert when value exceeds expected width
      tests: add a test case for double-flush bug in pipapo
      evaluate: error out when expression has no datatype
      evaluate: tproxy: move range error checks after arg evaluation
      evaluate: add missing range checks for dup,fwd and payload statements
      payload: only assert if l2 header base has no length
      parser: reject raw payload expressions with 0 length
      evaluate: error out when store needs more than one 128bit register of align fixup
      rule: fix sym refcount assertion
      tests: py: remove huge-limit test cases
      evaluate: don't assert on net/transport header conflict
      netlink_delinearize: move concat and value postprocessing to helpers
      tests: shell: permit use of host-endian constant values in set lookup keys
      tests: shell: add regression test for catchall double-delete
      tests: py: add missing json.output data
      tests: shell: add more json dumps
      parser_json: allow 0 offsets again
      parser: compact interval typeof rules
      parser: compact type/typeof set rules
      parser: allow typeof in objref maps
      netlink: allow typeof keywords with objref maps during listing
      tests: maps: add a test case for "limit" objref map
      tests: move test case to "maps" directory
      parser: allow to define maps that contain timeouts and expectations
      parser: allow to define maps that contain ct helpers
      tests: add test case for named ct objects
      tests: py: add payload merging test cases
      src: remove utf-8 character in printf lines
      src: do not merge a set with a erroneous one
      tests: shell: add regression test for double-free crash bug
      tests: meta_time: fix dump validation failure
      tests: packetpath: add check for drop policy
      rule: do not crash if to-be-printed flowtable lacks priority
      tests: shell: add test case for reset tcp warning
      libnftables: fix crash when freeing non-malloc'd address
      tests: shell: add more ruleset validation test cases
      tests: shell: test jump to basechain is rejected, even if there is no loop
      tests: shell: connect chains to hook point

Jeremy Sowden (3):
      tests: shell: packetpath/flowtables: open all temporary files in /tmp
      evaluate: handle invalid mapping expressions in stateful object statements gracefully.
      evaluate: add support for variables in map expressions

Maks Mishin (1):
      evaluate: Fix incorrect checking the `base` variable in case of IPV6

Neels Hofmeyr (1):
      Makefile: mkdir $(builddir}/doc

Pablo Neira Ayuso (101):
      tests: shell: use /bin/bash in sets/elem_opts_compat_0
      evaluate: reject set in concatenation
      evaluate: reset statement length context only for set mappings
      evaluate: place byteorder conversion before rshift in payload expressions
      tests: shell: skip pipapo tests if kernel lacks support
      tests: shell: skip prerouting reject tests if kernel lacks support
      tests: shell: skip stateful expression in sets tests if kernel lacks support
      tests: shell: skip NAT netmap tests if kernel lacks support
      tests: shell: skip comment tests if kernel lacks support
      tests: shell: skip multidevice chain tests if kernel lacks support
      tests: shell: skip if kernel does not support bitshift
      tests: shell: split set NAT interval test
      tests: shell: split map test
      tests: shell: split single element in anonymous set
      tests: shell: split merge nat optimization in two tests
      src: expand create commands
      tests: shell: skip if kernel does not support flowtable counter
      tests: shell: skip if kernel does not support flowtable with no devices
      tests: shell: skip pipapo set backend in transactions/30s-stress
      tests: shell: restore pipapo and chain binding coverage in standalone 30s-stress
      tests: shell: skip sets/sets_with_ifnames if no pipapo backend is available
      tests: shell: adjust add-after-delete flowtable for older kernels
      tests: shell: quote reference to array to iterate over empty string
      tests: shell: flush connlimit sets
      evaluate: bogus error when adding devices to flowtable
      tests: shell: connlimit tests requires set expression support
      tests: shell: skip stateful object updates if unsupported
      tests: shell: detach synproxy test
      tests: shell: skip synproxy test if kernel does not support it
      tests: shell: skip nat inet if kernel does not support it
      tests: shell: split nat inet tests
      tests: shell: skip secmark tests if kernel does not support it
      tests: shell: skip if kernel does not allow to restore set element expiration
      evaluate: clone unary expression datatype to deal with dynamic datatype
      json: deal appropriately with multidevice in chain
      tests: shell: flush ruleset with -U after feature probing
      monitor: add support for concatenated set ranges
      evaluate: reject set definition with no key
      tests: py: missing json output in never merge across non-expression statements
      evaluate: reset statement length context before evaluating statement
      tests: py: missing json output in meta.t with vlan mapping
      tests: shell: add test to cover payload transport match and mangle
      tests: shell: extend coverage for netdevice removal
      doc: incorrect datatype description for icmpv6_type and icmpvx_code
      evaluate: skip anonymous set optimization for concatenations
      evaluate: do not fetch next expression on runaway number of concatenation components
      evaluate: bail out if anonymous concat set defines a non concat expression
      evaluate: release key expression in error path of implicit map with unknown datatype
      evaluate: release mpz type in expr_evaluate_list() error path
      tests: shell: netdevice removal for inet family
      tests: shell: cover netns removal for netdev and inet/ingress basechains
      datatype: display 0s time datatype
      tests: shell: missing auto-merge in json output
      evaluate: skip byteorder conversion for selector smaller than 2 bytes
      netlink_linearize: add assertion to catch for buggy byteorder
      evaluate: permit use of host-endian constant values in set lookup keys
      expression: missing line in describe command with invalid expression
      rule: fix ASAN errors in chain priority to textual names
      evaluate: translate meter into dynamic set
      tests: py: move meter tests to tests/shell
      netlink_delinearize: restore binop syntax when listing ruleset for flags
      netlink_delinearize: reverse cross-day meta hour range
      evaluate: display "Range negative size" error
      datatype: use DTYPE_F_PREFIX only for IP address datatype
      netlink_delinearize: unused code in reverse cross-day meta hour range
      src: disentangle ICMP code types
      tests: py: complete icmp and icmpv6 update
      tests: shell: payload matching requires egress support
      tests: shell: chains/{netdev_netns_gone,netdev_chain_dev_gone} require inet/ingress support
      tests: shell: maps/{vmap_unary,named_limits} require pipapo set backend
      tests: shell: check for reset tcp options support
      tests: shell: combine dormant flag with netdevice removal
      evaluate: bogus protocol conflicts in vlan with implicit dependencies
      tests: shell: add vlan double tagging match simple test case
      tests: shell: add vlan mangling test case
      cache: check for NFT_CACHE_REFRESH in current requested cache too
      cache: recycle existing cache with incremental updates
      scanner: inet_pton() allows for broader IPv4-Mapped IPv6 addresses
      monitor: too large shift exponent displaying payload expression
      cmd: provide better hint if chain is already declared with different type/hook/priority
      cmd: skip variable set elements when collapsing commands
      tests: shell: add dependencies to skip unsupported tests in older kernels
      tests: shell: skip ip option tests if kernel does not support it
      tests: shell: skip ipsec tests if kernel does not support it
      tests: shell: skip NFTA_RULE_POSITION_ID tests if kernel does not support it
      libnftables: add base directory of -f/--filename to include path
      libnftables: search for default include path last
      tests: py: drop redundant JSON outputs
      src: add string preprocessor and use it for log prefix string
      tests: shell: check for removing table via handle with incorrect family
      evaluate: set on expr->len for catchall set elements
      segtree: set on EXPR_F_KERNEL flag for catchall elements in the cache
      intervals: fix element deletions with maps
      tests: shell: cover set element deletion in maps
      parser_bison: recursive table declaration in deprecated meter statement
      parser_bison: remove deprecated flow statement
      optimize: clone counter before insertion into set element
      parser_json: use stdin buffer if available
      libnftables: skip useable checks for /dev/stdin
      parser_bison: remove one more utf-8 character
      build: Bump version to 1.1.0

Phil Sutter (32):
      parser_bison: Fix for broken compatibility with older dumps
      tproxy: Drop artificial port printing restriction
      tests: shell: Fix sets/reset_command_0 for current kernels
      main: Reduce indenting in nft_options_check()
      main: Refer to nft_options in nft_options_check()
      datatype: rt_symbol_table_init() to search for iproute2 configs
      datatype: Initialize rt_symbol_tables' base field
      datatype: Describe rt symbol tables
      json: Support sets' auto-merge option
      cache: Optimize caching for 'list tables' command
      tests: shell: Pretty-print all *.json-nft dumps
      cache: Always set NFT_CACHE_TERSE for list cmd with --terse
      tests: shell: packetpath/flowtables: Avoid spurious EPERM
      json: Order output like nft_cmd_expand()
      tests: shell: Regenerate all json-nft dumps
      json: Support maps with concatenated data
      parser: json: Support for synproxy objects
      tests: shell: Add missing json-nft dumps
      tests: shell: Fix one json-nft dump for reordered output
      doc: libnftables-json: Drop invalid ops from match expression
      doc: nft.8: Two minor synopsis fixups
      json: Accept more than two operands in binary expressions
      mergesort: Avoid accidental set element reordering
      tests: py: Fix some JSON equivalents
      tests: py: Warn if recorded JSON output matches the input
      tests: py: Drop needless recorded JSON outputs
      tests: shell: Avoid escape chars when printing to non-terminals
      Add support for table's persist flag
      json: Fix for memleak in __binop_expr_json
      tests: shell: Fix for maps/typeof_maps_add_delete with ASAN
      doc: nft.8: Fix markup in ct expectation synopsis
      doc: nft.8: Highlight "hook" in flowtable description

Quan Tian (1):
      doc: clarify reject is supported at prerouting stage

Sam James (1):
      Makefile.am: don't silence -Wimplicit-function-declaration

Son Dinh (1):
      dynset: avoid errouneous assert with ipv6 concat data

Sriram Rajagopalan (1):
      nftables: do mot merge payloads on negation

Thomas Haller (37):
      tests/shell: honor NFT_TEST_VERBOSE_TEST variable to debug tests via `bash -x`
      tests/shell: add missing "elem_opts_compat_0.nodump" file
      tests/shell: test for maximum length of "comment" in "comments_objects_0"
      tests/shell: inline input data in "single_anon_set" test
      tools: reject unexpected files in "tests/shell/testcases/" with "check-tree.sh"
      tests/shell: add "bogons/nft-f/zero_length_devicename2_assert"
      tests/shell: cover long interface name in "0042chain_variable_0" test
      parser_bison: fix length check for ifname in ifname_expr_alloc()
      tests/shell: fix mount command in "test-wrapper.sh"
      gitignore: ignore ".dirstamp" files
      build: no recursive-make for "include/**/Makefile.am"
      build: no recursive make for "py/Makefile.am"
      build: no recursive make for "files/**/Makefile.am"
      build: no recursive make for "src/Makefile.am"
      build: no recursive make for "examples/Makefile.am"
      build: no recursive make for "doc/Makefile.am"
      datatype: don't return a const string from cgroupv2_get_path()
      gmputil: add nft_gmp_free() to free strings from mpz_get_str()
      src: add free_const() and use it instead of xfree()
      src: remove xfree() and use plain free()
      netlink: fix buffer size for user data in netlink_delinearize_chain()
      parser: use size_t type for strlen() results
      json: fix use after free in table_flags_json()
      tests/shell: check and generate JSON dump files
      tests/shell: add JSON dump files
      tools: simplify error handling in "check-tree.sh" by adding msg_err()/msg_warn()
      tools: check more strictly for bash shebang in "check-tree.sh"
      tools: check for consistency of .json-nft dumps in "check-tree.sh"
      tests/shell: sanitize "handle" in JSON output
      tests/shell: prettify JSON in test output and add helper
      tests/shell: workaround lack of `wait -p` before bash 5.1
      tests/shell: workaround lack of $SRANDOM before bash 5.1
      tests/shell: use generated ruleset for `nft --check`
      netlink_linearize: avoid strict-overflow warning in netlink_gen_bitwise()
      tests/shell: have .json-nft dumps prettified to wrap lines
      tests/shell: no longer support unprettified ".json-nft" files
      tests: use common shebang in "packetpath/flowtables" test

Yi Chen (1):
      tests: shell: add test to cover ct offload by using nft flowtables

谢致邦 (XIE Zhibang) (3):
      evaluate: fix check for unknown in cmd_op_to_name
      src: improve error reporting for destroy command
      doc: drop duplicate ARP HEADER EXPRESSION


--5sKcLUB2g6pQQvAa--
