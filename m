From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [Iptables Patch V3] extensions: libxt_cluster: Add translation to nft
Date: Tue, 16 Jan 2018 11:22:02 +0530
Message-ID: <CAOfkYf7ELf-tbiOZTSvTTHR_p6PybdBZ6dmFz2eSZNtKPR-c7A@mail.gmail.com>
References: <1515995968-10120-1-git-send-email-mayhs11saini@gmail.com> <20180116005953.zkoqd73jpz4jgm6i@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:35767 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbeAPFwD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jan 2018 00:52:03 -0500
Received: by mail-ot0-f169.google.com with SMTP id 53so12633094otj.2
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2018 21:52:03 -0800 (PST)
In-Reply-To: <20180116005953.zkoqd73jpz4jgm6i@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Hi Shyam,

Hi Pablo,
> On Mon, Jan 15, 2018 at 11:29:28AM +0530, Shyam Saini wrote:
>> Add translation for cluster to nft
>>
>> $ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster
>> --cluster-total-nodes 7 --cluster-local-node 5 --cluster-hash-seed
>> 0xdeadbeef -j MARK --set-mark 0xffff
>>
>> nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr
>> mod 7 seed 0xdeadbeef eq 5 meta pkttype set host counter meta mark set
>> 0xffff
>>
>> $ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster
>> --cluster-total-nodes 7 --cluster-local-nodemask 5 --cluster-hash-seed
>> 0xdeadbeef -j MARK --set-mark 0xffff
>>
>> nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr
>> mod 7 seed 0xdeadbeef eq { 0, 2 } meta pkttype set host counter meta
>> mark set 0xffff
>
> Looks good, applied, thanks!
>
> Would you also send us a test for this?
>
> Have a look at extensions/*.txlate
>
> Thanks.


I will send the test for this.

Thanks,
Shyam
