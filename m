From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 13/24] [NETFILTER]: nf_nat: autoload IPv4 connection tracking
Date: Thu, 03 Apr 2008 14:27:47 +0200
Message-ID: <47F4CD43.8050108@trash.net>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <2d8abd69594fd12d2e8eeece42cc957749d37322.1207134547.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32833 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbYDCM1w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 08:27:52 -0400
In-Reply-To: <2d8abd69594fd12d2e8eeece42cc957749d37322.1207134547.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Without this patch, the generic L3 tracker would kick in
> if nf_conntrack_ipv4 was not loaded before nf_nat, which
> would lead to translation problems with ICMP errors.
> 
> NAT does not make sense without IPv4 connection tracking
> anyway, so just add a call to need_ipv4_conntrack().

Queued for 2.6.25, thanks.
