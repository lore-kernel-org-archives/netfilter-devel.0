From: Patrick McHardy <kaber@trash.net>
Subject: [RFC PATCH nft 0/6] flow statement
Date: Fri,  6 Nov 2015 18:34:17 +0000
Message-ID: <1446834863-18610-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:47966 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754095AbbKFSeb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 13:34:31 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patches add support for the flow statement, which allows to
dynamically instantiate stateful statements fow an arbitrary defined flow
key.

Currently we have to stateful statements, counter and limit. This example
shows some accounting possibilities using the counter statement. Please note
that the output format is still WIP and not included in this patchset:

# nft filter input flow table test iif . tcp flags counter
# nft list flow table filter test
iface_index	tcp_flag	statement
lo		fin | psh | urg	counter packets 1002 bytes 40080
wlp2s0		fin | ack	counter packets 3 bytes 156
wlp2s0		ack		counter packets 32 bytes 18440
wlp2s0		syn | ack 	counter packets 5 bytes 300
wlp2s0		psh | ack	counter packets 57 bytes 13804
lo		rst | ack	counter packets 998 bytes 39920

# nft filter output flow table uidacct skuid . oif . ip protocol counter
# nft list flow table filter uidacct
uid	iface_index	inet_proto	statement
root	wlp2s0		udp		counter packets 9 bytes 1892
root	wlp2s0		tcp		counter packets 5 bytes 348
chrony	wlp2s0		udp		counter packets 1 bytes 76
kaber	wlp2s0		tcp		counter packets 103 bytes 27038
kaber	wlp2s0		icmp		counter packets 2 bytes 168
kaber	wlp2s0		udp		counter packets 5 bytes 4267
kaber	lo		icmp		counter packets 4 bytes 336

For hashlimit, you'd use (in this example "srcip"-mode") to limit new ssh
connections to 10/second for each source IP:

# nft filter input tcp dport ssh ct state new \
	flow table ssh ip saddr limit 10/second

Timeouts, size limitations and all other set options are supported.

Regarding the missing parts, for proper formatting of the output and making
it sortable, we need to move direct output to printing to buffers. I have
patches which do that and also add generic indentation support, but they are
not suitable for upstream yet.

Comments welcome.

Cheers,
Patrick


Patrick McHardy (6):
  set: allow non-constant implicit set declarations
  set: explicitly supply name to implicit set declarations
  netlink_delinearize: support parsing individual expressions not
    embedded in rules
  set_elem: parse expressions attached to set elements
  stmt: allow to generate stateful statements outside of rule context
  nft: add flow statement

 include/expression.h                |   1 +
 include/linux/netfilter/nf_tables.h |   5 ++
 include/netlink.h                   |   5 +-
 include/rule.h                      |   1 +
 include/statement.h                 |  13 ++++
 src/evaluate.c                      |  48 ++++++++++++--
 src/expression.c                    |   6 ++
 src/netlink.c                       |   2 +
 src/netlink_delinearize.c           | 110 ++++++++++++++++++++++---------
 src/netlink_linearize.c             | 125 +++++++++++++++++++++++++-----------
 src/parser_bison.y                  |  38 +++++++++++
 src/scanner.l                       |   2 +
 src/statement.c                     |  43 ++++++++++++-
 13 files changed, 326 insertions(+), 73 deletions(-)

-- 
2.4.3

