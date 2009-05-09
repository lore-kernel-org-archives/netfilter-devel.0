From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter fix for 2.6.30-rc
Date: Sat, 09 May 2009 20:45:37 +0200
Message-ID: <20090509184316.7636.12044.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59795 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbZEISpu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 May 2009 14:45:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick!

The following is a fix for DCCP support, we are not currently
including the protocol state in the event messages.

---

Pablo Neira Ayuso (1):
      netfilter: conntrack: add missing DCCP protocol changes in event cache


 net/netfilter/nf_conntrack_proto_dccp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

