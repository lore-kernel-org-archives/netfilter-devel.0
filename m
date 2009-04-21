From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables specify path to kernel headers
Date: Tue, 21 Apr 2009 16:15:16 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904211615040.26689@fbirervta.pbzchgretzou.qr>
References: <200904211613.45467.christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Christoph Paasch <christoph.paasch@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56014 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbZDUOPS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:15:18 -0400
In-Reply-To: <200904211613.45467.christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-04-21 16:13, Christoph Paasch wrote:

>is there a way to specify a custom path to the kernel headers when compiling 
>iptables?

iptables does not rely on external kernel headers anymore.
