From: Pablo Neira <pablo@eurodev.net>
Subject: Re: a libipq problem(FAQ cannot help)
Date: Sun, 29 Aug 2004 06:13:26 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <413157E6.9010004@eurodev.net>
References: <293682792.10746@uestc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: He Ke <heke@uestc.edu.cn>
In-Reply-To: <293682792.10746@uestc.edu.cn>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi He Ke,

He Ke wrote:

>Hello,
>i've now got a serious problem on the libipq programming.I wrote an application
>which gets 
>packets from iptables's QUEUE target(ip_queue&ip6_queue),and then deals with
>them(drop,accept,...).
>It works well with normal amout of packets,but when packets comes above 10M/s,it
>dies soon,and show
> "Failed to received netlink message: No buffer space available".
>  
>

this problem is netlink sockets related, so ipqueue inherits it because 
it's built on top of them...

>   I've checked the FAQ,it says "you can tune their receive buffer sizes via
> /proc/sys/net/core, sysctl, or use the SO_RCVBUF socket option on the file
> descriptor".I tried them both , but it doesn't work,my application still die
>soon
> when it meets packets above 10M/s.
>   I tuned
>  /proc/sys/net/core/rmem_default
>  /proc/sys/net/core/rmem_max
>  
>

I just submitted a patch which fixes this problem, it will go into 2.6.9 
if everything goes ok.

It's also available here, 2.6.x version:
http://eurodev.net/~pablo/netlink-workqueue-2.patch

2.4.x patch version is on the way, stay tuned.

regards,
Pablo
