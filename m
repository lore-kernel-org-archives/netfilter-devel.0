From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [BUG] ipt_SAME rule can't be deleted
Date: Mon, 6 Dec 2004 08:34:48 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412060821280.10926@filer.marasystems.com>
References: <20041204150223.GA10247@dfbbb.opencjk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Fang Han <fanghan@opencjk.org>
In-Reply-To: <20041204150223.GA10247@dfbbb.opencjk.org>
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

On Sat, 4 Dec 2004, Fang Han wrote:

> Kernel 2.6.9 ac2
>
> Using the next test command:
>
> /sbin/iptables  -t nat -I POSTROUTING -s 192.168.100.23 -o eth0 -j SAME --to 192.168.1.60
> /sbin/iptables  -t nat -D POSTROUTING -s 192.168.100.23 -o eth0 -j SAME --to 192.168.1.60
>
> generate error:
> iptables: Bad rule (does a matching rule exist in that chain?)

This is quite likely due to that kernel land pointer within the target 
info...

         u_int32_t *iparray;

If I am right the same problem applies to -m limit and any other extension 
storing private kernel side stuff within it's info data..

Regards
Henrik
