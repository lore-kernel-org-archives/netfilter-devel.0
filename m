From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 0/4] netfilter: request related nf_log module when we add TRACE rule
Date: Wed,  8 Jun 2016 20:43:16 +0800
Message-ID: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:32930 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbcFHMoG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 08:44:06 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

This patch set solve such problem, for example, if we add a following
iptables rule:
  # iptables -t raw -I PREROUTING -j TRACE
And nf_log_ipv4 kernel module is not installed, no trace log
will be generated, until we install the nf_log_ipv4 module manully.

This is not friendly, so we add nf_logger_find_get call explicitly
when xt_TRACE target is created. Nft nftrace meta has the same
problem.

And in order to avoid special treatment of NFPROTO_INET family again
and again, I move the special logic to the inside of nf_logger_find_get
and nf_logger_put, so caller can ignore it. 

Liping Zhang (4):
  netfilter: nf_log: handle NFPROTO_INET properly in
    nf_logger_[find_get|put]
  netfilter: nft_log: no need to deal with NFPROTO_INET family
  netfilter: xt_TRACE: add explicitly nf_logger_find_get call
  netfilter: nft_meta: add explicitly nf_logger_find_get call

 net/netfilter/nf_log.c   | 20 ++++++++++++++++++++
 net/netfilter/nft_log.c  | 21 +--------------------
 net/netfilter/nft_meta.c | 12 ++++++++++--
 net/netfilter/xt_TRACE.c | 25 +++++++++++++++++++------
 4 files changed, 50 insertions(+), 28 deletions(-)

-- 
2.5.5


