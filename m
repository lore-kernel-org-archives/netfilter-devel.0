From: Martin Topholm <mph@one.com>
Subject: [PATCH 0/2] Netfilter SYNPROXY mss and wscale bugfix
Date: Thu, 14 Nov 2013 15:35:29 +0100
Message-ID: <1384439731-16296-1-git-send-email-mph@one.com>
Cc: brouer@redhat.com, kaber@trash.net,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The following series fixes two bugs we have discovered in the netfilter
module SYNPROXY.

The first is related to the mss option not getting transferred to the
backend servers.

And the second it related to passing of the windows scaling option.

Martin Topholm (2):
  netfilter: synproxy: send mss option to backend
  netfilter: synproxy: correct wscale option passing

 net/ipv4/netfilter/ipt_SYNPROXY.c  | 1 +
 net/ipv6/netfilter/ip6t_SYNPROXY.c | 1 +
 net/netfilter/nf_synproxy_core.c   | 7 ++++---
 3 files changed, 6 insertions(+), 3 deletions(-)
