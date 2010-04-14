From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Set pointer to TCP header in callback function
Date: Wed, 14 Apr 2010 09:49:33 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004140949010.1242@obet.zrqbmnf.qr>
References: <i2p8363055a1004132040je747ad0avda68218c6cd6110e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Justin Yaple <yaplej@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38592 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137Ab0DNHte (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 03:49:34 -0400
In-Reply-To: <i2p8363055a1004132040je747ad0avda68218c6cd6110e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-04-14 05:40, Justin Yaple wrote:
>
>tcph = (struct tcphdr *) (((u_int32_t *)payload) + (iph->ihl * 4));

You don't use both uint32_t and *4.
