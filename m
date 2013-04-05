From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/3] netfilter: propagate routing and XFRM errors
Date: Fri,  5 Apr 2013 18:41:09 +0200
Message-ID: <1365180072-6182-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

These patches fix a long standing annoyance: netfilter will return
EPERM for all errors during rerouting or XFRM policy lookups.

These patches change {ip,ip6}_route_me_harder() and nf_xfrm_me_harder()
to return errno codes and use NF_DROP_ERR() to propagate those back
to userspace.

Please apply.
