From: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 02/38] netfilter: flowtables: use fixed renew timeout on
 teardown
Date: Fri, 20 Jul 2018 15:20:58 +0200
Message-ID: <2b757614-c824-cc1b-7ebb-925c2e963830@nbd.name>
References: <20180720130906.27687-1-pablo@netfilter.org>
 <20180720130906.27687-3-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-3-pablo@netfilter.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2018-07-20 15:08, Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> This is one of the very few external callers of ->get_timeouts(),
> 
> We can use a fixed timeout instead, conntrack core will refresh this in
> case a new packet comes within this period.
> 
> Use of ESTABLISHED timeout seems way too huge anyway.
It seems to me that this could easily break long-lived connections that
are idle most of the time.

- Felix
