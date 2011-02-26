From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] improvement for TCP connection tracking
Date: Sat, 26 Feb 2011 04:32:08 +0100
Message-ID: <20110226032834.4335.74168.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59697 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1BZDd7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Feb 2011 22:33:59 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick, Jozsef,

I've been testing the following patch in my HA firewall setup
with success. This patch provides better recovery in stress
scenarios.

Please, if you're OK with it, pass to it 2.6.38.

---

Pablo Neira Ayuso (1):
      netfilter: nf_ct_tcp: better handling for SYN retransmissions after SYN+ACK


 net/netfilter/nf_conntrack_proto_tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
