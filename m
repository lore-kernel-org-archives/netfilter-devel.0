From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: why does tcpmss_reverse_mtu() in xt_TCPMSS.c call
 dst_release()
Date: Mon, 2 Mar 2009 14:32:30 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903021431210.30028@fbirervta.pbzchgretzou.qr>
References: <885896af0903020508x25bbe37evb5d6ffd6f4f2c582@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Giacomo <delleceste@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46144 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbZCBNcd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:32:33 -0500
In-Reply-To: <885896af0903020508x25bbe37evb5d6ffd6f4f2c582@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-03-02 14:08, Giacomo wrote:

>Good morning. A simple question this time:
>
>why does tcpmss_reverse_mtu() in xt_TCPMSS.c call dst_release() after dst_mtu()?
>
>I saw that dst_release decrements reference count of the passed struct
>dst_entry*.

A route entry will be created with ai->route(), but since all we want is 
the MTU, this dst/route is released again so that it will get gc'ed.
