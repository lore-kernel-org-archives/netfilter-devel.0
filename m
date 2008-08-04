From: Patrick McHardy <kaber@trash.net>
Subject: Re: src: remove dependency on libiptc headers
Date: Mon, 04 Aug 2008 12:48:20 +0200
Message-ID: <4896DE74.7080100@trash.net>
References: <alpine.LNX.1.10.0808010903020.31124@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51322 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbYHDKsW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:48:22 -0400
In-Reply-To: <alpine.LNX.1.10.0808010903020.31124@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> src: remove dependency on libiptc headers
> 
> xtables.h does not need really need libxtc.h, and we can drop it from 
> the install as it is internal-only.

Applied, thanks.
