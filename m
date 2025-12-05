Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB5E3019C0;
	Fri,  5 Dec 2025 14:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764943878; cv=none; b=OQ1FE9HYFlanMcs92W/rvAjxLSTb3GXKOONtLYMj1oYHBwWsiBam2FP1TFKSUkBhdEMRJoQrpVO2HiJMwlNHg0InrLfglnhfwbBt7Y2RbYIUh69nl1BXIi4t3a05hm9COwZQOUOgxgMCpsQyr6RUkJ8wqw+rf5Udbzl06YYMhkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764943878; c=relaxed/simple;
	bh=9UFO7eLpw8bigL8daczZuSlb/8NtC8KMi7AhTrkMb6I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rnv/SDI7UtX5/xJ91/45aR/lcsKMec01rF/GkjMVG+SCh1GR1VTK/JJ8XhVr26t+EALgqXO6YMZCWloMeHayDBfH1dzIKzQ0M9Bk6vBt/vmH4PHaVYUS40HolOR9WZAQk63/nDG5s8aeErixTR424dqdEHh0iPn7lRaXU5kqaJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZvMeTDQI; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZvMeTDQI"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 689136059D;
	Fri,  5 Dec 2025 15:11:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764943863;
	bh=KnDNmXS7aQQAXCmf1CuquJ+3p3MpgXRkWi//YCtczCc=;
	h=Date:From:To:Cc:Subject:From;
	b=ZvMeTDQIXxOQg0w8igW1VLRSEJbdJX2UW1VQ8+U41IrEQ3U1FB1fmsQiBaTyNbipY
	 Ne8oB5wH9exUwoD2HqMt8dpmStiTahB8i3TMAOaxwctggc2Lp1I5d56oEFHb8NHfSq
	 VN1r/nEP4Z+5zxHNuePRQLSmPzQrv8p5i9cPxOLS+VtpUW/iAeQ5PbbXBz5Gf3GY+t
	 7Y+/nSBxavisETqB8eOrle7JsD2nwpY6AKeJxo8IOh6qy4/+f5nmkY2JtvRIMo9WUh
	 jffve9J7OZ1F5EvB9Rh5l8P4uTG2BALzdyvNfGBYaWaPOw8zoX5GxdKpR+LaIjE7Go
	 LXQBQutfC9gQQ==
Date: Fri, 5 Dec 2025 15:11:00 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Cc: netfilter-announce@lists.netfilter.org, lwn@lwn.net,
	netdev@vger.kernel.org
Subject: [ANNOUNCE] nftables 1.1.6 release
Message-ID: <aTLn9DVZSFeGN3IP@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hXluNPoobgnnRiTf"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


--hXluNPoobgnnRiTf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        nftables 1.1.6

This release contains fixes:

- Complete lightweight tunnel template support, including vxlan, geneve
  and erspan, eg.

       table netdev global {
              tunnel t1 {
                      id 10
                      ip saddr 192.168.2.10
                      ip daddr 192.168.2.11
                      sport 1025
                      dport 20020
                      ttl 1
                      erspan {
                              version 1
                              index 2
                      }
              }
 
              tunnel t2 {
                      id 10
                      ip saddr 192.168.3.10
                      ip daddr 192.168.3.11
                      sport 1025
                      dport 21021
                      ttl 1
                      erspan {
                              version 1
                              index 2
                      }
              }
   
              chain in {
                      type filter hook ingress device veth0 priority 0;
    
                      tunnel name ip saddr map { 10.141.10.12 : "t1", 10.141.10.13 : "t2" } fwd to erspan1
              }
       }

   You have to create the erspan1 interface before loading your ruleset.

       ip link add dev erspan1 type erspan external

- Support for wildcard in netdev hooks, eg. add a basechain to filter
  ingress traffic for all existing vlan devices:

       table netdev t {
              chain c {
                      type filter hook ingress devices = { "vlan*", "veth0" } priority filter; policy accept;
              }
       }

- Support to pass up bridge frame to the bridge device for local
  processing, eg. pass up all bridge frames for de:ad:00:00:be:ef
  to the IP stack:

    table bridge global {
            chain pre {
                    type filter hook prerouting priority 0; policy accept;
                    ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwaddr accept
            }
    }

  The new meta ibrhwaddr provides the bridge hardware address which
  can be used to mangle the destination address.

  This requires a Linux kernel >= 6.18.

- New afl++ (american fuzzy lop++) fuzzer infrastructure, enable it with:

        ./configure --with-fuzzer

  and read tests/afl++/README to build and run tools/nft-afl.

- fib expression incorrect bytecode for Big Endian.

  Instead of:

       [ fib saddr . iif oif present => reg 1 ]
       [ cmp eq reg 1 0x01000000 ]

  generate:

       [ fib saddr . iif oif present => reg 1 ]
       [ cmp eq reg 1 0x00000001 ]

  among other Big Endian fixes.

... and man nft(8) documentation updates and more small fixes.

See changelog for more details (attached to this email).

You can download this new release from:

https://www.netfilter.org/projects/nftables/downloads.html
https://www.netfilter.org/pub/nftables/

To build the code, libnftnl >= 1.3.1 and libmnl >= 1.0.4 are required:

* https://netfilter.org/projects/libnftnl/index.html
* https://netfilter.org/projects/libmnl/index.html

Visit our wikipage for user documentation at:

* https://wiki.nftables.org

For the manpage reference, check man(8) nft.

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling.

--hXluNPoobgnnRiTf
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="changes-nftables-1.1.6.txt"
Content-Transfer-Encoding: 8bit

Christoph Anton Mitterer (8):
      doc: clarify evaluation of chains
      doc: minor improvements with respect to the term “ruleset”
      doc: describe include’s collation order to be that of the C locale
      doc: fix/improve documentation of jump/goto/return
      doc: add more documentation on bitmasks and sets
      doc: add overall description of the ruleset evaluation
      doc: fix/improve documentation of verdicts
      doc: minor improvements the `reject` statement

Fernando Fernandez Mancera (7):
      tunnel: add vxlan support
      tunnel: add tunnel object and statement json support
      tests: add tunnel shell and python tests
      meta: introduce meta ibrhwaddr support
      tests: shell: add packetpath test for meta ibrhwaddr
      rule: add missing documentation for cmd_obj enum
      tunnel: add missing tunnel object list support

Florian Westphal (19):
      tests: shell: skip two bitwise tests if multi-register support isn't available
      tests: py: objects.t: must use input, not output
      src: tunnel: handle tunnel delete command
      tests: shell: add regression tests for set flush+add bugs
      tests: shell: fix name based checks with CONFIG_MODULES=n
      tests: shell: type_route_chain: use in-tree nftables, not system-wide one
      tests: shell: add packetpath test for reject statement
      evaluate: tunnel: don't assume src is set
      src: tunnel src/dst must be a symbolic expression
      src: parser_bison: prevent multiple ip daddr/saddr definitions
      evaluate: reject tunnel section if another one is already present
      src: fix fmt string warnings
      src: parser_json: fix format string bugs
      evaluate: follow prefix expression recursively if needed
      doc: remove queue from verdict list
      src: add refcount asserts
      support for afl++ (american fuzzy lop++) fuzzer
      src: move fuzzer functionality to separate tool
      build: unbreak 'make distcheck'

Georg Pfuetzenreuter (1):
      doc: fix tcpdump example

Gyorgy Sarvari (1):
      tests: shell: fix typo in vmap_timeout test script

Jeremy Sowden (2):
      doc: fix some man-page mistakes
      build: don't install ancillary files without systemd service file

Pablo Neira Ayuso (23):
      src: add tunnel template support
      tunnel: add erspan support
      src: add tunnel statement and expression support
      tunnel: add geneve support
      src: add expr_type_catchall() helper and use it
      src: replace compound_expr_add() by type safe set_expr_add()
      src: replace compound_expr_add() by type safe concat_expr_add()
      src: replace compound_expr_add() by type safe list_expr_add()
      segtree: rename set_compound_expr_add() to set_expr_add_splice()
      expression: replace compound_expr_clone() by type safe function
      expression: remove compound_expr_add()
      expression: replace compound_expr_remove() by type safe function
      expression: replace compound_expr_destroy() by type safe funtion
      expression: replace compound_expr_print() by type safe function
      src: replace compound_expr_alloc() by type safe function
      evaluate: simplify set to list normalisation for device expressions
      tests: shell: combine flowtable devices with variable expression
      parser_bison: remove leftover utf-8 character in error
      libnftables: do not re-add default include directory in include search path
      rule: skip CMD_OBJ_SETELEMS with no elements after set flush
      tests: shell: add device to sets/0075tunnel_0 to support older kernels
      tests: shell: refer to python3 in json prettify script
      build: Bump version to 1.1.6

Phil Sutter (38):
      table: Embed creating nft version into userdata
      tools: gitignore nftables.service file
      monitor: Quote device names in chain declarations, too
      tests: monitor: Label diffs to help users
      tests: monitor: Fix regex collecting expected echo output
      tests: monitor: Test JSON echo mode as well
      tests: monitor: Extend debug output a bit
      Makefile: Fix for 'make CFLAGS=...'
      mnl: Allow for updating devices on existing inet ingress hook chains
      monitor: Inform JSON printer when reporting an object delete event
      tests: monitor: Extend testcases a bit
      tests: monitor: Excercise all syntaxes and variants by default
      tests: py: Enable JSON and JSON schema by default
      tests: Prepare exit codes for automake
      tests: json_echo: Skip if run as non-root
      tests: shell: Skip packetpath/nat_ftp in fake root env
      tests: build: Do not assume caller's CWD
      tests: build: Avoid a recursive 'make check' run
      Makefile: Enable support for 'make check'
      fib: Fix for existence check on Big Endian
      mnl: Support simple wildcards in netdev hooks
      parser_bison: Accept ASTERISK_STRING in flowtable_expr_member
      tests: shell: Test ifname-based hooks
      mnl: Drop asterisk from end of NFTA_DEVICE_PREFIX strings
      datatype: Fix boolean type on Big Endian
      optimize: Fix verdict expression comparison
      tests: py: any/tcpopt.t.json: Fix JSON equivalent
      tests: py: any/ct.t.json.output: Drop leftover entry
      tests: py: inet/osf.t: Fix element ordering in JSON equivalents
      tests: py: Fix for using wrong payload path
      tests: py: Implement payload_record()
      tests: py: Do not rely upon '[end]' marker
      netlink: No need to reference array when passing as pointer
      datatype: Increase symbolic constant printer robustness
      tests: py: ip6/vmap.t: Drop double whitespace in rule
      netlink: Zero nft_data_linearize objects when populating
      utils: Cover for missing newline after BUG() messages
      doc: libnftables-json: Describe RULESET object

Ronan Pigott (1):
      doc: don't suggest to disable GSO

Yi Chen (1):
      tests: shell: add packetpath test for meta time expression.


--hXluNPoobgnnRiTf--
