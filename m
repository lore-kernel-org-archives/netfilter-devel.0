From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables not working with monolithic 2.6.26.5 kernel on ARM
Date: Sun, 5 Oct 2008 23:17:29 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810052315030.17357@fbirervta.pbzchgretzou.qr>
References: <18661.41641.113458.932029@martins.ozlabs.org> <48E6166F.40607@trash.net> <alpine.LNX.1.10.0810031006260.3893@fbirervta.pbzchgretzou.qr> <18662.61266.69230.675687@martins.ozlabs.org> <alpine.LNX.1.10.0810040724110.19954@fbirervta.pbzchgretzou.qr>
 <18665.27407.93703.212846@martins.ozlabs.org> <alpine.LNX.1.10.0810052139230.3354@fbirervta.pbzchgretzou.qr> <18665.32730.50644.705435@martins.ozlabs.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Martin Schwenke <martin@meltin.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36656 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYJFDRa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 23:17:30 -0400
In-Reply-To: <18665.32730.50644.705435@martins.ozlabs.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-10-05 23:02, Martin Schwenke wrote:
>
>What does CONFIG_COMPAT mean?

Support of an ABI (specifically one only) that is different
from the kernel. Usually used to implement 32-bit userspace
for 64-bit kernels.
