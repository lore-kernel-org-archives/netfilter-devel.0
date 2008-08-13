From: Patrick McHardy <kaber@trash.net>
Subject: Re: build: fix dependency tracking for xtables.h.in
Date: Wed, 13 Aug 2008 14:43:43 +0200
Message-ID: <48A2D6FF.30201@trash.net>
References: <alpine.LNX.1.10.0808121925530.10358@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41341 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbYHMMnp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:43:45 -0400
In-Reply-To: <alpine.LNX.1.10.0808121925530.10358@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> build: fix dependency tracking for xtables.h.in
> 
> For files to be correctly regenerated after the .in file has been
> touched, an explicit extra dependency is needed in the Makefile.

Applied, thanks.
