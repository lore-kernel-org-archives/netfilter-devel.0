From: Kevin Cernekee <cernekee@chromium.org>
Subject: [RFC/PATCH 0/3] Fix ctnetlink regressions
Date: Mon, 16 Jan 2017 21:14:05 -0800
Message-ID: <1484630048-25416-1-git-send-email-cernekee@chromium.org>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

These patches address a problem I am seeing on Linux 4.4.  They do not
apply as-is to the master branch.  But I wanted to run them past the list
first to gather feedback on whether this is a reasonable approach.

I am using the user conntrack helpers from conntrackd on systems running
Linux 3.14, 3.18, and 4.4.  It was observed that conntrackd worked fine
on the 3.14/3.18 systems, but had no apparent effect on the 4.4 systems.
I tracked this down to a new check that was added in 4.4:

+       if (nfq_ct->parse(nfqa[NFQA_CT], ct) < 0)
+               return NULL;
+
+       if (nfqa[NFQA_EXP])
+               nfq_ct->attach_expect(nfqa[NFQA_EXP], ct,
+                                     NETLINK_CB(entry->skb).portid,
+                                     nlmsg_report(nlh));

Prior to 4.4, even if a netlink message failed the parse() checks, the
kernel would still run attach_expect() on it.  This masked a number of
failures.  With 4.4+, a sanity check failure on any attribute checked by
parse() will prevent the expectation from being created, which usually
breaks the conntrack helper.

In my testing I found that the sanity checks for CTA_TIMEOUT, CTA_STATUS,
and CTA_HELP were overly strict.  CTA_TIMEOUT may have been inadvertently
fixed in master (commit f330a7fdbe161), but I don't think the other two
are.  My proposal is to relax the checks so that existing user programs
do not break.

Another option is to simply ignore the parse() result, so that the
interface remains bug-compatible with old user code.


Kevin Cernekee (3):
  netfilter: ctnetlink: Fix regression in CTA_TIMEOUT processing
  netfilter: ctnetlink: Fix regression in CTA_STATUS processing
  netfilter: ctnetlink: Fix regression in CTA_HELP processing

 include/uapi/linux/netfilter/nf_conntrack_common.h |  4 +++
 net/netfilter/nf_conntrack_netlink.c               | 35 +++++++++++++---------
 2 files changed, 25 insertions(+), 14 deletions(-)

-- 
2.7.4
