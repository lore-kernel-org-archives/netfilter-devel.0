From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Question regarding iptables-nftables compatibility layer with
 libiptc
Date: Mon, 15 Dec 2014 16:01:19 +0100
Message-ID: <20141215150119.GA3506@salvia>
References: <CA+eXE3yHB3WWrxzXNLrWD-YAO5=YnBP8s2Zke3_cjaFzdg9wUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Tomer Eliyahu <tomereliyahu1@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35821 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbaLOO6x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:58:53 -0500
Content-Disposition: inline
In-Reply-To: <CA+eXE3yHB3WWrxzXNLrWD-YAO5=YnBP8s2Zke3_cjaFzdg9wUA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 15, 2014 at 04:33:59PM +0200, Tomer Eliyahu wrote:
> Hi,
> 
> Regarding applications which use libiptc directly, such as openwrt's
> firewall package - does the iptables-nftables compatibility layer
> support translating libiptc calls to nftables calls?

No.

> If not - is there any plan to add such support or should every such
> application be upgraded for nftables support?

No plans to support that. Unfortunately that library was not ever
intended to be a public library:

http://www.netfilter.org/documentation/FAQ/netfilter-faq-4.html#ss4.5

The official public interface so far is iptables-restore.
