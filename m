From: Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>
Subject: Re: [PATCH net-next] netfilter: fix null-ptr-deref in
 nf_nat_decode_session
Date: Mon, 4 Jun 2018 10:10:08 +0900
Message-ID: <3c408f33-9c9c-b16f-3433-8931ea3e4bae@lab.ntt.co.jp>
References: <20180528091449.7508-1-bhole_prashant_q7@lab.ntt.co.jp>
 <20180528105249.36pvoyo5loqjjmsa@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180528105249.36pvoyo5loqjjmsa@breakpoint.cc>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

CC netfilter-devel

On 5/28/2018 7:52 PM, Florian Westphal wrote:
> Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp> wrote:
>> Add null check for nat_hook in nf_nat_decode_session()
> 
> Acked-by: Florian Westphal <fw@strlen.de>

Hi Pablo,
Just pinging in case this patch was missed.

-Prashant
