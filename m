From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: No chain/target/match by that name
Date: Tue, 17 Mar 2009 11:20:53 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903171120370.15275@fbirervta.pbzchgretzou.qr>
References: <49BF7930.5000808@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Vlad <limonad@gmx.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55816 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758630AbZCQKU4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:20:56 -0400
In-Reply-To: <49BF7930.5000808@gmx.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-17 11:19, Vlad wrote:

> Hallo , I'm trying to write a new module for iptables. I started with a dummy
> module. I can successfully compile it. But if I trying to use it, I get an
> error message:
>
> $ iptables -A INPUT -s 128.0.0.1 -m secan --drop -j DROP
> drop frame
> iptables: No chain/target/match by that name
>
> Can someone tell me what is a problem? Here is my code:
>[...]

The iptables code looks fine, but what about the kernel side module?

