From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH iptables-next] extensions: libxt_IDLETIMER: use xtables_param_act
 when checking options
Date: Thu, 15 Jul 2010 17:13:45 +0200
Message-ID: <4C3F25A9.6060007@trash.net>
References: <1279206331-6921-1-git-send-email-luciano.coelho@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Luciano Coelho <luciano.coelho@nokia.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46708 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933418Ab0GOPNr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:13:47 -0400
In-Reply-To: <1279206331-6921-1-git-send-email-luciano.coelho@nokia.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.07.2010 17:05, schrieb Luciano Coelho:
> This patch changes custom error messages for illegal options into the
> default iptables messages, by using xtables_param_act().

Applied, thanks Luciano.
