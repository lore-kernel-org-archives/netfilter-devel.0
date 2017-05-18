From: Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 0/6 RFC] Address NETFILTER_CFG issues
Date: Thu, 18 May 2017 13:21:46 -0400
Message-ID: <cover.1495124188.git.rgb@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>
To: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38496 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933489AbdERRWZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2017 13:22:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There were questions about the presence and cause of unsolicited syscall events
in the logs containing NETFILTER_CFG records and sometimes unaccompanied
NETFILTER_CFG records.

During testing at least the following list of events trigger NETFILTER_CFG
records and the syscalls related (There may be more events that will trigger
this message type.):
	init_module, finit_module: modprobe
	setsockopt: iptables-restore, ip6tables-restore, ebtables-restore
	unshare: (h?)ostnamed
	clone: libvirtd

The syscall events unsolicited by any audit rule were found to be caused by a
missing !audit_dummy_context() check before creating a NETFILTER_CFG record.
Check !audit_dummy_context() before creating the NETFILTER_CFG record.

The vast majority of unaccompanied records are caused by the fedora default
rule: "-a never,task" and the occasional early startup one is I believe caused
by the iptables filter table module hard linked into the kernel rather than a
loadable module. The !audit_dummy_context() check above should avoid them.

Seemingly duplicate records are not actually exact duplicates that are caused
by netfilter table initialization in different network namespaces from the same
syscall.  Recommend adding the network namespace ID (proc inode) to the record
to make this obvious.

Ebtables module initialization to register tables doesn't generate records
because it was never hooked in to audit.  Recommend adding audit hooks to log
this.

See: https://github.com/linux-audit/audit-kernel/issues/25
See: https://github.com/linux-audit/audit-kernel/issues/35
See: https://github.com/linux-audit/audit-kernel/issues/43


Richard Guy Briggs (6):
  netfilter: normalize x_table function declarations
  netfilter: normalize ebtables function declarations
  netfilter: audit only on xtables and ebtables syscall rule or
    standalone
  netfilter: ebtables: audit table registration
  netfilter: add audit operation field
  netfilter: add audit netns ID

 include/linux/audit.h              |    4 +-
 include/linux/netfilter/x_tables.h |    1 +
 include/uapi/linux/audit.h         |    1 +
 kernel/auditsc.c                   |    3 +-
 net/bridge/netfilter/ebtables.c    |  148 +++++++++++++++++++++++-------------
 net/ipv4/netfilter/arp_tables.c    |    2 +-
 net/ipv4/netfilter/ip_tables.c     |    2 +-
 net/ipv6/netfilter/ip6_tables.c    |    2 +-
 net/netfilter/x_tables.c           |   76 +++++++++++--------
 9 files changed, 149 insertions(+), 90 deletions(-)

