From: Patrick McHardy <kaber@trash.net>
Subject: [METFILTER 00/32]: SIP helper update
Date: Tue, 25 Mar 2008 15:14:50 +0100 (MET)
Message-ID: <20080325141450.10539.58908.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32886 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYCYOOx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 10:14:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Dave,

these patches for 2.6.26 contain a large update for the SIP connection
tracking helper, fixing a number of issues with the current helper and
improving robustness. A rough overview of the patches follows, the
details are in the individual changelog entries:

- Fix NAT mapping setup order to make the NAT core properly detect
  clashes with existing connections

- Properly adjust the data pointer and length after packet mangling

- Parser enhancements: follow specification more closely (case
  sensitivity, header encoding, whitespace rules, ...)

- Optionally create signalling expectations for incoming calls from
  other endpoints than the registrar

- Support for RTCP expectations and multiple media channels

- Optionally create wildcard RTP/RTCP expectations for incoming media
  from other peers than the registrar

- "Expectation classes" for isolating signalling, audio and video
  expectations from each other

- Replacement of text-based header translation in NAT helper by binary
  address translation, support for updating rport=, received= and
  mport= Via-parameters

- RTP routing optimization for making RTP streams between two "internal"
  endpoints flow directly between the two endpoints in case the (external)
  registrar tries to make direct RTP setup

The patches are also available in a git-tree for your convencience at:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.26-sip.git

Please apply or pull, thanks.


 include/linux/netfilter.h                   |    9 +
 include/linux/netfilter/nf_conntrack_sip.h  |  185 +++-
 include/net/netfilter/nf_conntrack.h        |    7 +-
 include/net/netfilter/nf_conntrack_expect.h |   22 +-
 include/net/netfilter/nf_conntrack_helper.h |    5 +-
 include/net/netfilter/nf_conntrack_tuple.h  |   53 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c          |    2 +-
 net/ipv4/netfilter/nf_nat_sip.c             |  556 +++++++----
 net/ipv4/netfilter/nf_nat_snmp_basic.c      |   12 +-
 net/netfilter/nf_conntrack_amanda.c         |   14 +-
 net/netfilter/nf_conntrack_expect.c         |   81 ++-
 net/netfilter/nf_conntrack_ftp.c            |   10 +-
 net/netfilter/nf_conntrack_h323_main.c      |   66 +-
 net/netfilter/nf_conntrack_helper.c         |    3 +-
 net/netfilter/nf_conntrack_irc.c            |   10 +-
 net/netfilter/nf_conntrack_netbios_ns.c     |    9 +-
 net/netfilter/nf_conntrack_pptp.c           |   14 +-
 net/netfilter/nf_conntrack_sane.c           |   11 +-
 net/netfilter/nf_conntrack_sip.c            | 1386 +++++++++++++++++++++------
 net/netfilter/nf_conntrack_tftp.c           |   11 +-
 20 files changed, 1877 insertions(+), 589 deletions(-)

Patrick McHardy (32):
      [NETFILTER]: ipt_CLUSTERIP: fix non-existant macro-name
      [NETFILTER]: nf_conntrack: fix NF_CT_TUPLE_DUMP for IPv4
      [NETFILTER]: nf_conntrack_expect: constify nf_ct_expect_init arguments
      [NETFILTER]: nf_conntrack_expect: show NF_CT_EXPECT_PERMANENT flag in /proc
      [NETFILTER]: nf_conntrack_expect: support inactive expectations
      [NETFILTER]: nf_conntrack: introduce expectation classes and policies
      [NETFILTER]: Add nf_inet_addr_cmp()
      [NETFILTER]: nf_nat_sip: fix NAT setup order
      [NETFILTER]: nf_conntrack_sip: fix some off-by-ones
      [NETFILTER]: nf_conntrack_sip: adjust dptr and datalen after packet mangling
      [NETFILTER]: nf_conntrack_sip: remove redundant function arguments
      [NETFILTER]: nf_conntrack_sip: use strlen/strcmp
      [NETFILTER]: nf_conntrack_sip: add seperate SDP header parsing function
      [NETFILTER]: nf_conntrack_sip: kill request URI "header" definitions
      [NETFILTER]: nf_conntrack_sip: parse SIP headers properly
      [NETFILTER]: nf_conntrack_sip: introduce SIP-URI parsing helper
      [NETFILTER]: nf_nat_sip: get rid of text based header translation
      [NETFILTER]: nf_conntrack_sip: move SDP parsing to seperate function
      [NETFILTER]: nf_conntrack_sip: support method specific request/response handling
      [NETFILTER]: nf_conntrack_sip: perform NAT after parsing
      [NETFILTER]: nf_conntrack_sip: process ACK and PRACK methods
      [NETFILTER]: nf_conntrack_sip: flush expectations on call termination
      [NETFILTER]: nf_conntrack_sip: introduce URI and header parameter parsing helpers
      [NETFILTER]: nf_nat_sip: translate all Via headers
      [NETFILTER]: nf_nat_sip: translate all Contact headers
      [NETFILTER]: nf_conntrack_sip: create signalling expectations
      [NETFILTER]: nf_conntrack_sip: allow media expectations with wildcard source address
      [NETFILTER]: nf_conntrack_sip: create RTCP expectations
      [NETFILTER]: nf_nat_sip: split up SDP mangling
      [NETFILTER]: nf_conntrack_sip: support multiple media channels
      [NETFILTER]: nf_conntrack_sip: RTP routing optimization
      [NETFILTER]: nf_conntrack_sip: update copyright
