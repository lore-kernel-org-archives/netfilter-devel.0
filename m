From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Avoiding multiple calls to xt_target.checkentry
Date: Sun, 24 May 2009 09:34:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905240933050.18758@fbirervta.pbzchgretzou.qr>
References: <4A18A70F.50808@shikadi.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56659 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZEXHef (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 May 2009 03:34:35 -0400
In-Reply-To: <4A18A70F.50808@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-05-24 03:46, Adam Nielsen wrote:
>
>In other words, is there a function only called the first time the rule is
>added by iptables?  Or should I be keeping track of that myself?

You forget that iptables does not add rules. It replaces entire tables,
and to make that atomic, the new table is checked before the old one
is released. And yes, you usually try to lookup a led trigger first
before creating one, because there can be a table that calls -j LED
twice.
