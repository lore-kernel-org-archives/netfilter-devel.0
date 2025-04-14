Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F091624E9;
	Mon, 14 Apr 2025 17:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744653060; cv=none; b=JndTBJsaGRBHCN5/Pr02yurKCMy3ilkdU75ySdDax/Jng3RaTAywyYqOAYUZJ3WzBg7qjapBGeYWy48dWLD0uzUYpf5XuvXIIipt5q5dVKaCThNAHOtJVE/MSZG/KZk+0pi9cPZMARRfrGGPa8PJcV6Uzm5amzokzxpfQve84UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744653060; c=relaxed/simple;
	bh=cJ+w7NmrDn8s3Nxststx3Xuy7YUJ+S9DlfaoVbN6a5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SlI0QHqflHsFkPSQzEq5jKEzLyu3ltpBt5xXI9rCfiXODUWSo+Yb6p3kpUTgq6RH0FPlJFaNu7PKpOqYPfNJAvA0dC8Zw1hiANwsrgF3vuAwzQxAaP26aMhFLKPOHqzj+LygLbJcKJX7nyElxmF9qnbECCeyMEnyQIMHwnB4akk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RIsA0fK7; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=O4XCo9zl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RIsA0fK7";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="O4XCo9zl"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 59E8860623; Mon, 14 Apr 2025 19:50:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744653055;
	bh=+AV+UwQ+SoA42qffHK90WaEA7zULdVIDz0080wPbbK4=;
	h=Date:From:To:Cc:Subject:From;
	b=RIsA0fK7f0PsKj2ijdH+1z01GPtAhx5GyL2rdv3IkMFNnwTYTYGvgl4D1t554517n
	 RxXa9qidsohDbqL3i15l/qfNQvKy59xc0yZOW356/1GrPCPCuhKx9tcYPpUZMbGY5w
	 BswOfUSsLYk60nCbFV+BmV7nzhEFreNPfFwE98mFqZqFN9fduBvXYR6wSVUHsfJy+7
	 inphchGICNUpRTOGfAy3/DRLHj0NQ/aYEJRTaFdQSRD/OrMAL0MrBCK+yQGOhHEQZX
	 r75Z18YgHB3gjuAP4H6CYcmD2kkGE9Jx8uvjmMbA3HHQ4Kq2YqcE4DlqfI/ALYGmg5
	 HBqJVrR16xD2A==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 52F6160689;
	Mon, 14 Apr 2025 19:49:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1744652999;
	bh=+AV+UwQ+SoA42qffHK90WaEA7zULdVIDz0080wPbbK4=;
	h=Date:From:To:Cc:Subject:From;
	b=O4XCo9zlKDAjCkm7eO81g3ehCQV/qvHpQJuLeX2LiqusgIxleHUtHXtg1pijMTTVR
	 1dlImZD5T1CgSoNF/D6DUoqsx2NCNwMkL2bIDCLtX/wgEXTwOFkUwPmpkTMEoShtq8
	 Wqww4IDBTlHgGTpLIoBlm4Z75rIwdh81xp+DxuCAQbMiBRBKtzW4o5J62jTEdAy1pt
	 n04KPTfoRrRDeVF/3+VHant4eN0uf+Pb7Y33aDddbwrFggGg2F8qWTJxC7pCa75Q0C
	 IYQ4mvajTnCheF64Xi92ZNitOeel+N7dkYyGopwcHCKnGUqR5sYZpQ4tyDEz/yfLzS
	 YxeVKOwNMXWtw==
Date: Mon, 14 Apr 2025 19:49:56 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] nftables 1.1.2 release
Message-ID: <Z_1KxMUDT0D8e6wH@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J3iVo6MGJgsmpEN0"
Content-Disposition: inline


--J3iVo6MGJgsmpEN0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.1.2

This release contains (in no particular order):

- Allow for protocol dependency on sets, eg.

    table inet test {
       set protos {
               typeof meta l4proto
               elements = { tcp, udp }
       }

       chain prerouting {
               type filter hook prerouting priority mangle; policy accept;
               meta l4proto @protos tproxy to :1088
       }
    }

- Support for more advanced bitwise operations with statements:

    ... ct mark set ct mark & 0xffff0000 | meta mark & 0xffff
    ... meta mark set meta mark & 0xffff0000 | meta cpu << 8 | iif

  This requires Linux kernel >= 6.13.

- Set element auto-merge now skips elements with timeout/expiration.

- Allow to use queue with typeof.

    table inet t {
       map get_queue_id {
               typeof ip saddr . ip daddr . tcp dport : queue
               elements = { 127.0.0.1 . 127.0.0.1 . 22 : 1,
                            127.0.0.1 . 127.0.0.2 . 22 : 2 }
       }

       chain test {
               queue flags bypass to ip saddr . ip daddr . tcp dport map @get_queue_id
       }
    }

- Memory footprint reduction for set elements.

- Update nft monitor to reports flowtable events.

- Allow for listing sets with:

    list sets inet foo

  for consistency with existing commands. Previous versions require the 'table'
  keyword for this to work, ie.

    list sets table inet foo

- Support for merging bitmask matching in set/map with -o/--optimize

     # nft -c -o -f ruleset.nft
     Merging:
     ruleset.nft:7:17-76:                 tcp flags & (fin | syn | rst | ack | urg) == fin | ack | urg
     ruleset.nft:8:17-70:                 tcp flags & (fin | syn | rst | ack | urg) == fin | ack
     ruleset.nft:9:17-64:                 tcp flags & (fin | syn | rst | ack | urg) == fin
     ruleset.nft:10:17-70:                 tcp flags & (fin | syn | rst | ack | urg) == syn | ack
     ruleset.nft:11:17-64:                 tcp flags & (fin | syn | rst | ack | urg) == syn
     ruleset.nft:12:17-70:                 tcp flags & (fin | syn | rst | ack | urg) == rst | ack
     ruleset.nft:13:17-64:                 tcp flags & (fin | syn | rst | ack | urg) == rst
     ruleset.nft:14:17-70:                 tcp flags & (fin | syn | rst | ack | urg) == ack | urg
     ruleset.nft:15:17-64:                 tcp flags & (fin | syn | rst | ack | urg) == ack
     into:
            tcp flags & (fin | syn | rst | ack | urg) == { fin | ack | urg, fin | ack, fin, syn | ack, syn, rst | ack, rst, ack | urg, ack }

- Use range expression to represent a range, instead of two comparisons.

    -  [ cmp gte reg 1 0x00005000 ]
    -  [ cmp lte reg 1 0x00005a00 ]
    +  [ range eq reg 1 0x00005000 0x00005a00 ]

- Improve mptcp support with symbol table for subtypes:

    set s13 {
             typeof tcp option mptcp subtype
             elements = { mp-join, dss }
    }

    # nft describe tcp option mptcp subtype
    exthdr expression, datatype integer (mptcp option subtype) (basetype integer), 4 bits

    pre-defined symbolic constants (in decimal):
        mp-capable                                         0
        mp-join                                            1
        dss                                                2
        add-addr                                           3
        remove-addr                                        4
        mp-prio                                            5
        mp-fail                                            6
        mp-fastclose                                       7
        mp-tcprst                                          8

- Support for mangling bitfield headers, eg.

    ... ip dscp set ip dscp | 0x1

- Print set element with multi-word description in single one line.
  If the set element:

    - represents a mapping
    - has a timeout
    - has a comment
    - has counter/quota/limit
    - concatenation (already printed in a single line before this patch)

  ie. if the set element requires several words, then print it in one
  single line, eg.

    table ip x {
          set y {
                typeof ip saddr
                counter
                elements = { 192.168.10.35 counter packets 0 bytes 0,
                             192.168.10.101 counter packets 0 bytes 0,
                             192.168.10.135 counter packets 0 bytes 0 }
          }
    }

- Fix extended error reporting with large set elements.

- Fix extended error reporting with large set elements.

- Fix incorrect removal of meta nfproto in listings.

      ... meta nfproto ipv4 ct mark 0x00000001
      ... meta nfproto ipv6 ct protocol 6

- Fix get command with interval sets/maps:

    # nft get element x y { 1.1.1.2 }
    table ip x {
            map y {
                    typeof ip saddr : meta mark
                    counter
                    flags interval,timeout
                    elements = { 1.1.1.1-1.1.1.10 timeout 10m : 20 }
            }
    }

- Fix reset command with interval sets/maps too:

    # nft reset element inet filter intervalset { 1.2.3.4 }

- Do not remove layer 4 protocol dependency when listing raw expressions, eg.

    meta l4proto 91 @th,0,16 0x0 accept

- Fixes for -o/--optimize.

- Support for typeof in JSON.

... and a bunch of assorted fixes, manpage updates too and tests enhancements.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

[ NOTE: We have switched to .tar.xz files for releases. ]

To build the code, libnftnl >= 1.2.9 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--J3iVo6MGJgsmpEN0
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.1.2.txt"

Donald Yandt (1):
      mnl: fix basehook comparison

Eric Long (1):
      libnftables-json: fix raw payload expression documentation

Florian Westphal (53):
      tests: shell: fix spurious dump failure in vmap timeout test
      tests: shell: don't rely on writable test directory
      tests: monitor: fix up test case breakage
      doc: extend description of fib expression
      src: allow to map key to nfqueue number
      tests: shell: add a test case for netdev ruleset flush + parallel link down
      tests: shell: add cgroupv2 socket match test case
      parser_bison: fix UaF when reporting table parse error
      rule: make cmd_free(NULL) valid
      evaluate: allow to re-use existing metered set
      netlink_delinarize: fix bogus munging of mask value
      src: add and use payload_expr_trim_force
      tests: py: extend raw payload match tests
      parser_bison: compact and simplify list and reset syntax
      parser_bison: get rid of unneeded statement
      payload: remove double-store
      payload: return early if dependency is not a payload expression
      tests: add atomic chain replace test
      tests: remove temporary file
      payload: don't kill dependency for proto_th
      tcpopt: add symbol table for mptcp suboptions
      expression: propagate key datatype for anonymous sets
      netlink_delinearize: also consider exthdr type when trimming binops
      expression: expr_build_udata_recurse should recurse
      segtree: fix string data initialisation
      doc: add mptcp to tcp option matching list
      src: fix reset element support for interval set type
      tests: extend reset test case to cover interval set and map type
      evaluate: don't crash if range has same start and end interval
      tests: shell: skip interval size tests on kernel that lack rbtree size fix
      evaluate: fix expression data corruption
      evaluate: don't allow merging interval set/map with non-interval one
      evaluate: move interval flag compat check after set key evaluation
      netlink: fix stack buffer overrun when emitting ranged expressions
      parser_bison: reject non-serializeable typeof expressions
      netlink_delinerize: add more restrictions on meta nfproto removal
      expression: tolerate named set protocol dependency
      evaluate: don't allow nat map with specified protocol
      rule: return error if table does not exist
      evaluate: fix assertion failure with malformed map definitions
      json: make sure timeout list is initialised
      evaluate: don't update cache for anonymous chains
      json: return error if table does not exist
      json: don't BUG when asked to list synproxies
      json: fix error propagation when parsing binop lhs/rhs
      expression: don't try to import empty string
      evaluate: compact STMT_F_STATEFUL checks
      evaluate: only allow stateful statements in set and map definitions
      cache: don't crash when filter is NULL
      evaluate: reject: remove unused expr function argument
      evaluate: fix crash when generating reject statement error
      parser_json: only allow concatenations with 2 or more expressions
      evaluate: bail out if ct saddr/daddr dependency cannot be inserted

Jan Engelhardt (1):
      build: add hint for a2x error message

Jeremy Sowden (1):
      src: allow binop expressions with variable right-hand operands

Pablo Neira Ayuso (73):
      src: collapse set element commands from parser
      mnl: rename to mnl_seqnum_alloc() to mnl_seqnum_inc()
      mnl: update cmd_add_loc() to take struct nlmsghdr
      rule: netlink attribute offset is uint32_t for struct nlerr_loc
      src: fix extended netlink error reporting with large set elements
      tests: shell: move device to different namespace
      json: collapse set element commands from parser
      datatype: remove unused flags field
      mnl: restore --debug=netlink output with chains
      optimize: compare expression length
      intervals: set internal element location with the deletion trigger
      expression: remove elem_flags from EXPR_SET_ELEM to shrink struct expr size
      src: remove unused token_offset from struct location
      src: remove last_line from struct location
      src: shrink line_offset in struct location to 4 bytes
      libnftables: include canonical path to avoid duplicates
      main: prepend error tag to printed errors when parsing options
      intervals: add helper function to set previous element
      intervals: do not merge intervals with different timeout
      src: add EXPR_RANGE_VALUE expression and use it
      rule: constify set_is_non_concat_range()
      mnl: rename list of expression in mnl_nft_setelem_batch()
      mnl: do not send set size when set is constant set
      src: rework singleton interval transformation to reduce memory consumption
      scanner: better error reporting for CRLF line terminators
      evaluate: remove variable shadowing
      tests: shell: use mount --bind to change cgroupsv2 root
      tests: shell: delete netdev chain after test
      exthdr: incomplete type 2 routing header definition
      datatype: clamp boolean value to 0 and 1
      ipopt: use ipv4 address datatype for address field in ip options
      parser_bison: turn redundant ip option type field match into boolean
      src: add symbol range expression to further compact intervals
      netlink_linearize: use range expression for OP_EQ and OP_IMPLICIT
      evaluate: auto-merge is only available for singleton interval sets
      tests: shell: interval sets with size
      tests: shell: random interval set with size
      evaluate: optimize zero length range
      evaluate: consolidate evaluation of symbol range expression
      payload: honor inner payload description in payload_expr_cmp()
      evaluate: release existing datatype when evaluating unary expression
      evaluate: simplify payload statement evaluation for bitfields
      evaluate: reject unsupported expressions in payload statement for bitfields
      evaluate: support for bitfield payload statement with binary operation
      netlink_delinearize: support for bitfield payload statement with binary operation
      segtree: incomplete output in get element command with maps
      netlink_linearize: reduce register waste with non-constant binop expressions
      src: print set element with multi-word description in single one line
      src: replace struct stmt_ops by type field in struct stmt
      tests: py: remove unknown fields
      parser_bison: consolidate counter grammar rule for set elements
      parser_bison: consolidate limit grammar rule for set elements
      parser_bison: consolidate quota grammar rule for set elements
      parser_bison: consolidate last grammar rule for set elements
      parser_bison: consolidate connlimit grammar rule for set elements
      tests: shell: extend coverage for set element statements
      tests: shell: missing ct count elements in new set_stmt test
      expression: add __EXPR_MAX and use it to define EXPR_MAX
      optimize: incorrect comparison for reject statement
      optimize: compact bitmask matching in set/map
      src: transform flag match expression to binop expression from parser
      src: remove flagcmp expression
      json: disallow empty concatenation
      expression: initialize list of expression to silence gcc compile warning
      expression: incorrect assert() list_expr_to_binop
      parser_json: reject empty jump/goto chain
      parser_json: allow statement stateful statement only in set elements
      parser_json: bail out on malformed statement in set
      cache: prevent possible crash rule filter is NULL
      optimize: expand expression list when merging into concatenation
      optimize: invalidate merge in case of duplicated key in set/map
      parser_bison: add selector_expr rule to restrict typeof_expr
      build: Bump version to 1.1.2

Phil Sutter (8):
      tests: shell: Join arithmetic statements in maps/vmap_timeout
      json: Support typeof in set and map types
      tests: py: Fix for storing payload into missing file
      monitor: Recognize flowtable add/del events
      tests: monitor: Run in own netns
      tests: monitor: Become $PWD agnostic
      tests: shell: Add socat availability feature test
      tests: shell: Fix owner/0002-persist on aarch64

Xiao Liang (1):
      fib: Change data type of fib oifname to "ifname"


--J3iVo6MGJgsmpEN0--
