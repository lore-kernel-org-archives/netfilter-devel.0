From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH v2 net-next 0/1] sip: introduce nf_nat_sip_hooks
Date: Mon, 30 Sep 2013 17:07:27 +0200
Message-ID: <20130930150727.532427857@eitzenberger.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab3I3PKR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:10:17 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

both nf_conntrack_sip and nf_nat_sip use 7 different NAT hooks
currently: they are exported by the conntrack module, then set by the
NAT module at module_init() time.

Quite some of this repetitive task can be avoided by introducing
nf_nat_sip_hooks.

SIP helper has been tested after applying this patch.

v1 -> v2
 * removed nsh_ prefix from hook functions
 

 /Holger                                                                        

