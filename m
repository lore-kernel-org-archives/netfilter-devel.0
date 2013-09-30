From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH net-next 0/1] sip: introduce nf_nat_sip_hooks
Date: Mon, 30 Sep 2013 15:51:50 +0200
Message-ID: <20130930135150.440707982@eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:58715 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab3I3N4B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:56:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

both nf_conntrack_sip and nf_nat_sip use 7 different NAT hooks
currently: they are exported by the conntrack module, then set by the
NAT module at module_init() time.

Quite some of this repetitive task can be avoided by introducing
nf_nat_sip_hooks.

SIP helper has been tested after applying this patch.

Please check the following patch.

 /Holger

