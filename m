From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH 0/2] TProxy: socket match: transparent option, removed nf_conntrack
 dependency
Date: Fri, 24 Apr 2009 15:26:53 +0200
Message-ID: <49F1BE1D.4040408@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:60199 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756678AbZDXN7K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:59:10 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 7076F39D32B
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2009 15:26:54 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

we extended a missing feature of the socket match that it can check the 
'transparent' member of the socket's structure. The original behaviour 
was that all of the sockets matched if they weren't listening on the 
0.0.0.0 IP address, even if they were unrelated to the TProxy, such as 
ssh or other servers.

The IP_TRANSPARENT socket option is always set for the sockets using the 
TProxy, thus the following patch lets matching only these:

   iptables ... -m socket --transparent ...

When I tested the new option, I found that NETFILTER_TPROXY depends on 
NF_CONNTRACK, which is unwanted, it works without it.

-- 
Panther
