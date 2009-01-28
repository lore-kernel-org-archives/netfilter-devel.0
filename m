From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: xtables: add cluster match
Date: Wed, 28 Jan 2009 17:38:34 +0100
Message-ID: <49808A0A.7050908@netfilter.org>
References: <20090128145801.7501.44459.stgit@Decadence> <20090128145848.7501.18129.stgit@Decadence> <alpine.LSU.2.00.0901281658440.20921@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42599 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751688AbZA1Qio (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 11:38:44 -0500
In-Reply-To: <alpine.LSU.2.00.0901281658440.20921@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-01-28 15:58, Pablo Neira Ayuso wrote:
> 
>> This patch adds the iptables cluster match. This match can be used
>> to deploy gateway and back-end load-sharing clusters. Assuming that
>> all the nodes see all packets
>> (see arptables mcmangle target and PKTTYPE iptables targets on how
>> to do that), the cluster match decides if this node has to handle a
>> packet given:
> 
> Is not this what CLUSTERIP is essentially supposed to do?

No, you can't deploy load-sharing setups for gateways as the -d
parameter is mandatory, CLUSTERIP only works for back-end nodes and have
a couple of significant problems. Indeed, these stuff supersedes CLUSTERIP.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
