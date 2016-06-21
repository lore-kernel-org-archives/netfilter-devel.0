From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PACTH nf-next] netfilter: nf_reject_ipv4: don't send tcp RST if
 the packet is non-TCP
Date: Tue, 21 Jun 2016 09:35:55 +0800
Message-ID: <CAML_gOf0ofzsnsxP=8xW7tYfv+H91yMthLykUbOphBL0JEgJqQ@mail.gmail.com>
References: <1466429188-3942-1-git-send-email-zlpnobody@163.com> <20160620154829.GD18341@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:33331 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbcFUBlO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 21:41:14 -0400
Received: by mail-vk0-f51.google.com with SMTP id d185so2330368vkg.0
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 18:41:14 -0700 (PDT)
In-Reply-To: <20160620154829.GD18341@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Marcelo,

2016-06-20 23:48 GMT+08:00 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>:
>
> A different check/log is made for ip6:
> nf_reject_ip6_tcphdr_get():
>         /* IP header checks: fragment, too short. */
>         if (proto != IPPROTO_TCP || *otcplen < sizeof(struct tcphdr)) {
>                 pr_debug("proto(%d) != IPPROTO_TCP or too short (len = %d)\n",
>                          proto, *otcplen);
>                 return NULL;
>         }
>
> Would be nice to have some consistency on this log message as it
> increases debug-ability.
>

Thanks for your opinion.

But you can see, there are many inconsistent things between
nf_reject_ip6_tcphdr_get and nf_reject_ip_tcphdr_get.

For example, when tcp->rst is set, reject_ip6 will call
pr_debug("RST is set\n"), while there's nothing in reject_ip4.

IMO, these debug informations are almost useless, so there's
no need to add this debug info only for consistent with nf_reject_ip6.
