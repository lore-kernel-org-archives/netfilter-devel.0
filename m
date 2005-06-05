From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: The big Picture of all the tables ...
Date: Sun, 5 Jun 2005 23:48:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0506052344250.11204@filer.marasystems.com>
References: <3abe8064b60ddf1a@mayday.cix.co.uk>
	<42A218B8.8060504@outerspace.dyndns.org>
	<5559d90e8cb32fad@mayday.cix.co.uk>
	<42A22703.5090000@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <42A22703.5090000@outerspace.dyndns.org>
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

On Sat, 4 Jun 2005, Jonas Berlin wrote:

> I mean
>
>  iptables ... -j QUEUE
>
> I don't know where in the chain it should/can go..

NF_QUEUE (aka -j QUEUE in iptables) can be returned by any netfilter 
hook handler, and terminates that handler/table.

When the packet returns from the queue it continues at the next 
handler/table in the same hook or leaves the hook as usual if there is no 
more to process in this hook.

Note: this is not limited to iptables. The above applies to any netfilter 
modules as QUEUE is a core netfilter function, not an iptables function.

Regards
Henrik
