From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Tue, 14 Dec 2010 03:01:41 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <4D00C6A4.6090305@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52443 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758988Ab0LNCBn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Dec 2010 21:01:43 -0500
In-Reply-To: <4D00C6A4.6090305@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-12-09 13:08, Pablo Neira Ayuso wrote:
>
>If we follow the one message per rule basis, you can put several
>messages into one batch with different sequence numbers. Thus, you can
>know what message in the batch has triggered the error and the reason.

/* The unwritten laws of netlink */

Normally, the sequence number of a response message is simply
the one from the request message. But in a dump where there
can be multiple messages, do they all share the sequence number?

Must the response sequence numbers match at all, or is it like TCP
where each side has its own set?

BTW, can response messages - all those leading up to NLMSG_DONE -
have different nlmsg_type, or not? Does the nlmsg_type need
to match the request type?

Jan
