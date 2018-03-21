From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] netfilter: nfnetlink_cthelper: Remove VLA usage
Date: Wed, 21 Mar 2018 08:51:26 -0500
Message-ID: <1794f439-684a-b2ca-2b89-a15c6b6dcd30@embeddedor.com>
References: <20180313002138.GA27280@embeddedgus>
 <20180320123655.kugtpftt7nhzvqc5@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180320123655.kugtpftt7nhzvqc5@salvia>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 03/20/2018 07:36 AM, Pablo Neira Ayuso wrote:
> On Mon, Mar 12, 2018 at 07:21:38PM -0500, Gustavo A. R. Silva wrote:
>> In preparation to enabling -Wvla, remove VLA and replace it
>> with dynamic memory allocation.
>>
>>  From a security viewpoint, the use of Variable Length Arrays can be
>> a vector for stack overflow attacks. Also, in general, as the code
>> evolves it is easy to lose track of how big a VLA can get. Thus, we
>> can end up having segfaults that are hard to debug.
>>
>> Also, fixed as part of the directive to remove all VLAs from
>> the kernel: https://lkml.org/lkml/2018/3/7/621
> 
> also applied, thanks.
> 

Awesome.

Thanks, Pablo.
--
Gustavo
