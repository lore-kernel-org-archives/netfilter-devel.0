From: Patrick McHardy <kaber@trash.net>
Subject: Re: libxt_recent: do not allow both --set and --rttl
Date: Mon, 04 Aug 2008 12:52:54 +0200
Message-ID: <4896DF86.5000501@trash.net>
References: <alpine.LNX.1.10.0808031503320.6502@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51449 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYHDKwz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:52:55 -0400
In-Reply-To: <alpine.LNX.1.10.0808031503320.6502@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> libxt_recent: do not allow both --set and --rttl
> 
> Reported-by: Erich Schubert <erich@debian.org>
> Reference: Debian bug #346034
> 
> "I was using the --rttl option in my --set line; this caused all
> incoming ssh connections to be rejected; --rttl is only to be used
> with --rcheck and --update."

Applied, thanks.
