From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Some one knows how to implement policy routing with iptables?
Date: Sat, 28 Aug 2004 09:15:23 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408280912520.17572@filer.marasystems.com>
References: <7C9884991ADAE0479C14F10C858BCDF591E362@alderaan.smgtec.com>
	<000e01c48ccc$6bd0a770$8e5f78ca@nic.ecnu.edu.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robbert <hanbo163com@163.com>
In-Reply-To: <000e01c48ccc$6bd0a770$8e5f78ca@nic.ecnu.edu.cn>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 28 Aug 2004, Robbert wrote:

> If there are some way to arrange the rules in iptables sorted, so the 
> administrator do not borther with which rules he added first and which 
> last , this kind of thing make sense ?

Yes, by using a frontend implementing the sorting, or by defining a tree 
of chains defining priority levels.

> And,since the ROUTE targe now can only let us specify the interface and 
> the gateway , then if there is a way can let us specify the route table, 
> so we do NOT need to mark the packet first then find the ip rules,route 
> table,then the next hop and we can routing faster.Does this thought very 
> weird?Is it valuable?

It is better to fix the route table lookup to be efficient rather than 
a linerar search than to make iptables look into doing this.

There is apparently ongoing work to optimize the route slow path 
considerably, if done correctly this should solve the above.

Regards
Henrik
