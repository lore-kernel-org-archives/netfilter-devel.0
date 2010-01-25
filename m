From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ebtables extension 'http'
Date: Mon, 25 Jan 2010 14:54:56 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001251453460.10705@obet.zrqbmnf.qr>
References: <8a87046f1001250546w1dec4136nc509510e8ac15eb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Felipe W Damasio <felipewd@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52319 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924Ab0AYNy5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:54:57 -0500
In-Reply-To: <8a87046f1001250546w1dec4136nc509510e8ac15eb8@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-01-25 14:46, Felipe W Damasio wrote:
>
>  This way all the non-cacheable traffic doesn't get routed, it's
>forwarded along all other traffic, and only the desirable packets are
>routed to iptables and then squid.
>
>  What do you guys think? Could this be done?

For the same reason:
http://l7-filter.sourceforge.net/FAQ#usage
