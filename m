From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next RFC 0/5] netfilter: add net namespace support for cthelper
Date: Sun,  4 Jun 2017 23:25:04 +0800
Message-ID: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@163.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:51133 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751218AbdFDPZm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jun 2017 11:25:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch set aims to add net namespace support for the ct helper,
it is a little large, but I try my best to split them to a relative
smaller patches, which will help to review. Comments are welcome.

Actually, I split the whole thing into 4 parts:
1. make nf_conntrack_helper_register become per-net, this is
   done by patch #1 and #2
2. filter ct helper by netns, done by patch #3
3. support netns for the user cthelper by patch #4
4. support netns for the kernel built-in cthelper, done by patch #5

Last, I use the following commands to do test, running about 0.5 hour.
And no exceptions found, i.e. no OOPS or no memory leak reported:

while : ; do
  ip netns add test1
  ip netns exec test1 nfct add helper ssdp inet udp
  ip netns exec test1 iptables -w -t raw -I OUTPUT -p udp -j CT --helper ssdp
  ip netns delete test1
done

while : ; do
  modprobe nf_conntrack_sip "ports=111,222"
  modprobe nf_conntrack_ftp "ports=444,555"
  modprobe nf_conntrack_tftp
  ip netns add test2
  ip netns exec test2 iptables -w -t raw -I OUTPUT -p tcp -j CT --helper ftp-444
  ip netns delete test2
  iptables -w -t raw -I OUTPUT -p udp -j CT --helper sip-0
  iptables -w -t raw -D OUTPUT -p udp -j CT --helper sip-0
  rmmod nf_conntrack_sip
  rmmod nf_conntrack_ftp
  rmmod nf_conntrack_tftp
done

Liping Zhang (5):
  netfilter: use nf_conntrack_helpers_register when possible
  netfilter: make nf_conntrack_helper_register become per-net
  netfilter: make each ct helper belong to a specific netns
  netfilter: complete the netns support for the user cthelpers
  netfilter: complete the netns support for the kernel built-in
    cthelpers

 include/net/netfilter/nf_conntrack_helper.h |  44 ++++++--
 include/net/netns/conntrack.h               |   5 +
 net/ipv4/netfilter/nf_nat_snmp_basic.c      |  19 +++-
 net/netfilter/nf_conntrack_amanda.c         |  27 +++--
 net/netfilter/nf_conntrack_ftp.c            |  19 +++-
 net/netfilter/nf_conntrack_h323_main.c      |  70 ++++++++-----
 net/netfilter/nf_conntrack_helper.c         | 155 ++++++++++++++++++++++------
 net/netfilter/nf_conntrack_irc.c            |  19 +++-
 net/netfilter/nf_conntrack_netbios_ns.c     |  19 +++-
 net/netfilter/nf_conntrack_netlink.c        |  15 +--
 net/netfilter/nf_conntrack_pptp.c           |  19 +++-
 net/netfilter/nf_conntrack_sane.c           |  19 +++-
 net/netfilter/nf_conntrack_sip.c            |  19 +++-
 net/netfilter/nf_conntrack_snmp.c           |  19 +++-
 net/netfilter/nf_conntrack_tftp.c           |  19 +++-
 net/netfilter/nfnetlink_cthelper.c          |  70 +++++++++----
 net/netfilter/nft_ct.c                      |  12 ++-
 net/netfilter/xt_CT.c                       |   3 +-
 net/openvswitch/conntrack.c                 |   7 +-
 19 files changed, 452 insertions(+), 127 deletions(-)

-- 
2.5.5


