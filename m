From: tim.gardner@canonical.com
Subject: [PATCH 0/3] nf-next-2.6 pull request, Complete deprecation of CONFIG_NF_CT_ACCT (V2)
Date: Tue, 22 Jun 2010 10:44:32 -0600
Message-ID: <1277225075-30428-1-git-send-email-tim.gardner@canonical.com>
Cc: netfilter-devel@vger.kernel.org, ole@ans.pl
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:2226 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374Ab0FVQpn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 12:45:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
 include/net/netfilter/nf_conntrack.h       |   12 ++++++++++++
 net/netfilter/Kconfig                      |   22 ----------------------
 net/netfilter/nf_conntrack_acct.c          |   10 ----------
 net/netfilter/xt_connbytes.c               |   13 ++++++++++++-
 6 files changed, 25 insertions(+), 44 deletions(-)

