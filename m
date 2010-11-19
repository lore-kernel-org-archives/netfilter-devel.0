From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libmnl: proposed patches 20101116
Date: Fri, 19 Nov 2010 12:16:15 +0100
Message-ID: <4CE65C7F.6000600@netfilter.org>
References: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43029 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105Ab0KSLQT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:16:19 -0500
In-Reply-To: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16/11/10 12:43, Jan Engelhardt wrote:
> Jan Engelhardt (6):
>       attr: avoid multiple definition of hidden variable
>       socket: propagate sendto/recvmsg's return types
>       Update .gitignore

I have pushed until here above ^^^

>       build: tag function headers rather than decls as exported

I like this one above, but it requires the minor glitch fix.
