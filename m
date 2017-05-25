From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCH 1/1] extensions: libxt_cluster: Add translation to nft
Date: Thu, 25 May 2017 15:40:54 +0530
Message-ID: <CAOfkYf5aor9go6YYY1TFWq5nbdXF4WPaH4fjqUtRU1wMAAuHjQ@mail.gmail.com>
References: <1495629111-8206-1-git-send-email-mayhs11saini@gmail.com> <20170524154302.GE11547@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: g@breakpoint.cc, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@debian.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33296 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751912AbdEYKKz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 May 2017 06:10:55 -0400
Received: by mail-oi0-f43.google.com with SMTP id w10so274916163oif.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 May 2017 03:10:55 -0700 (PDT)
In-Reply-To: <20170524154302.GE11547@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> Add translation for cluster to nft
>>
>> $ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster --cluster-total-nodes 2 --cluster-local-node 1 --cluster-hash-seed
>> 0xdeadbeef -j MARK --set-mark 0xffff
>>
>> nft add rule ip mangle PREROUTING iifname eth1 ct state {new,established, related, untracked} ct direction original mark set jhash ip saddr mod 2 seed 0xdeadbeef offset 1 counter meta mark set 0xffff
>
> Can you explain why ct expression is needed in this way?

ct original is to get original direction

After your explanation,
i realised adding "ct state {new,established, related, untracked}"  was mistake.

> afaics translation would be (untested):
>
> nft add rule ip mangle PREROUTING iifname eth1 mark set jhash ct saddr mod 2 seed 0xdeadbeef offset 1 counter meta mark set 0xffff fib saddr type multicast meta pkttype set host
>
> we might need to implement "ct master-saddr" to deal with ct->master use
> in xt_cluster as well, but we could do that later as a followup.
> fib saddr type is needed to not set real mutlicast traffic to unicast
> type and only catch l3-unicast-in-l2-multicast.

Thanks a lot for explanation.
