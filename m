From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [0/4] ctnetlink updates
Date: Wed, 21 May 2008 00:29:20 +0200
Message-ID: <483350C0.20407@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40930 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762119AbYETW3a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2008 18:29:30 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

The following patchset contains several updates for ctnetlink:

[PATCH] group errors into logical errno sets
[PATCH] add full support for SCTP to ctnetlink
[PATCH] add support for modifying secmark via ctnetlink
[PATCH] deliver events for conntracks created/updated via ctnetlink

 include/linux/netfilter/nfnetlink_conntrack.h |   10 +
 net/netfilter/nf_conntrack_netlink.c          |  137
++++++++++++++++++--------
 net/netfilter/nf_conntrack_proto_sctp.c       |   80 +++++++++++++++
 3 files changed, 187 insertions(+), 40 deletions(-)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
