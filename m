From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: arptables and the generic xtables issues
Date: Thu, 16 Oct 2008 03:43:06 +0200
Message-ID: <48F69C2A.8010001@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52197 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753459AbYJPBnT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 21:43:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Currently, we have tagged quite a lot of targets and matches with
AF_UNSPEC as they are generic for the netfilter supported protocols.
This is fine if we only think of ebtables, iptables and ip6tables but
not for arptables, I doubt that all those target and matches can work
with arptables - even if we still need the userspace support, of course.

I think that we should fix those, right?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
