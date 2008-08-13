From: Patrick McHardy <kaber@trash.net>
Subject: Re: build: fix initext.c dependency
Date: Wed, 13 Aug 2008 14:44:18 +0200
Message-ID: <48A2D722.8090608@trash.net>
References: <alpine.LNX.1.10.0808121934060.22617@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41351 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbYHMMoV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:44:21 -0400
In-Reply-To: <alpine.LNX.1.10.0808121934060.22617@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> build: fix initext.c dependency
> 
> initext?.c is generated within the current directory, not in ${srcdir}.

Applied, thanks.
