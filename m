From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack, nfct_catch returns ENOBUFS
Date: Mon, 18 Jun 2007 20:11:13 +0200
Message-ID: <4676CAC1.3070104@netfilter.org>
References: <OF7C77170F.72E89A61-ONC12572FE.005AF6F6-C12572FE.005D1649@mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: fabien.marotte@mindspeed.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <OF7C77170F.72E89A61-ONC12572FE.005AF6F6-C12572FE.005D1649@mindspeed.com>
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

fabien.marotte@mindspeed.com wrote:
>> So am I. Could you post the code?
> 
> I reduced my callback to the following :
> CtCatch( ...)
> {
>    return NFCT_CB_CONTINUE;
> }

Well, this does not help too much. What is your callback actually doing? 
If the operation that your callback does is expensive and slow, such as 
printing the event, then may overrun sooner. Here I'm able to generate 
up a bulk of 10000 HTTP GET requests in my testbed with no overrun. Of 
course, using the callback that you suppose to be using. However, if I 
print the event, the results are different.

> and I still see the bug with 20 simultaneous connections.

This is not a bug.

>> Default buffer size in your system? cat /proc/sys/net/core/rmem_default
> 
> /proc/sys/net/core/rmem_default is set to 108544 by default.
> I tried to increase the value up to 262144 and I still get the same issue.
> Is it possible conntrack module to send more than one event in the same 
> netlink messages ?

ENOBUFS tells you that your buffer has overrun. Each process has a 
receiver buffer where netlink puts the messages into. If the sender puts 
more messages into the queue than the receiver can consume, then the 
buffer overruns. This happens if your userspace process is too slow to 
consume messages, this usually happens if your CPU reaches 100% 
consumption. Solution: You can delay the overrun by increasing the 
buffer size.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
