From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: size calculation wasted cpu time
Date: Fri, 24 Jul 2009 20:55:52 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907242054530.32211@fbirervta.pbzchgretzou.qr>
References: <152544048.20090316160216@yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kuzin Andrey <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56844 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbZGXSzy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:55:54 -0400
In-Reply-To: <152544048.20090316160216@yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2009-03-16 14:02, Kuzin Andrey wrote:

>In /net/netfilter/nfnetlink_queue.c every call of nfqnl_build_packet_message()
>make series of call nla_total_size() for 'size' calculations.
>I think 'size' is constant value for kernel build and may be define static
>variable for this ?
>
>        size =    NLMSG_SPACE(sizeof(struct nfgenmsg))
>                + nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
>                + nla_total_size(sizeof(u_int32_t))     /* ifindex */
>                + nla_total_size(sizeof(u_int32_t))     /* ifindex */

The compiler will optimize it out.
