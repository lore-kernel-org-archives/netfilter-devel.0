From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] netfilter: avoid double seq_adjust for loopback
Date: Thu, 16 Jun 2011 17:30:16 +0200
Message-ID: <4DFA2188.5000505@trash.net>
References: <alpine.LFD.2.00.1106080926320.1457@ja.ssi.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Julian Anastasov <ja@ssi.bg>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60072 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab1FPPaU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:30:20 -0400
In-Reply-To: <alpine.LFD.2.00.1106080926320.1457@ja.ssi.bg>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.06.2011 08:31, Julian Anastasov wrote:
> 	Avoid double seq adjustment for loopback traffic
> because it causes silent repetition of TCP data. One
> example is passive FTP with DNAT rule and difference in the
> length of IP addresses.
> 
> 	This patch adds check if packet is sent and
> received via loopback device. As the same conntrack is
> used both for outgoing and incoming direction, we restrict
> seq adjustment to happen only in POSTROUTING.
> 
> Signed-off-by: Julian Anastasov <ja@ssi.bg>

Applied, thanks Julian.
