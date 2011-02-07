From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] One fix for iptables' CT event filtering
Date: Mon, 07 Feb 2011 12:40:30 +0100
Message-ID: <20110207113905.32414.94829.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33686 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab1BGMkH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Feb 2011 07:40:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

This is one bugfix for the iptables' CT event filtering. There's
one situation in which the filtering does not work for TCP flows.

See patch description for details, please apply!
Thanks!

---

Pablo Neira Ayuso (1):
      netfilter: nf_conntrack: set conntrack templates again if we return NF_REPEAT


 net/netfilter/nf_conntrack_core.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

-- 
tum-te-tum-dum-de-dum
