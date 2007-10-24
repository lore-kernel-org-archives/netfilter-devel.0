From: Philip Craig <philipc@snapgear.com>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 19:28:48 +1000
Message-ID: <471F1050.6090403@snapgear.com>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Volker Sauer <volker@volker-sauer.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.snapgear.com ([203.143.235.140]:35890 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750784AbXJXJWz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:22:55 -0400
In-Reply-To: <471F00DC.9070001@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Philip Craig wrote:
> The only solution I am aware of is to stop bridging and use routing
> and arp proxy.

Sorry, the above isn't the only solution.  Other possibilities:

1.  Filter on IP address instead of output interface.

2.  Delay the decision by setting a mark in iptables and filtering again
in ebtables.  eg the mark could simply encode which port the packet is
allowed for, and ebtables drops if it is bridged out a different port.

