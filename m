From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: REDIRECT
Date: Mon, 13 Dec 2004 16:59:40 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412131657200.10816@filer.marasystems.com>
References: <1538174627.20041213183631@server.titansoft.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: r00t <root@server.titansoft.ru>
In-Reply-To: <1538174627.20041213183631@server.titansoft.ru>
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

On Mon, 13 Dec 2004, r00t wrote:

> Ok, but if i use this:
>
> -A PREROUTING -p tcp -j QUEUE
> -A PREROUTING -i eth1 -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3128

You can't. QUEUE terminates the PREROUTING hook.

You need to queue before nat PREROUTING if you want to apply NAT rules on 
packets after QUEUE reinjects them to the kernel, i.e. from mangle or raw 
tables.

Regards
Henrik
