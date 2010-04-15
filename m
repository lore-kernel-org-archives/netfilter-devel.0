From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] bridge-netfilter: simplify IP DNAT
Date: Thu, 15 Apr 2010 12:18:30 +0200
Message-ID: <4BC6E7F6.4030605@trash.net>
References: <4BC5BFA9.1060500@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60402 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab0DOKSc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:18:32 -0400
In-Reply-To: <4BC5BFA9.1060500@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> bridge-netfilter: simplify IP DNAT
> 
> Remove br_netfilter.c::br_nf_local_out(). The function
> br_nf_local_out() was needed because the PF_BRIDGE::LOCAL_OUT hook
> could be called when IP DNAT happens on to-be-bridged traffic. The
> new scheme eliminates this mess.

Nice cleanup. Applied, thanks Bart.
