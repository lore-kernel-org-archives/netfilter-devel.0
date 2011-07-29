From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][RESEND] fix ebtables build dependency
Date: Fri, 29 Jul 2011 16:41:01 +0200
Message-ID: <4E32C67D.9020301@trash.net>
References: <4E230821.10807@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56588 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab1G2OlE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:41:04 -0400
In-Reply-To: <4E230821.10807@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17.07.2011 18:04, Bart De Schuymer wrote:
> The configuration of ebtables shouldn't depend on
> CONFIG_BRIDGE_NETFILTER, only on CONFIG_NETFILTER.

Applied, thanks.
