From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: Kill unreplied conntracks by ICMP errors
Date: Thu, 19 Dec 2013 12:29:02 +0800
Message-ID: <CABa6K_HEpVyE5uppsUKWGowJ_aiqSggZwgc5A0eVD7P-yjcbgg@mail.gmail.com>
References: <1386861575-121885-1-git-send-email-xiaosuo@gmail.com>
 <2247276.HWz9edslhi@gentoovm> <20131217130117.GA8852@localhost>
 <CABa6K_EoH23P8OYEDRhA4ihgKeZ-0OtW4gU0CcRLh2jDk3=8OA@mail.gmail.com> <20131217165821.GA13951@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>,
	xiaosuo@gmail.xom,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:49319 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3LSEgv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Dec 2013 23:36:51 -0500
Received: by mail-ig0-f182.google.com with SMTP id c10so3012449igq.3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Dec 2013 20:36:50 -0800 (PST)
In-Reply-To: <20131217165821.GA13951@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 18, 2013 at 12:58 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> With this patch, an ICMP destination unreachable - fragmentation
> needed coming after a big UDP packet will trigger the removal of the
> UDP conntrack entry, that should not happen.

I don't think this is a problem, as the conntrack is unreplied and the
original packet is dropped. That means the no virtual circuit is setup
along the path, so why do we keep the partial circuit? And the later
restranmitted packet will set up a new conntrack in anyway.

Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
