From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: size calculation wasted cpu time
Date: Mon, 16 Mar 2009 15:06:13 +0100
Message-ID: <49BE5CD5.5000808@netfilter.org>
References: <152544048.20090316160216@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Kuzin Andrey <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34315 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751794AbZCPOGZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:06:25 -0400
In-Reply-To: <152544048.20090316160216@yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kuzin Andrey wrote:
> In /net/netfilter/nfnetlink_queue.c every call of nfqnl_build_packet_message()
> make series of call nla_total_size() for 'size' calculations.
> I think 'size' is constant value for kernel build and may be define static
> variable for this ?

We can calculate this during the module initialization, brave to cook a
patch for it?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
