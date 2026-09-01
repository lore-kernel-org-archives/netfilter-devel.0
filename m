Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C213D1CAF;
	Tue,  1 Sep 2026 17:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788284699; cv=none; b=e1dLVGxRUAuKKcLVMFZA9DqvnYJeY4lgVqKWp9Kyi1vi1y4FWB/6ZupaU5IxQ8lzN7rWQLcieIza5yp8+bNjGV4UMmmBjltCHLdWcK3hLBD03ZkZVS4cQXJMIU3hHO7PfDiU1z79YSOaynnpWjHXDQeLCOQF1BcH02eoW1Ja9Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788284699; c=relaxed/simple;
	bh=HlYOTcn9YvyGoeDZKwOPn+UsK8lyk1XNV4Js+aWaR0U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rapfODq3MU/112+0+nCLPz1Y5A0Jqjw05XbQ6Qts8IrMf76dAByVoHBQp4OFRdor7foPm8LqHefIRA3OdPeUSD/3pdDpbki3gajgll86jItb4tk/BJPpqlv6I8zcoeoOv8fkETBfw5dYWzdxtLpaksZmHNE1toiGBSOFct4Cu40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=W+O37/Fw; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="W+O37/Fw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788284688;
	bh=X2LZz8v5dtuFDLWAr9yWZE5vJzDVeDJeqGQC1IiQ8fc=;
	h=Date:From:To:Cc:Subject:From;
	b=W+O37/FwpJ183GbA0IXxee8Xt5DapfXKI+FaC6DoZ4+Rti9LC226Cj/89/x2TcgIG
	 pE0plextkSK5j3BoFuoCqp2R4e2/4rev7QvoOXg7t9cMgzBdrfnwnkk83WcFHvqhHu
	 PMr6M8hGp2hs9lqFkTaeCHQ7LjbYhEmfIHSAYngILLnEqL3xnJLuruBPiTuSkJieFD
	 wlwU3IxjSy6BJ9LbPuv7GgZbYReW3+aEAHdh/uL/dGXfp6QXVMYnqUa7ilq5rx87H3
	 +RGt7Azwe6BVydaGFt+AoQJ0Z5ltSgPk781Sdpq67v9T0X1isumMS7aC4KRpZJhZsR
	 vKKtKaAR0+hSQ==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 96DE560244;
	Tue,  1 Sep 2026 19:44:48 +0200 (CEST)
Date: Tue, 1 Sep 2026 19:44:46 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] nftables 1.1.7 release
Message-ID: <apcPDuB1u6REEd3n@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="clKMO4EmJQuYOVEg"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


--clKMO4EmJQuYOVEg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!
 
The Netfilter project proudly presents:
 
        nftables 1.1.7
 
This release contains mostly fixes but also new features:
 
- Fix spurious EEXIST error when using the create element command with
  large batches. Distributors offering binaries for versions > 1.1.2
  and <= 1.1.6 are encouraged to cherry-pick this fix:
 
    e83e32c8d1cd ("mnl: restore create element command with large batches").
 
- Improve error reporting for syntax errors by printing expected
  tokens:
 
    # nft add rule ip x y limit
    Error: syntax error, unexpected newline
    expected any of: name, rate
    add rule ip x y limit
 
  This requires bison >= 3.6.
 
- add/insert commands use 'handle' for positioning in JSON. The handle
  specifies from what rule to add (after the specified rule) or insert
  (before the specified rule). Multiple rules added at the same handle
  are positioned relative to the original rule, not to previously
  inserted rules.

{
  "nftables": [
    {
      "add": {
        "rule": {
          "family": "inet",
          "table": "test",
          "chain": "c",
          "handle": 10,    <----- this adds after rule with handle 10
          "expr": [
            {
              "match": {
                "op": "==",
                "left": {
                  "payload": {
                    "protocol": "tcp",
                    "field": "dport"
                  }
                },
                "right": 443
              }
            },
            {
              "accept": null
            }
          ]
        }
      }
    }
  ]
}
 
- Sort strings datatype when listing sets:
 
        ifname { "abcdef0", "eth0" } counter packets 0 bytes 0
 
- Sort concatenation components in big endian, so the listing is
  independent of the architecture byteorder.

- Update --debug=netlink to display data in its byteorder and size,
  this applies to immediate data in expressions and set elements.
 
   # nft --debug=netlink add rule x y tcp dport 22 counter
   ip x y
     [ meta load l4proto => reg 1 ]
     [ cmp eq reg 1 0x06 ]
     [ payload load 2b @ transport header + 2 => reg 1 ]
     [ cmp eq reg 1 0x0016 ]
     [ counter pkts 0 bytes 0 ]
 
  This requires libnftnl >= 1.3.2.
 
- Add --enable-profiling option for ./configure. This sets on
  the --coverage compiler flag so code coverage may be inspected
  using gcov.
 
- Set element support for multi-statements, eg. counter + quota.
 
   ...
   {
    "elem": {
      "val": "2.2.2.2",
      "counter": {
        "packets": 0,
        "bytes": 0
      },
      "quota": {
        "val": 1000,
        "val_unit": "bytes"
      }
    }
   }
 
  You can also combine with ct count, last and limit rate.

- Connlimit support with maps.
 
   table ip x {
        ct count connlimit1 {
                over 2
        }
        ct count connlimit2 {
                over 10
        }
 
        chain y {
                type filter hook input priority filter; policy accept;
                ct count name tcp dport map { 22 : "connlimit1", 80 : "connlimit2" } counter drop
        }
   }


- Include "count" field when listing set in JSON.
 
   ...
   {
      "set": {
        "family": "ip",
        "name": "y",
        "table": "x",
        "type": {
          "typeof": {
            "payload": {
              "protocol": "tcp",
              "field": "dport"
            }
          }
        },
        "handle": 1,
        "size": 10,
        "count": 3,    <--- because "size" is present, display "count"
        "elem": [
          1,
          30,
          50
        ]
      }
   }

- Support for using bitmask datatypes as set key, eg. tcp flags.
 
   table ip x {
        map y {
                typeof tcp flags : verdict
                flags interval
                elements = { syn | ack : accept,
                             ack : drop,
                             rst : drop,
                             0x20-0xff : drop,
               }
        }
 
        set s {
                typeof tcp flags
                flags interval
                elements = { syn | ack,
                             ack,
                             rst,
                             0x20-0xff,
               }
        }
 
 
        chain z {
                tcp flags vmap @y
                tcp flags vmap { syn | ack : accept, ack : drop, rst : drop, 0x20-0xff : drop }
                tcp flags @s
                tcp flags { syn | ack, ack, rst, 0x20-0xff }
        }
   }

- Fix element deletion by numeric cgroupsv2 id.
 
   # nft list set ip t s
   table ip t {
           set s {
                  type cgroupsv2
                  elements = { 50834 }
           }
   }
   # nft delete element ip t s { 50834 }
 
- Fix get element with intervals including maximum datatype value,
  eg. interval with 65535, ie. maximum value for typeof tcp dport.
 
   # nft get element ip x y { 65531 }
   table ip x {
        set y {
                type inet_service
                flags interval
                elements = { 65530-65535 }
        }
   }
   # nft get element ip x y { 65535 }
   table ip x {
        set y {
                type inet_service
                flags interval
                elements = { 65530-65535 }
        }
   }
 
- Use poll() not select(), otherwise libnftables breaks with
  third party applications with >= 1024 open file descriptors.
 
- Do not reset counter if -c/--check is specified with the reset
  command.
    
   # nft -c reset rules ip x

- Replace strings by tokens in the parser, leverage Flex start
  conditions for this purpose.
 
- Many tests coverage enhacements.
 
... and man nft(8) documentation updates and assorted fixes.
 
See changelog for more details (attached to this email).
 
You can download this new release from:
 
https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/
 
To build the code, libnftnl >= 1.3.2 and libmnl >= 1.0.4 are required:
 
* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html
 
Visit our wikipage for user documentation at:
 
* https://wiki.nftables.org
 
For the manpage reference, check man(8) nft.
 
In case of bugs and feature requests, file them via:
 
* https://bugzilla.netfilter.org
 
Happy firewalling.

--clKMO4EmJQuYOVEg
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.1.7.txt"
Content-Transfer-Encoding: 8bit

Adrian Moisey (1):
      netlink_linearize: size nat register allocation by address expression

Alan Ross (1):
      main: refuse to run under file capabilities

Alexandre Knecht (4):
      parser_json: support handle for rule positioning in explicit JSON format
      tests: shell: add JSON test for all object types
      tests: shell: add JSON test for handle-based rule positioning
      doc: clarify JSON rule positioning with handle field

Andrii Melnychenko (2):
      tests: shell: Refactored nat_ftp, added rulesets and testcase functions
      tests: shell: Added SNAT/DNAT only cases for nat_ftp

Avinash Duduskar (1):
      datatype: accept a numeric cgroupsv2 id on input

Avinash H. Duduskar (1):
      doc: note meta cgroup returns zero on cgroupv2-only hosts

Cory Snider (1):
      mnl: support RLIMIT_NOFILE soft limit > FD_SETSIZE

Fernando Fernandez Mancera (1):
      src: add connlimit stateful object support

Florian Westphal (43):
      tests: shell: bad_rule_graphs: add chain linked from different hooks
      tests: shell: add small packetpath test for bitmap set type
      tests: shell: add small packetpath test for hash and rbtree types
      parser: move qualified meta expression parsing to flex/bison
      monitor: fix memleak in setelem cb
      tests: shell: add test case for interval set with timeout and aborted transaction
      tests: shell: named_limits: minor tweak to ease debugging
      tests: shell: add regression test for catchall chain count restore
      tests: shell: extend interval overlap test
      tests: shell: set_flush_add_atomic_rbtree: tweak test to make it fail again
      Revert "main: refuse to run under file capabilities"
      mnl: restore nft monitor to working state
      tests: shell: add rbtree reload test case
      better reload tests for rbtree, pipapo
      parser_bison: add range check for synproxy wscale
      doc: ct count should be restricted via new
      tests: shell: fix a myriad of issues
      tests: shell: add a few more json dump files
      tests: shell: add test case for basechain abort path
      tests: py: don't use a fixed filename
      tests: shell: add test case for on-demand-gc without commit callback
      tests: shell: add test for buggy catchall element abort path
      tests: py: print the file name as intended
      tests: shell: add fwd to/fwd ip to test cases
      tests: py: osf is ip-only
      evaluate: remove zero shift expressions at eval stage
      tests: shell: add test case for netdev + dormant table
      tools: match_nomatch: fix spurious failure in nomatch test
      src: don't write to possible rodata location
      tests: shell: add a test case for last expression
      tests: shell: add a test case for dup expression
      tests: shell: add socket expression test
      parser_json: fix map/set type confusion crash in map statement parser
      tests: shell: add check for map+ratelimit+mark
      tests: shell: add stateless nat test case
      tests: shell: add simple 'ct count' test case
      tests: shell: rate_limit: also check byte-based limit
      tests: shell: add two missing dump files
      tests: shell: add two more TEST_REQUIRES tags
      tests: shell: add tunnel vxlan test
      tests: shell: add template match bug test
      tests: shell: add regression test for 'ip fwd to' stack recursion
      tests: shell: add packetpath test for nft ct expectation support

Jan Kończak (1):
      parser_bison: on syntax errors, output expected tokens

Jan Palus (1):
      build: fix ./configure with non-bash shell

Jeremy Sowden (5):
      doc: fix typo in man-page
      build: simplify the instantation of nftversion.h
      build: generate build time-stamp once at configure
      build: support `SOURCE_DATE_EPOCH` for build time-stamp
      tests: py: use `os.unshare` Python function

Niklas Fiekas (1):
      json: output set/map element count

Omkhar Arasaratnam (1):
      parser_json: initialize geneve options list for empty tunnel array

Pablo Neira Ayuso (38):
      tests: shell: cover for large interval sets with create command
      mnl: restore create element command with large batches
      tests: shell: add open interval overlap tests
      tests: shell: double chain update with same device
      src: normalize set element with EXPR_MAPPING
      src: allocate EXPR_SET_ELEM for EXPR_SET in embedded set declaration in sets
      src: assert on EXPR_SET only contains EXPR_SET_ELEM in the expressions list
      evaluate: simplify sets as set elems evaluation
      evaluate: clean up expr_evaluate_set()
      segtree: rename set_elem_add() to set_elem_expr_add()
      src: move flags from EXPR_SET_ELEM to key
      src: remove EXPR_SET_ELEM in range_expr_value_{low,high}()
      src: use key location to prepare removal of EXPR_SET_ELEM
      intervals: remove interval_expr_key()
      src: move __set_expr_add() to src/intervals.c
      segtree: remove EXPR_VALUE from expr_value()
      segtree: more assert on EXPR_SET_ELEM
      segtree: remove dead code in set_expr_add_splice()
      segtree: disentangle concat_range_aggregate()
      segtree: replace default case by specific types in get_set_intervals()
      segtree: consolidate calls to expr_value() to fetch the element key
      segtree: use set->key->byteorder instead of expr->byteorder
      evaluate: remove check for constant expression in set/map statement
      evaluate: skip EXPR_SET_ELEM in error path of set statements
      json: complete multi-statement set element support
      Tree-wide use of python3
      main: consolidate EPERM to non-root users
      cache: honor -c/--check for reset commands
      segtree: fix get element command with open intervals
      tests: shell: expand get command test with open intervals
      mergesort: use lhs expression when sorting concatenation
      segtree: basic support for binary operations in concatenated set ranges
      tests: shell: add flush set after expiration
      tests: shell: skip if arping is not available
      segtree: assert on value expressions
      Revert "segtree: basic support for binary operations in concatenated set ranges"
      segtree: postpone bitmask to symbol conversion for interval sets
      build: Bump version to 1.1.7

Phil Sutter (54):
      tests: monitor: Fix for out-of-path call
      parser_bison: Introduce tokens for monitor events
      parser_bison: Introduce tokens for chain types
      parser_bison: Introduce tokens for osf ttl values
      parser_bison: Introduce tokens for log levels
      parser_bison: Introduce bytes_unit
      scanner: Introduce SCANSTATE_RATE
      tests: json_echo: Drop rule handle before multi-add
      segtree: Fix range aggregation on Big Endian
      mergesort: Fix sorting of string values
      mergesort: Align concatenation sort order with Big Endian
      intervals: Convert byte order implicitly
      expression: Set range expression 'len' field
      netlink: Introduce struct nft_data_linearize::byteorder
      netlink: Introduce struct nft_data_linearize::sizes
      netlink: Make use of nftnl_{expr,set_elem}_set_imm()
      tests: py: tools: Add regen_payloads.sh
      tests: py: Update payload records
      utils: Introduce expr_print_debug()
      Makefile.am: Drop pointless per-project AM_CPPFLAGS
      tests: py: Adjust payloads to changed userdata printing
      doc: nft.8: Describe iface_type data type
      tests: shell: Add a simple test for nftrace
      xt: Print comment match data as well
      tests: shell: Add a basic test for src/xt.c
      Makefile: Pass PKG_CONFIG_PATH to internal builds
      configure: Implement --enable-profiling option
      Revert "tests: py: use `os.unshare` Python function"
      cache: Include chains, flowtables and objects in netlink debug output
      cache: Respect family in all list commands
      cache: Relax chain_cache_dump filter application
      cache: Filter for table when listing sets or maps
      cache: Filter for table when listing flowtables
      parser: Support table spec in 'list chains' command
      segtree: Fix for variable-sized object may not be initialized
      mnl: Fix ordering of hooks in 'list hooks' output
      scanner: Accept all statements' first words in all scopes
      tests: shell: packetpath/ct_count: Add missing socat feature test
      profiling: Include unistd.h to avoid compiler warnings
      intervals: Fix for inconsistent union field use
      tests: shell: Run tests with a fixed TZ
      tests: py: Fix --keep test runner option
      json: Introduce tunnel_obj_print_json()
      parser_json: Introduce json_parse_tunnel()
      rule: Turn obj_print_comment() into obj_print_header()
      rule: Introduce tunnel_obj_print_data()
      src: Avoid variable declarations in switch cases
      netlink: Call tunnel getters unconditionally
      parser_bison: Fix for bison < 3.6
      gitignore: Only ignore top level *.m4
      m4: Add missing AX_PROG_BISON macro
      tests: shell: Use --numeric-protocol for dumps
      tests: shell: Convert dumps to numeric protocols
      libnftables: Drop symbol nft_bison_have_extended_errors

PrittSpadeLord (1):
      doc: minor spelling and grammar fixes in doc

Yi Chen (1):
      test: shell: run-test.sh: introduce NFT_TEST_EXCLUDES


--clKMO4EmJQuYOVEg--
