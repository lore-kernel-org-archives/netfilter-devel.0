From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [patch 0/1] ctnetlink: allocation improvements
Date: Wed, 25 Mar 2009 22:25:21 +0100
Message-ID: <20090325212521.149272388@jonathan.eitzenberger.org>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

the following patch against latest nf-net-next-2.6 tries to address
the concerns raised by Pablo about the inacurate computation of the
ctnetlink skb.  I simply try to properly #ifdef the NLAs where
possible.

Please check.

Thanks.  /holger

Ah, I still owe you a performance comparison! ;)

