From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Some one knows how to implement policy routing with iptables?
Date: Thu, 26 Aug 2004 16:39:15 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408261636550.10523@filer.marasystems.com>
References: <002e01c48b0e$31b253f0$8e5f78ca@nic.ecnu.edu.cn>
	<Pine.LNX.4.61.0408260917380.5483@filer.marasystems.com>
	<002b01c48b6e$f86a3570$8e5f78ca@nic.ecnu.edu.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robbert <hanbo163com@163.com>
In-Reply-To: <002b01c48b6e$f86a3570$8e5f78ca@nic.ecnu.edu.cn>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 Aug 2004, Robbert wrote:

> Yeah,I have seen the ROUTE target,which is useful to force the use of an 
> interface or a next hop and to change the incoming interface of a packet 
> by options --oif,--iif,--gw.However,are these enough? I mean,something 
> depend on TOS,or something like that?

ROUTE just sets the route this packet should take once you have classified 
the packet. How you classify packets is of no concern to the ROUTE target.

> And,how can I use ROUTE target to implements policy routing? Some one 
> give me a sample?

By building iptables rules assigning different routes to different 
packets.

But most people do policy routing via the mark and normal route rules. See 
Linux Advanced Routing documentation references earlier in this thread.

Regards
Henrik
