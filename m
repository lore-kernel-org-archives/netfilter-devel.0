Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D32EB64DA
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Jul 2023 11:05:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbjGNLFJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Jul 2023 07:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbjGNLFI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jul 2023 07:05:08 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1224C0;
        Fri, 14 Jul 2023 04:05:05 -0700 (PDT)
Date:   Fri, 14 Jul 2023 13:05:00 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] nftables 1.0.8 release
Message-ID: <ZLEr3Eg59HyPUUSR@calendula>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MMz8IM/2NqTZrRD0"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--MMz8IM/2NqTZrRD0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.0.8

This release contains enhancements and fixes such as:

- Support for setting meta and ct mark from other fields in rules,
  eg. set meta mark to ip dscp header field.

    ... meta mark set ip dscp

  You can also combining it with expressions such as:

    ... meta mark set ip dscp and 0x0f
    ... meta mark set ip dscp << 8
    ... meta mark set (ip dscp and 0xf) << 8

- Enhacements for -o/--optimize to deal with NAT statements, to compact
  masquerade statements:

     Merging:
     masq.nft:3:3-36:              ip saddr 10.141.11.0/24 masquerade
     masq.nft:4:3-36:              ip saddr 10.141.13.0/24 masquerade
     into:
                ip saddr { 10.141.11.0/24, 10.141.13.0/24 } masquerade

  ... and redirect statements too:

     Merging:
     redir.nft:3:3-32:              tcp dport 83 redirect to :8083
     redir.nft:4:3-32:              tcp dport 84 redirect to :8084
     into:
                redirect to :tcp dport map { 83 : 8083, 84 : 8084 }

- Support for stateful statements in anonymous maps, such as counters.

    ... meta mark { 0xa counter, 0xb counter }

  this can also be used in verdict maps:

    ... ip saddr vmap { 127.0.0.1 counter : drop, * counter : accept }

  this allows to compact 'ct state' matching in rulesets without losing
  the ability to count packets:

    ... ct state vmap { established counter : accept, \
                        related counter : accept, \
                        invalid counter : drop }

- Support for resetting stateful expressions in sets, maps and elements,
  e.g. counters:

    reset element t m '{ 1.2.3.4 }'
    reset map ip t m
    reset set ip t m

  Note that this feature requires Linux kernel >= 6.5-rc1.

- Simplify reset command syntax. This command allows you to reset
  stateful information in rules, such as counters and quotas:

    reset rules                  # reset all counters regardless family
    reset rules ip               # reset all counters for family 'ip'
    reset rules ip t             # reset all counters for table 'filter' in family 'ip'
    reset rules ip t c           # reset all counters in chain 'input'

  Similarly, you do not have to specify the table keyword anymore when
  resetting named stateful objects:

    reset counters
    reset counters ip
    reset counters ip filter

- Fix bogus error reporting on missing transport protocol when using
  layer 4 keys in maps:

    ... redirect to :tcp dport map { 83 : 8083, 84 : 8084 }

  This redirects traffic to the localhost ports depending on the TCP
  destination port, ie. packets going to TCP destination port 83 are
  redirected to localhost TCP port 8083.

- Provide a hint in unpriviledged namespaces to allow for large rulesets:

    # nft -f test.nft
    netlink: Error: Could not process rule: Message too long
    Please, rise /proc/sys/net/core/wmem_max on the host namespace. Hint: 4194304 bytes

  This has been an issue for people loading GeoIP sets from containers,
  with large IP source address sets.

- Allow for updating devices on existing netdev chain (This requires Linux kernel >= 6.3).

    This patch allows you to add/remove devices to an existing chain:

     # cat ruleset.nft
     table netdev x {
            chain y {
                    type filter hook ingress devices = { eth0 } priority 0; policy accept;
            }
     }
     # nft -f ruleset.nft
     # nft add chain netdev x y '{ devices = { eth1 };  }'
     # nft list ruleset
     table netdev x {
            chain y {
                    type filter hook ingress devices = { eth0, eth1 } priority 0; policy accept;
            }
     }
     # nft delete chain netdev x y '{ devices = { eth0 }; }'
     # nft list ruleset
     table netdev x {
            chain y {
                    type filter hook ingress devices = { eth1 } priority 0; policy accept;
            }
     }

- Make "nft list sets" include set elements in listing by default,
  please, use -t/--terse to fetch the sets without elements.

- Improve error reporting with suggestions on datatype mistypes:

     test.nft:3:11-14: Error: Could not parse Differentiated Services Code Point expression; did you you mean `cs0`?
                     ip dscp ccs0
                             ^^^^

  Provide a suggestion too for incorrect jump/goto to chain in map:

     # cat test.nft
     table ip x {
            map y {
                    typeof ip saddr : verdict
                    elements = { 1.2.3.4 : filter_server1 }
            }
     }
     # nft -f test.nft
     test.nft:4:26-39: Error: Could not parse netfilter verdict; did you mean `jump filter_server1'?
                     elements = { 1.2.3.4 : filter_server1 }
                                            ^^^^^^^^^^^^^^

- Support for constant values in concatenations. For example, allow to
  update a set from packet path using constants:

    ... update @s1 { ip saddr . 10.180.0.4 . 80 }

- broute support to short-circuit bridge logic from the bridge prerouting hook
  and pass up packets to the local IP stack.

    ... meta broute set 1

- JSON support for table and chain comments:

    # nft -j list ruleset
    {"nftables": [{"metainfo": {"version": "1.0.7", "release_name": "Old Doc Yak", "json_schema_version": 1}}, {"table": {"family": "inet", "name": "test3", "handle": 4, "comment": "this is a comment"}}]}

- JSON support for inner/tunnel matching. This example shows how match
  on the IP dscp field encapsulated under vxlan header.

    # udp dport 4789 vxlan ip dscp 0x02
    [
        {
            "match": {
                "left": {
                    "payload": {
                        "field": "dport",
                        "protocol": "udp"
                    }
                },
                "op": "==",
                "right": 4789
            }
        },
        {
            "match": {
               "left": {
                    "payload": {
                        "field": "dscp",
                        "protocol": "ip",
                        "tunnel": "vxlan"
                    }
                },
                "op": "==",
                "right": 2
            }
        }
    ]

- JSON support for 'last used' statement, that tells when a rule/set
  element has been used last time.

- Update 'nft list hooks' command to display registered bpf hooks in the
  netfilter dataplane.

- disallow combining -i/--interactive and -f/--filename.

- distutils has been replaced with setuptools in nftables Python binding.

... as well as asorted fixes and manpage documentation updates.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

[ NOTE: We have switched to .tar.xz files for releases. ]

To build the code, libnftnl >= 1.2.6 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--MMz8IM/2NqTZrRD0
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.0.8.txt"

Fernando Fernandez Mancera (1):
      tests: extend tests for destroy command

Florian Westphal (17):
      meta: don't crash if meta key isn't known
      src: fix enum/integer mismatches
      doc: list set/map flag keywords in a table
      doc: add nat examples
      netlink: restore typeof interval map data type
      mnl: support bpf id decode in nft list hooks
      src: permit use of constant values in set lookup keys
      tests: shell: add test case for chain-in-use-splat
      cache: include set elements in "nft set list"
      json: dccp: remove erroneous const qualifier
      evaluate: do not abort when prefix map has non-map element
      parser: don't assert on scope underflows
      parser: reject zero-length interface names
      parser: reject zero-length interface names in flowtables
      ct timeout: fix 'list object x' vs. 'list objects in table' confusion
      src: avoid IPPROTO_MAX for array definitions
      tests: json: add missing/expected json output

Jeremy Sowden (9):
      evaluate: insert byte-order conversions for expressions between 9 and 15 bits
      evaluate: don't eval unary arguments
      tests: py: add test-cases for ct and packet mark payload expressions
      tests: shell: rename and move bitwise test-cases
      tests: shell: add test-cases for ct and packet mark payload expressions
      netlink_delinearize: correct type and byte-order of shifts
      json: formatting fixes
      doc: correct NAT statement description
      exthdr: add boolean DCCP option matching

Jose M. Guisado Gomez (1):
      py: replace distutils with setuptools

Pablo Neira Ayuso (45):
      Revert "evaluate: relax type-checking for integer arguments in mark statements"
      parser_bison: simplify reset syntax
      evaluate: support shifts larger than the width of the left operand
      evaluate: relax type-checking for integer arguments in mark statements
      evaluate: set up integer type to shift expression
      evaluate: honor statement length in integer evaluation
      evaluate: honor statement length in bitwise evaluation
      netlink_delinerize: incorrect byteorder in mark statement listing
      tests: py: extend test-cases for mark statements with bitwise expressions
      payload: set byteorder when completing expression
      intervals: use expression location when translating to intervals
      optimize: assert nat type on nat statement helper
      evaluate: bogus missing transport protocol
      netlink_delinearize: do not reset protocol context for nat protocol expression
      optimize: support for redirect and masquerade
      main: Error out when combining -i/--interactive and -f/--file
      mnl: set SO_SNDBUF before SO_SNDBUFFORCE
      mnl: flowtable support for extended netlink error reporting
      src: allow for updating devices on existing netdev chain
      evaluate: bail out if new flowtable does not specify hook and priority
      meta: skip protocol context update for nfproto with same table family
      json: allow to specify comment on table
      json: allow to specify comment on chain
      mnl: handle singleton element in netdevice set
      mnl: incomplete extended error reporting for singleton device in chain
      tests: py: missing json updates on ct and meta mark payload expression
      evaluate: allow stateful statements with anonymous verdict maps
      evaluate: skip optimization if anonymous set uses stateful statement
      optimize: do not remove counter in verdict maps
      datatype: misspell support with symbol table parser for error reporting
      datatype: add hint error handler
      evaluate: set NFT_SET_EVAL flag if dynamic set already exists
      tests: shell: fix spurious errors in terse listing in json
      tests: shell: bogus EBUSY errors in transactions
      src: add json support for last statement
      json: add inner payload support
      tests: shell: coverage for simple port knocking ruleset
      tests: shell: cover refcount leak of mapping rhs
      expression: define .clone for catchall set element
      tests: shell: refcount memleak in map rhs with timeouts
      netlink_linearize: use div_round_up in byteorder length
      evaluate: place byteorder conversion before rshift in payload statement
      tests: shell: cover old scanner bug
      include: missing dccpopt.h breaks make distcheck
      build: Bump version to 1.0.8

Phil Sutter (12):
      Reduce signature of do_list_table()
      Avoid a memleak with 'reset rules' command
      xt: Fix translation error path
      tests: shell: Fix for unstable sets/0043concatenated_ranges_0
      tests: py: Document JSON mode in README
      main: Make 'buf' variable branch-local
      main: Call nft_ctx_free() before exiting
      cli: Make cli_init() return to caller
      tests: shell: Introduce valgrind mode
      evaluate: Merge some cases in cmd_evaluate_list()
      evaluate: Cache looked up set for list commands
      Implement 'reset {set,map,element}' commands

Sriram Yagnaraman (1):
      meta: introduce meta broute support

Thomas Haller (4):
      libnftables: always initialize netlink socket in nft_ctx_new()
      libnftables: drop unused argument nf_sock from nft_netlink()
      libnftables: inline creation of nf_sock in nft_ctx_new()
      libnftables: drop check for nf_sock in nft_ctx_free()


--MMz8IM/2NqTZrRD0--
