From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_NFQUEUE: Add translation to nft
Date: Wed, 23 Dec 2015 01:08:51 +0530
Message-ID: <CAKHNQQE0=tQQcaWCvAgyQGA3yiM3mfZcoLcrfb-Kn8DKaY=+6w@mail.gmail.com>
References: <20151221132342.GA2582@gmail.com> <20151222164020.GA17410@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:33467 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbLVTjM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 14:39:12 -0500
Received: by mail-wm0-f48.google.com with SMTP id p187so120668516wmp.0
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 11:39:11 -0800 (PST)
In-Reply-To: <20151222164020.GA17410@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 10:10 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Dec 21, 2015 at 06:53:43PM +0530, Shivani Bhardwaj wrote:
>> Add translation of NF queue to nftables.
>>
>> Examples:
>>
>> $ sudo iptables-translate -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE --queue-num 30
>> nft add rule ip nat PREROUTING tcp dport 80 counter  queue num 30
>>
>> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-num 0 --queue-bypass -p TCP --sport 80
>> nft add rule ip filter FORWARD tcp sport 80 counter  queue num 0 bypass
>                                                      ^
> Make sure this space is gone in a v2 of this patch.
>
>> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-balance 0:3
>> nft add rule ip filter FORWARD counter  queue num 0-3 fanout
>
> I think --queue-balance is independent from fanout. Check the code and
> make sure this is correct.
>
Hi,

I have taken reference from here :
http://wiki.nftables.org/wiki-nftables/index.php/Queueing_to_userspace

It says:
When doing load balancing, you can use the fanout option to use the
CPU ID as an index to map packets to the queues. The idea is that you
can improve performance if there's a queue/userspace application per
CPU

Please let me know if I have understood this wrong.

Thank you

>> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-bypass -p TCP --sport 80 --queue-balance 0:3
>> nft add rule ip filter FORWARD tcp sport 80 counter  queue num 0-3 fanout bypass
>
> Although this syntax is correct, we prefer:
>
> nft add rule ip filter FORWARD tcp sport 80 counter queue num 0-3 fanout,bypass
>                                                                         ^
>                                                 comma-separated values for flags.
>
> Thanks.
