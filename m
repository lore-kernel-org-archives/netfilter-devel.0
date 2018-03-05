From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH] netfilter: ipt_ah: return boolean instead of integer
Date: Mon, 5 Mar 2018 16:22:49 -0600
Message-ID: <c61aff0b-8255-e769-f150-83f3908e6690@embeddedor.com>
References: <20180213142557.GA9008@embeddedor.com>
 <20180305221027.vmailsqb5gkvxmcg@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180305221027.vmailsqb5gkvxmcg@salvia>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 03/05/2018 04:10 PM, Pablo Neira Ayuso wrote:
> On Tue, Feb 13, 2018 at 08:25:57AM -0600, Gustavo A. R. Silva wrote:
>> Return statements in functions returning bool should use
>> true/false instead of 1/0.
>>
>> This issue was detected with the help of Coccinelle.
> This one didn't get in time for the previous merge window.
>
> Now applied, thanks.
Great.
Thanks, Pablo.
--
Gustavo
