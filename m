From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Some one knows how to implement policy routing with iptables?
Date: Fri, 27 Aug 2004 09:22:57 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408270915470.22656@filer.marasystems.com>
References: <002e01c48b0e$31b253f0$8e5f78ca@nic.ecnu.edu.cn>
	<Pine.LNX.4.61.0408260917380.5483@filer.marasystems.com>
	<002b01c48b6e$f86a3570$8e5f78ca@nic.ecnu.edu.cn>
	<Pine.LNX.4.61.0408261636550.10523@filer.marasystems.com>
	<001b01c48be7$3026ec60$8e5f78ca@nic.ecnu.edu.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robbert <hanbo163com@163.com>
In-Reply-To: <001b01c48be7$3026ec60$8e5f78ca@nic.ecnu.edu.cn>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 27 Aug 2004, Robbert wrote:

> And I found the rules iptables added are linear,in fact is a link, and 
> no priority at all.Iptables only match them once,if any.So, if I give 
> these rules some priority, or I arrange them by their priority, do you 
> think that means something?

iptables is a table of rules, searched top-down. when using iptables you 
have to sort your rules according to your priority. There is no automatic 
sorting of rules by priority and you must manually sort them correctly by 
rule number.

the same thing applies when using mark based policy routing, where first 
the iptables rules needs to be correctly sorted then also the routing 
rules (ip rule ...) needs to be sorted.

Regards
Henrik
