From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH:RFC 2/5] bridge-netfilter: update a comment in br_forward.c
 about ip_fragment()
Date: Tue, 13 Apr 2010 11:42:07 +0200
Message-ID: <4BC43C6F.1050809@trash.net>
References: <4BB207A0.7070702@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45697 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab0DMJmI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:42:08 -0400
In-Reply-To: <4BB207A0.7070702@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> bridge-netfilter: update a comment in br_forward.c about ip_fragment()
> 
> ip_refrag isn't used anymore in the bridge-netfilter code

Also applied, thanks.
