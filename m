From: Tim Gardner <tim.gardner@canonical.com>
Subject: nf-next-2.6 pull request, Complete deprecation of CONFIG_NF_CT_ACCT (V3)
Date: Thu, 24 Jun 2010 09:27:34 -0600
Message-ID: <1277393257-15281-1-git-send-email-tim.gardner@canonical.com>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2881 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab0FXP2M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:28:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series of patches checks CT accounting state at rule instantiation
time (as suggested).  I'm slightly concerned about the case where
the sysctl could be toggled after the xt_connbytes rule is loaded,
but I guess the user better know what he/she is doing.

I also moved the accounting state/toggle functions into the proper
header nf_conntrack_acct.h.

Finally, the 3rd patch removes all traces of CONFIG_NF_CT_ACCT.

The following changes since commit fe6fb552858f686f39e33d7b0a33fe56dacea0bf:
  Arnd Hannemann (1):
        netfilter: fix simple typo in KConfig for netfiltert xt_TEE

are available in the git repository at:

  git://kernel.ubuntu.com/rtg/nf-next-2.6 CONFIG_NF_CT_ACCT

Tim Gardner (3):
      netfilter: Expose connection tracking accounting toggles
      netfilter: xt_connbytes: Force CT accounting to be enabled
      netfilter: Complete the deprecation of CONFIG_NF_CT_ACCT

 Documentation/feature-removal-schedule.txt |    9 ---------
 Documentation/kernel-parameters.txt        |    3 +--
 include/net/netfilter/nf_conntrack_acct.h  |   12 ++++++++++++
 net/netfilter/Kconfig                      |   22 ----------------------
 net/netfilter/nf_conntrack_acct.c          |   10 ----------
 net/netfilter/xt_connbytes.c               |   10 ++++++++++
 6 files changed, 23 insertions(+), 43 deletions(-)

