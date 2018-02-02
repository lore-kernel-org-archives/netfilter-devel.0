From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH net] netfilter: xt_hashlimit: do not allow empty names
Date: Fri, 2 Feb 2018 13:12:08 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1802021306530.14157@n3.vanv.qr>
References: <1517154099.3715.77.camel@gmail.com> <1517162045.3715.78.camel@gmail.com> <20180202114938.jxsaun6w3hnfedfz@salvia> <20180202115522.bmuukhfib4harcoy@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180202115522.bmuukhfib4harcoy@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Friday 2018-02-02 12:55, Pablo Neira Ayuso wrote:

>On Fri, Feb 02, 2018 at 12:49:38PM +0100, Pablo Neira Ayuso wrote:
>[...]
>> bool net_valid_name(const char *name, size_t len)
>> {
>>         ...
>> }
>
>Am I missing anything in all these tricky string handling? Thanks!

One will have to watch out for calls like

	net_valid_name(NLA_DATA(some_ifla_name), IFNAMSIZ)

because quite some nlattrs (IFLA_NAME, IFLA_IFNAME to boot) are NLA_STRINGs
(rather than NLA_NUL_STRINGs) and they are not \0-terminated.
