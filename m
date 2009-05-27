From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: BRIDGE_NF_EBTABLES dependency on BRIDGE_NETFILTER
Date: Wed, 27 May 2009 11:36:17 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905271135560.13919@fbirervta.pbzchgretzou.qr>
References: <17923cc80905270228s4e5591e4ja03ad433dbf61c8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, buytenh@wantstofly.org
To: sachin sanap <sachin.sanap.1gb@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43994 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbZE0JgQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 05:36:16 -0400
In-Reply-To: <17923cc80905270228s4e5591e4ja03ad433dbf61c8e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-05-27 11:28, sachin sanap wrote:

>Hi,
>Iam using 2.6.29.2 kernel and I dont understand why is
>BRIDGE_NF_EBTABLES dependent on BRIDGE_NETFILTER in
>net/bridge/netfilter/Kconfig ? I can remove the dependency and
>successfully compile the kernel with BRIDGE_NF_EBTABLES on and
>BRIDGE_NETFILTER off.
>Does net/bridge/netfilter/Kconfig need an update or iam missing
>something obvious?

But what are you going to do with ebtables.ko if there is no one
to make function calls into it?
