From: Oleg <lego12239@yandex.ru>
Subject: Re: NFQUEUE --queue-balance
Date: Sun, 27 Aug 2017 11:11:23 +0300
Message-ID: <20170827081123.GA22938@legohost>
References: <20170826154013.GA19754@legohost>
 <20170826192421.GC29355@breakpoint.cc>
Reply-To: Oleg <lego12239@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forward102p.mail.yandex.net ([77.88.28.102]:36968 "EHLO
        forward102p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750797AbdH0IQJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Aug 2017 04:16:09 -0400
Content-Disposition: inline
In-Reply-To: <20170826192421.GC29355@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 26, 2017 at 09:24:21PM +0200, Florian Westphal wrote:
> Oleg <lego12239@yandex.ru> wrote:
> >   Hi, all.
> > 
> > --queue-balance balance packets according to connection tracking,
> > iiuc. Consequently queue utilization is not equal. E.g.:
> 
> It hashes based on ip addresses.

Thank you for clarification.

> > Is there queue balancer without this feature(simple round-robin)?
> 
> Use nftables or use multiple NFQUEUE rules with -m statistic.

Wow! This what i need. Thank you!


-- 
Олег Неманов (Oleg Nemanov)
