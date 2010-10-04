From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next] ipt_LOG: add bufferisation to call printk() once
Date: Mon, 04 Oct 2010 20:58:23 +0200
Message-ID: <4CAA23CF.80904@trash.net>
References: <1286032059.2582.2338.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64838 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0JDS6Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Oct 2010 14:58:25 -0400
In-Reply-To: <1286032059.2582.2338.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 02.10.2010 17:07, schrieb Eric Dumazet:
> ipt_LOG & ip6t_LOG use lot of calls to printk() and use a lock in a hope
> several cpus wont mix their output in syslog.
> 
> printk() being very expensive [1], its better to call it once, on a
> prebuilt and complete line. Also, with mixed IPv4 and IPv6 trafic,
> separate IPv4/IPv6 locks dont avoid garbage.
> 
> I used an allocation of a 1024 bytes structure, sort of seq_printf() but
> with a fixed size limit.
> Use a static buffer if dynamic allocation failed.
> 
> Emit a once time alert if buffer size happens to be too short.
> 
> [1]: printk() has various features like printk_delay()...

Nice work, applied, thanks Eric.

