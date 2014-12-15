From: Tomer Eliyahu <tomereliyahu1@gmail.com>
Subject: Re: Question regarding iptables-nftables compatibility layer with libiptc
Date: Mon, 15 Dec 2014 21:24:49 +0200
Message-ID: <CA+eXE3z2JWNSDOz+6O1TumDZfZCJw=PBHLLbpNQJMZ2pZ7LXAA@mail.gmail.com>
References: <CA+eXE3yHB3WWrxzXNLrWD-YAO5=YnBP8s2Zke3_cjaFzdg9wUA@mail.gmail.com>
	<20141215150119.GA3506@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:42886 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaLOTYu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:24:50 -0500
Received: by mail-la0-f53.google.com with SMTP id gm9so9780295lab.40
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Dec 2014 11:24:49 -0800 (PST)
In-Reply-To: <20141215150119.GA3506@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks, should have read the FAQ before asking...

Is there a clean way to notify a kernel module whenever an iptables
rule changes (e.g. without nftables / in kernels <3.13) ?

Best Regards,

Tomer

On Mon, Dec 15, 2014 at 5:01 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Dec 15, 2014 at 04:33:59PM +0200, Tomer Eliyahu wrote:
>> Hi,
>>
>> Regarding applications which use libiptc directly, such as openwrt's
>> firewall package - does the iptables-nftables compatibility layer
>> support translating libiptc calls to nftables calls?
>
> No.
>
>> If not - is there any plan to add such support or should every such
>> application be upgraded for nftables support?
>
> No plans to support that. Unfortunately that library was not ever
> intended to be a public library:
>
> http://www.netfilter.org/documentation/FAQ/netfilter-faq-4.html#ss4.5
>
> The official public interface so far is iptables-restore.
