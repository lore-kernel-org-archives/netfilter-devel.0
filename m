From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: Re: netfilter & ipv6
Date: Tue, 15 Feb 2005 03:29:15 +0200
Message-ID: <4211506B.8050600@niksula.hut.fi>
References: <42086F50.9090504@niksula.hut.fi> <420B6A93.3080005@niksula.hut.fi>
	<Pine.LNX.4.62.0502102231060.6223@mercury.sdinet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Sven-Haegar Koch <haegar@sdinet.de>
In-Reply-To: <Pine.LNX.4.62.0502102231060.6223@mercury.sdinet.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Sven-Haegar Koch wrote:

>> since the name of the name of the module essentially determines the 
>> name of the target, the module etc.
>
> why?
> the module in patch-o-matic-ng (the top directory name) could be named 
> CLASSIFY_v6, containing the target CLASSIFY for ipv6, with the kernel 
> module named ip6t_CLASSIFY.
> I see nothing which prevents this.

Oh! You're right, it worked. I must have had something wrong somewhere 
before when it complained. Excellent! :)

> c'ya
> sven

Thanks,

-- 
- xkr47
