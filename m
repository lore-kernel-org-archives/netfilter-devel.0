From: Jon Webb <jon_webb@binary-one.com>
Subject: Re: using ip_queue in kernel space
Date: Thu, 04 Mar 2004 15:20:34 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4047B9C2.6050706@binary-one.com>
References: <Pine.LNX.4.56L0.0403041712040.12794@zero.fdns.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.56L0.0403041712040.12794@zero.fdns.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Unit Zero wrote:

>I've been curious for a while about the viability of using ip_queue from 
>a kernel module, without any userland side. It seems that ip_queue is 
>really only used for deferring the verdict on packets to a userspace 
>program, but if I simply install a queue handler in the module init 
>entrypoint and then install a netfilter hook that returns a QUEUE verdict 
>on packets I want, and then do whatever in my queue handler, (kick off 
>timer tasks to issue verdicts or some other such thing) will this work? 
>
>  
>
Of course, there are kernel level calls for getting packets out and 
reinjecting them... They can be called from a kernel module. I tried to 
do this once, and it worked ok, except that I needed access to the 
kernel routing table flags to decide what to do with the packets, and I 
could only get at those from userspace (ironically), so I had to abandon 
that implementation.

- Jon Webb
