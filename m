From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: problem with xtables-addons and CentOS 5.3
Date: Mon, 27 Apr 2009 11:11:31 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904271110320.6706@fbirervta.pbzchgretzou.qr>
References: <49F49944.3010800@solutti.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ML netfilter-devel <netfilter-devel@vger.kernel.org>
To: Leonardo Rodrigues <leolistas@solutti.com.br>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48642 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbZD0JLd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Apr 2009 05:11:33 -0400
In-Reply-To: <49F49944.3010800@solutti.com.br>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2009-04-26 19:26, Leonardo Rodrigues wrote:

>
>   Hi,
>
>   i'm having a hard time trying to compile xtables-addons 1.14 on a CentOS 5.3
> x86_64 box

I added appropriate warning mechanisms to configure.ac for the next
release that this distro is unsupported.
