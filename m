Return-Path: <SRS0=u4Sz=45=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07D6C1975A
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Mar 2020 19:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D931E20674
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Mar 2020 19:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgCLTTG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Mar 2020 15:19:06 -0400
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:55542 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726553AbgCLTTG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Mar 2020 15:19:06 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 2019A837F27B;
        Thu, 12 Mar 2020 19:19:05 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: iron54_6c49d87829722
X-Filterd-Recvd-Size: 3313
Received: from joe-laptop.perches.com (unknown [47.151.143.254])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Thu, 12 Mar 2020 19:19:04 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     dri-devel@lists.freedesktop.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] treewide: Convert unscriptable /* fallthrough */ comments to fallthrough;
Date:   Thu, 12 Mar 2020 12:17:11 -0700
Message-Id: <cover.1584040050.git.joe@perches.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Several files in the kernel can not be perfectly scripted to convert
/* fallthrough */ style comments to fallthrough; because the direct
scripted conversion causes gcc to emit warnings because the fallthrough;
marking is outside of an #ifdef/#endif block.

e.g.:
	switch (foo) {
	#ifdef CONFIG_BAR
	case BAR:
	     ...
	#endif
	/* fallthrough */
	case BAZ:
	     ...
	}

is converted via script to

	switch (foo) {
	#ifdef CONFIG_BAR
	case BAR:
	     ...
	#endif
	fallthrough;
	case BAZ:
	     ...
	}

gcc emits a warning for the bare fallthrough; before case BAZ: when
CONFIG_BAR is not enabled.

So moving the fallthrough; conversions inside the #ifdef/#endif block
avoids this warning.

These are the only warnings emitted on a treewide scripted conversion as
found by the kernel-robot so applying these patches allows a treewide
conversion, either as multiple discrete patches or a single large patch
to eventually be done.

Joe Perches (3):
  drm: drm_vm: Use fallthrough;
  net: [IPv4/IPv6]: Use fallthrough;
  virt: vbox: Use fallthrough;

 drivers/gpu/drm/drm_vm.c                 | 4 ++--
 drivers/virt/vboxguest/vboxguest_core.c  | 2 +-
 drivers/virt/vboxguest/vboxguest_utils.c | 2 +-
 net/ipv4/af_inet.c                       | 4 ++--
 net/ipv4/ah4.c                           | 2 +-
 net/ipv4/arp.c                           | 2 +-
 net/ipv4/devinet.c                       | 6 +++---
 net/ipv4/fib_semantics.c                 | 4 ++--
 net/ipv4/icmp.c                          | 2 +-
 net/ipv4/ip_output.c                     | 2 +-
 net/ipv4/ipmr.c                          | 2 +-
 net/ipv4/netfilter/nf_log_ipv4.c         | 2 +-
 net/ipv4/netfilter/nf_nat_pptp.c         | 4 ++--
 net/ipv4/nexthop.c                       | 2 +-
 net/ipv4/tcp.c                           | 2 +-
 net/ipv4/tcp_input.c                     | 6 +++---
 net/ipv4/tcp_ipv4.c                      | 4 ++--
 net/ipv4/udp.c                           | 2 +-
 net/ipv6/addrconf.c                      | 6 ++----
 net/ipv6/ah6.c                           | 2 +-
 net/ipv6/exthdrs.c                       | 2 +-
 net/ipv6/icmp.c                          | 2 +-
 net/ipv6/ip6_fib.c                       | 8 ++++----
 net/ipv6/ip6mr.c                         | 2 +-
 net/ipv6/ndisc.c                         | 2 +-
 net/ipv6/netfilter/nf_log_ipv6.c         | 2 +-
 net/ipv6/raw.c                           | 8 ++++----
 net/ipv6/route.c                         | 2 +-
 net/ipv6/tcp_ipv6.c                      | 2 +-
 29 files changed, 45 insertions(+), 47 deletions(-)

-- 
2.24.0

