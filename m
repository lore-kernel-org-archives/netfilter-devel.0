From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: Kill unreplied conntracks by ICMP errors
Date: Tue, 17 Dec 2013 22:52:02 +0800
Message-ID: <CABa6K_EoH23P8OYEDRhA4ihgKeZ-0OtW4gU0CcRLh2jDk3=8OA@mail.gmail.com>
References: <1386861575-121885-1-git-send-email-xiaosuo@gmail.com>
 <2247276.HWz9edslhi@gentoovm> <20131217130117.GA8852@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>,
	xiaosuo@gmail.xom,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:51396 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3LQOwX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:52:23 -0500
Received: by mail-ie0-f178.google.com with SMTP id lx4so8421557iec.37
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2013 06:52:22 -0800 (PST)
In-Reply-To: <20131217130117.GA8852@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 17, 2013 at 9:01 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Indeed. You can configure those two NATs to make them more
> hole-punching friendly by dropping UDP packets to local closed ports,
> so that conntrack entry won't be created.

Yes. But it requires the explicit configuration. Why not make it work
by default, although it may fail in some situation? Less is better
than none, isn't it?

Thanks.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
