From: Sven-Haegar Koch <haegar@sdinet.de>
Subject: Re: netfilter & ipv6
Date: Thu, 10 Feb 2005 22:36:21 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0502102231060.6223@mercury.sdinet.de>
References: <42086F50.9090504@niksula.hut.fi> <420B6A93.3080005@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Jonas Berlin <jberlin@niksula.hut.fi>
In-Reply-To: <420B6A93.3080005@niksula.hut.fi>
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

On Thu, 10 Feb 2005, Jonas Berlin wrote:

> Jonas Berlin wrote:
>
>> 3. If I succeed porting something, what should I name the patch to be sent 
>> to patch-o-matic-ng? I don't think I could just extend the existing ones as 
>> that would suggest the original authors have something to do with it and 
>> also some of them also are pending or already included in the ekernel. So, 
>> would CLASSIFY_v6 be an acceptable name for the ipv6 version of CLASSIFY?

[...]
> since the name of the name of the module 
> essentially determines the name of the target, the module etc.

why?
the module in patch-o-matic-ng (the top directory name) could be named 
CLASSIFY_v6, containing the target CLASSIFY for ipv6, with the kernel 
module named ip6t_CLASSIFY.
I see nothing which prevents this.

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around it.
(John Gilmore on http://www.cygnus.com/~gnu/)
