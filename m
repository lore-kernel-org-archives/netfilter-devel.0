From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ULOG / netlink errors
Date: Sun, 28 Nov 2004 21:37:55 +0100
Message-ID: <41AA3723.9070708@eurodev.net>
References: <20041128113728.GA17226@oasis.frogfoot.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Abraham van der Merwe <abz@frogfoot.net>
In-Reply-To: <20041128113728.GA17226@oasis.frogfoot.net>
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

Abraham van der Merwe wrote:

>I'm trying to gather statistics (for netflow stats) using ULOG.
>  
>

Maybe the ulog target isn't the best way to gather info stats. What kind 
of stats are you gathering to be precise?

>What I do:
>
># tag packets
>iptables -A FORWARD -j ULOG --ulog-cprange 64 --ulog-nlgroup 1
>  
>

try also with:

modprobe ipt_ULOG nlbufsiz=131068

it's the size of the internal buffer which is sent to user space.

Some maths: 131068/64=2047, so that tells me that --ulog-qthreshold 
value should be lower/equal than that.

>Then I open a netlink socket (socket AF_NETLINK,SOCK_RAW,NETLINK_NFLOG),
>increase the receive buffer size to NLBUFSIZ and capture messages using
>recvfrom().
>
>I keep getting these errors:
>
>------------< snip <------< snip <------< snip <------------
>root@mojo:~# ./tuxprobe
>Starting to log output.
>recvfrom failed: No buffer space available
>recvfrom failed: No buffer space available
>recvfrom failed: No buffer space available
>recvfrom failed: No buffer space available
>...
>------------< snip <------< snip <------< snip <------------
>
>I have tried increasing the socket buffer size with:
>
>sysctl -w net/core/rmem_max=1048576
>sysctl -w net/core/rmem_default=1048576
>  
>

this is ok, it's always a good idea to reduce the probability of an 
overflow. But I think that you'll have problems anyway with traffers 
rates bigger than ~20 Mbits/s.

>With libpcap (or normal raw socket) on the same machine I have no problems
>capturing all the data, even with capturing complete packets so I can't see
>why above doesn't/shouldn't work.
>  
>

AFAIK libpcap has also known limitations 
(http://luca.ntop.org/Ring.pdf), so for high tranfers rate you'll also 
get fake numbers. I don't track its status so don't know if they were 
already fixed.

--
Pablo
