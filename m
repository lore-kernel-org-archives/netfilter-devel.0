From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/6 nft] improvements for the range printing
Date: Tue,  2 Jun 2015 19:03:01 +0200
Message-ID: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49733 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759324AbbFBQ6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 12:58:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

This patchset adds the routine to consolidate the range printing from the
delinearization step, so we get:

        tcp dport 1024-65535

instead of:

        tcp dport >= 1024 tcp dport 65535

Same thing with meta and ct selectors.

This applies on top of the next-4.1 branch that I'll merge asap to master to
start preparing the next 0.5 release.

Let me know if you have any concern, thanks.

Pablo Neira Ayuso (6):
  netlink_delinearize: pass ctx pointer to stmt_reject_postprocess()
  netlink_delinearize: keep pointer to current statement from rule_pp_ctx
  netlink_delinearize: add payload_match_expand()
  netlink_delinearize: consolidate range printing
  tests: regression: reduce code duplication a bit on error reporting
  tests: regression: fix warnings related to range listing

 src/netlink_delinearize.c         |  218 +++++++++++++++++++++++++------------
 tests/regression/any/ct.t         |   26 ++---
 tests/regression/any/frag.t       |   10 +-
 tests/regression/any/meta.t       |   43 ++++----
 tests/regression/arp/arp.t        |   14 +--
 tests/regression/inet/ah.t        |   16 +--
 tests/regression/inet/comp.t      |    8 +-
 tests/regression/inet/dccp.t      |   11 +-
 tests/regression/inet/esp.t       |    8 +-
 tests/regression/inet/sctp.t      |   16 +--
 tests/regression/inet/tcp.t       |   30 ++---
 tests/regression/inet/udp.t       |   20 ++--
 tests/regression/inet/udplite.t   |   18 +--
 tests/regression/ip/icmp.t        |   20 ++--
 tests/regression/ip/ip.t          |   38 +++----
 tests/regression/ip/masquerade.t  |    2 +-
 tests/regression/ip/nat.t         |   14 +--
 tests/regression/ip/redirect.t    |    2 +-
 tests/regression/ip6/dst.t        |    8 +-
 tests/regression/ip6/hbh.t        |    8 +-
 tests/regression/ip6/ip6.t        |   12 +-
 tests/regression/ip6/masquerade.t |    2 +-
 tests/regression/ip6/mh.t         |   18 +--
 tests/regression/ip6/redirect.t   |    2 +-
 tests/regression/ip6/rt.t         |   16 +--
 tests/regression/nft-test.py      |   19 ++--
 26 files changed, 337 insertions(+), 262 deletions(-)

--
1.7.10.4

