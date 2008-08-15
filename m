From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: build: fix iptables-static build
Date: Fri, 15 Aug 2008 14:16:03 +0200
Message-ID: <48A57383.8060606@netfilter.org>
References: <alpine.LNX.1.10.0808142120510.24200@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42593 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752590AbYHONLw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:11:52 -0400
In-Reply-To: <alpine.LNX.1.10.0808142120510.24200@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 1c9158d35e415d6983b3e9b0c67345d566940425
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Thu Aug 14 20:59:49 2008 -0400
> 
> build: fix iptables-static build
> 
> Commit 126c1361ad5201973e6ebc761b3e38a67915de29 unfortunately broke
> building iptables-static due to listing iptables.c twice. Fix this.

Applied. Thanks Jan.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
