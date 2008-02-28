From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/32]: SIP conntrack/NAT enhancements
Date: Thu, 28 Feb 2008 12:59:57 +0100 (MET)
Message-ID: <20080228115948.29267.34361.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49964 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105AbYB1L77 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Feb 2008 06:59:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've forward ported and slightly reworked my SIP conntrack patches
in order to prepare them for upstream merging. They will most likely
see a few more minor changes before getting merged, but they're ready
for testing and review already.


A rough overview of the patches:

- Cleanups, minor fixes

- Expectation classes for isolating different expectation types from
  each other (audio/video/signalling/...)

- Parser fixes: proper SIP and SDP parsing, dealing with SIP's strange
  whitespace rules, case-sensitivity, etc.

- Parser enhancements: support for more message types containing SDP
  messages, support for parsing header and URI parameters

- Expectations for signalling and RTCP connections

- (Optional) wildcard RTP expectations for RTP streams that originate
  from other hosts than the registrar/proxy

- Multiple media channel support (used for audio and video for now)

- NAT enhancements: replacement of text-based address translation by
  binary address translation, support for properly updating rport=,
  received= and maddr= Via-header parameters, support for properly
  translating all Contact: addresses

- RTP routing optmization: makes RTP streams between two "internal"
  endpoints go directly without NAT (only works if the proxy doesn't
  also proxy the RTP streams).

For a full description check out the individual changelog entries.


The old (before forward porting) patches have been tested extensively
in multiple different setups, assuming no bugs have been introduced
during forward porting (everything *seems* to work fine) they should
make the SIP helper work significantly better with multiple endpoints
behind the firewall and with a wider range of clients.

In case someone wants to do some testing, the conntrack module has two
new parameters controlling whether expectations for signalling and
RTP connections are set up with wildcards or only between the two
sides of the connection:

- sip_direct_signalling (default 1): expect signalling connections only
  from registrar

- sip_direct_media (default 1): expect media streams only from remote
  side of the connection

Depending on the setup, the defaults might be too strict and need to
be changed to zero.


A git tree with these patches is available at:

git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nf-2.6.26-sip.git

Patches, testing and comments welcome :)


 include/linux/netfilter.h                     |    9 +
 include/linux/netfilter/nf_conntrack_amanda.h |    6 +
 include/linux/netfilter/nf_conntrack_ftp.h    |    6 +
 include/linux/netfilter/nf_conntrack_h323.h   |   18 +
 include/linux/netfilter/nf_conntrack_irc.h    |    6 +
 include/linux/netfilter/nf_conntrack_pptp.h   |    6 +
 include/linux/netfilter/nf_conntrack_sane.h   |    6 +
 include/linux/netfilter/nf_conntrack_sip.h    |  185 +++-
 include/linux/netfilter/nf_conntrack_tftp.h   |    6 +
 include/net/netfilter/nf_conntrack.h          |    7 +-
 include/net/netfilter/nf_conntrack_expect.h   |   20 +-
 include/net/netfilter/nf_conntrack_helper.h   |    5 +-
 include/net/netfilter/nf_conntrack_tuple.h    |   53 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c            |    2 +-
 net/ipv4/netfilter/nf_nat_sip.c               |  556 +++++++----
 net/ipv4/netfilter/nf_nat_snmp_basic.c        |   22 +-
 net/netfilter/nf_conntrack_amanda.c           |   18 +-
 net/netfilter/nf_conntrack_expect.c           |   81 +-
 net/netfilter/nf_conntrack_ftp.c              |   13 +-
 net/netfilter/nf_conntrack_h323_main.c        |   68 +-
 net/netfilter/nf_conntrack_helper.c           |    3 +-
 net/netfilter/nf_conntrack_irc.c              |   10 +-
 net/netfilter/nf_conntrack_netbios_ns.c       |   18 +-
 net/netfilter/nf_conntrack_pptp.c             |   17 +-
 net/netfilter/nf_conntrack_sane.c             |   14 +-
 net/netfilter/nf_conntrack_sip.c              | 1401 ++++++++++++++++++++-----
 net/netfilter/nf_conntrack_tftp.c             |   14 +-
 27 files changed, 1976 insertions(+), 594 deletions(-)

Patrick McHardy (32):
      [NETFILTER]: ipt_CLUSTERIP: fix non-existant macro-name
      [NETFILTER]: nf_conntrack: fix NF_CT_TUPLE_DUMP for IPv4
      [NETFILTER]: nf_conntrack_expect: constify nf_ct_expect_init arguments
      [NETFILTER]: nf_conntrack_expect: show NF_CT_EXPECT_PERMANENT flag in /proc
      [NETFILTER]: nf_conntrack_expect: support inactive expectations
      [NETFILTER]: nf_conntrack: introduce expectation classes and policies
      [NETFILTER]: Add nf_inet_addr_cmp()
      [NETFILTER]: nf_conntrack_sip: fix IPv6 address parsing
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
