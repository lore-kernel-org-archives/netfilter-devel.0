From: Jan Engelhardt <jengelh@medozas.de>
Subject: [0/5] xtables: phase out case sensitivity
Date: Tue, 18 Jan 2011 16:38:55 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Aaron Wright <wright_left@yahoo.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38324 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1ARPi4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:38:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


bug report http://bugzilla.netfilter.org/show_bug.cgi?id=694 , though
being written in a heated fashion, did prompt me to revisit the
actual issue. While I have to question why users are relying on
inferior filesystems (the issue was raised before on the lists), I
feel inclined to solve bugs.

So here is a proposed patchset that starts the migration. Since iptables 
userspace looks modules up by protocol anyway, it continues to work. The 
only thing is headers, which is merely a build time thing and, as has 
itself shown in the past years, no deal. Within the usual grace period 
of 1-1.5 years (or even sooner than usual - since userspace has its own 
copies of headers), the netfilter/ dirs can be completely case-free.

---

The following changes since commit 0b8ad876275c74e4bfb6ec3150793f3c0ecfcee2:

  netfilter: xtables: add missing header files to export list (2011-01-18 11:25:02 +0100)

are available in the git repository at:
  git://dev.medozas.de/linux master

Jan Engelhardt (5):
      netfilter: xtables: avoid case-sensitive filenames (1/5)
      netfilter: xtables: case-sensitivity avoidance (2/5)
      netfilter: xtables: case-sensitivity avoidance (3/5)
      netfilter: xtables: case-sensitivity avoidance (4/5)
      netfilter: xtables: case-sensitivity avoidance (5/5)

 Documentation/feature-removal-schedule.txt         |   10 ++++
 include/linux/netfilter/Kbuild                     |   42 ++++++++------
 include/linux/netfilter/xt_AUDIT.h                 |   31 +----------
 include/linux/netfilter/xt_CHECKSUM.h              |   21 +-------
 include/linux/netfilter/xt_CLASSIFY.h              |   11 +----
 include/linux/netfilter/xt_CONNSECMARK.h           |   16 +-----
 include/linux/netfilter/xt_CT.h                    |   18 +------
 include/linux/netfilter/xt_DSCP.h                  |   25 ---------
 include/linux/netfilter/xt_IDLETIMER.h             |   46 +---------------
 include/linux/netfilter/xt_LED.h                   |   16 +-----
 include/linux/netfilter/xt_NFLOG.h                 |   21 +-------
 include/linux/netfilter/xt_NFQUEUE.h               |   24 +--------
 include/linux/netfilter/xt_RATEEST.h               |   16 +-----
 include/linux/netfilter/xt_SECMARK.h               |   23 +--------
 include/linux/netfilter/xt_TCPMSS.h                |   13 +----
 include/linux/netfilter/xt_TCPOPTSTRIP.h           |   14 +-----
 include/linux/netfilter/xt_TEE.h                   |   13 +----
 include/linux/netfilter/xt_TPROXY.h                |   22 +-------
 include/linux/netfilter/xt_audit.h                 |   30 ++++++++++
 include/linux/netfilter/xt_checksum.h              |   20 +++++++
 include/linux/netfilter/xt_classify.h              |   10 ++++
 include/linux/netfilter/xt_clusterip.h             |   34 ++++++++++++
 include/linux/netfilter/xt_connsecmark.h           |   15 +++++
 include/linux/netfilter/xt_ct.h                    |   17 ++++++
 include/linux/netfilter/xt_dscp.h                  |   10 ++++
 include/linux/netfilter/xt_ecn.h                   |   49 +++++++++++++++++
 include/linux/netfilter/xt_hl.h                    |   58 ++++++++++++++++++++
 include/linux/netfilter/xt_idletimer.h             |   45 +++++++++++++++
 include/linux/netfilter/xt_led.h                   |   15 +++++
 include/linux/netfilter/xt_log.h                   |   34 ++++++++++++
 include/linux/netfilter/xt_nflog.h                 |   20 +++++++
 include/linux/netfilter/xt_nfqueue.h               |   23 ++++++++
 include/linux/netfilter/xt_rateest.h               |    9 +++
 include/linux/netfilter/xt_reject.h                |   34 ++++++++++++
 include/linux/netfilter/xt_same.h                  |   18 ++++++
 include/linux/netfilter/xt_secmark.h               |   22 ++++++++
 include/linux/netfilter/xt_tcpmss.h                |    6 ++
 include/linux/netfilter/xt_tcpoptstrip.h           |   13 +++++
 include/linux/netfilter/xt_tee.h                   |   12 ++++
 include/linux/netfilter/xt_tproxy.h                |   21 +++++++
 include/linux/netfilter/xt_ulog.h                  |   49 +++++++++++++++++
 include/linux/netfilter_ipv4/Kbuild                |   12 +---
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h       |   35 +------------
 include/linux/netfilter_ipv4/ipt_ECN.h             |   32 +-----------
 include/linux/netfilter_ipv4/ipt_LOG.h             |   20 +-------
 include/linux/netfilter_ipv4/ipt_REJECT.h          |   21 +-------
 include/linux/netfilter_ipv4/ipt_SAME.h            |   19 +------
 include/linux/netfilter_ipv4/ipt_TTL.h             |   22 +-------
 include/linux/netfilter_ipv4/ipt_ULOG.h            |   50 +-----------------
 include/linux/netfilter_ipv4/ipt_ecn.h             |   34 +-----------
 include/linux/netfilter_ipv4/ipt_ttl.h             |   22 +-------
 include/linux/netfilter_ipv6/Kbuild                |    6 +--
 include/linux/netfilter_ipv6/ip6t_HL.h             |   23 +--------
 include/linux/netfilter_ipv6/ip6t_LOG.h            |   20 +-------
 include/linux/netfilter_ipv6/ip6t_REJECT.h         |   19 +------
 include/linux/netfilter_ipv6/ip6t_hl.h             |   23 +--------
 net/ipv4/netfilter/Makefile                        |   16 +++---
 net/ipv4/netfilter/ipt_ecn.c                       |    2 +-
 .../netfilter/{ipt_CLUSTERIP.c => xt_clusterip.c}  |    3 +-
 net/ipv4/netfilter/{ipt_ECN.c => xt_ecn_tg.c}      |    3 +-
 net/ipv4/netfilter/{ipt_LOG.c => xt_log_ipv4.c}    |    3 +-
 .../{ipt_MASQUERADE.c => xt_masquerade.c}          |    1 +
 net/ipv4/netfilter/{ipt_NETMAP.c => xt_netmap.c}   |    1 +
 .../netfilter/{ipt_REDIRECT.c => xt_redirect.c}    |    0
 .../netfilter/{ipt_REJECT.c => xt_reject_ipv4.c}   |    3 +-
 net/ipv4/netfilter/{ipt_ULOG.c => xt_ulog.c}       |    3 +-
 net/ipv6/netfilter/Makefile                        |    4 +-
 net/ipv6/netfilter/{ip6t_LOG.c => xt_log_ipv6.c}   |    3 +-
 .../netfilter/{ip6t_REJECT.c => xt_reject_ipv6.c}  |    3 +-
 net/netfilter/Makefile                             |   38 +++++++-------
 net/netfilter/{xt_AUDIT.c => xt_audit.c}           |    2 +-
 net/netfilter/{xt_CHECKSUM.c => xt_checksum.c}     |    2 +-
 net/netfilter/{xt_CLASSIFY.c => xt_classify.c}     |    2 +-
 .../{xt_CONNSECMARK.c => xt_connsecmark.c}         |    2 +-
 net/netfilter/{xt_CT.c => xt_ct.c}                 |    2 +-
 net/netfilter/{xt_DSCP.c => xt_dscp_tg.c}          |    2 +-
 net/netfilter/xt_hl.c                              |    3 +-
 net/netfilter/{xt_HL.c => xt_hl_tg.c}              |    3 +-
 net/netfilter/{xt_IDLETIMER.c => xt_idletimer.c}   |    2 +-
 net/netfilter/{xt_LED.c => xt_led.c}               |    2 +-
 net/netfilter/{xt_NFLOG.c => xt_nflog.c}           |    2 +-
 net/netfilter/{xt_NFQUEUE.c => xt_nfqueue.c}       |    2 +-
 net/netfilter/{xt_NOTRACK.c => xt_notrack.c}       |    0
 net/netfilter/{xt_RATEEST.c => xt_rateest_tg.c}    |    2 +-
 net/netfilter/{xt_SECMARK.c => xt_secmark.c}       |    2 +-
 net/netfilter/{xt_TCPMSS.c => xt_tcpmss_tg.c}      |    2 +-
 .../{xt_TCPOPTSTRIP.c => xt_tcpoptstrip.c}         |    2 +-
 net/netfilter/{xt_TEE.c => xt_tee.c}               |    2 +-
 net/netfilter/{xt_TPROXY.c => xt_tproxy.c}         |    2 +-
 net/netfilter/{xt_TRACE.c => xt_trace.c}           |    0
 90 files changed, 695 insertions(+), 730 deletions(-)
 create mode 100644 include/linux/netfilter/xt_audit.h
 create mode 100644 include/linux/netfilter/xt_checksum.h
 create mode 100644 include/linux/netfilter/xt_classify.h
 create mode 100644 include/linux/netfilter/xt_clusterip.h
 create mode 100644 include/linux/netfilter/xt_connsecmark.h
 create mode 100644 include/linux/netfilter/xt_ct.h
 create mode 100644 include/linux/netfilter/xt_ecn.h
 create mode 100644 include/linux/netfilter/xt_hl.h
 create mode 100644 include/linux/netfilter/xt_idletimer.h
 create mode 100644 include/linux/netfilter/xt_led.h
 create mode 100644 include/linux/netfilter/xt_log.h
 create mode 100644 include/linux/netfilter/xt_nflog.h
 create mode 100644 include/linux/netfilter/xt_nfqueue.h
 create mode 100644 include/linux/netfilter/xt_reject.h
 create mode 100644 include/linux/netfilter/xt_same.h
 create mode 100644 include/linux/netfilter/xt_secmark.h
 create mode 100644 include/linux/netfilter/xt_tcpoptstrip.h
 create mode 100644 include/linux/netfilter/xt_tee.h
 create mode 100644 include/linux/netfilter/xt_tproxy.h
 create mode 100644 include/linux/netfilter/xt_ulog.h
 rename net/ipv4/netfilter/{ipt_CLUSTERIP.c => xt_clusterip.c} (99%)
 rename net/ipv4/netfilter/{ipt_ECN.c => xt_ecn_tg.c} (98%)
 rename net/ipv4/netfilter/{ipt_LOG.c => xt_log_ipv4.c} (99%)
 rename net/ipv4/netfilter/{ipt_MASQUERADE.c => xt_masquerade.c} (99%)
 rename net/ipv4/netfilter/{ipt_NETMAP.c => xt_netmap.c} (99%)
 rename net/ipv4/netfilter/{ipt_REDIRECT.c => xt_redirect.c} (100%)
 rename net/ipv4/netfilter/{ipt_REJECT.c => xt_reject_ipv4.c} (98%)
 rename net/ipv4/netfilter/{ipt_ULOG.c => xt_ulog.c} (99%)
 rename net/ipv6/netfilter/{ip6t_LOG.c => xt_log_ipv6.c} (99%)
 rename net/ipv6/netfilter/{ip6t_REJECT.c => xt_reject_ipv6.c} (99%)
 rename net/netfilter/{xt_AUDIT.c => xt_audit.c} (99%)
 rename net/netfilter/{xt_CHECKSUM.c => xt_checksum.c} (97%)
 rename net/netfilter/{xt_CLASSIFY.c => xt_classify.c} (97%)
 rename net/netfilter/{xt_CONNSECMARK.c => xt_connsecmark.c} (98%)
 rename net/netfilter/{xt_CT.c => xt_ct.c} (99%)
 rename net/netfilter/{xt_DSCP.c => xt_dscp_tg.c} (99%)
 rename net/netfilter/{xt_HL.c => xt_hl_tg.c} (97%)
 rename net/netfilter/{xt_IDLETIMER.c => xt_idletimer.c} (99%)
 rename net/netfilter/{xt_LED.c => xt_led.c} (99%)
 rename net/netfilter/{xt_NFLOG.c => xt_nflog.c} (97%)
 rename net/netfilter/{xt_NFQUEUE.c => xt_nfqueue.c} (98%)
 rename net/netfilter/{xt_NOTRACK.c => xt_notrack.c} (100%)
 rename net/netfilter/{xt_RATEEST.c => xt_rateest_tg.c} (99%)
 rename net/netfilter/{xt_SECMARK.c => xt_secmark.c} (98%)
 rename net/netfilter/{xt_TCPMSS.c => xt_tcpmss_tg.c} (99%)
 rename net/netfilter/{xt_TCPOPTSTRIP.c => xt_tcpoptstrip.c} (98%)
 rename net/netfilter/{xt_TEE.c => xt_tee.c} (99%)
 rename net/netfilter/{xt_TPROXY.c => xt_tproxy.c} (99%)
 rename net/netfilter/{xt_TRACE.c => xt_trace.c} (100%)
