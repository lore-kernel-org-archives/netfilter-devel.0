From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Some one knows how to implement policy routing with iptables?
Date: Fri, 27 Aug 2004 09:15:31 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408270900160.22656@filer.marasystems.com>
References: <002e01c48b0e$31b253f0$8e5f78ca@nic.ecnu.edu.cn>
	<Pine.LNX.4.61.0408260917380.5483@filer.marasystems.com>
	<002b01c48b6e$f86a3570$8e5f78ca@nic.ecnu.edu.cn>
	<Pine.LNX.4.61.0408261636550.10523@filer.marasystems.com>
	<000701c48be6$28141440$8e5f78ca@nic.ecnu.edu.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robbert <hanbo163com@163.com>
In-Reply-To: <000701c48be6$28141440$8e5f78ca@nic.ecnu.edu.cn>
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

> Does the way to implement policy routing with ROUTE target have some LIMIT? Is it only fit to some certain issues?

Not sure, I have never used it, only the mark based policy routing.

> And, the normal way ,I mean use iptables mark the packet ,then find the 
> corresponding ip rule, and use the corresponding route table, has some 
> shortage?

It gets rather complex if you need to have many different policies for 
different cases.

> Any way to make it better?

The interactions between ROUTE and the rest of netfilter needs to be 
investigated a little more to make it behave more normal when you play 
with the routes.

Regards
Henrik
