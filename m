From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: QUEUE target and IPT_CONTINUE verdict ?
Date: Sun, 15 May 2005 22:51:08 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0505152244290.28907@filer.marasystems.com>
References: <200505131729.39430.laurent.guyon@adelux.fr>
	<876ef97a05051510053c6827c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Laurent Guyon <laurent.guyon@adelux.fr>,
	nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
In-Reply-To: <876ef97a05051510053c6827c2@mail.gmail.com>
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

On Sun, 15 May 2005, Tobias DiPasquale wrote:

> I don't believe that such state is hard to add, it would just waste
> space. Feel free to code up a patch and submit it.

It is harder than it may seem unfortunately. QUEUE is implemented in 
netfilter as a hook verdict. Because of this QUEUE is terminal for 
iptables just like ACCEPT/DROP.

-j QUEUE

makes iptables return the IPT_QUEUE verdict to the netfilter kernel, which 
then sends this to the queue handler (normally ip_queue with it's netlink 
socket). On reinject netfilter continues on the next hook handler of the 
same hook, or returns the packet to the kernel if there is no more 
handlers on this hook.

Remembering the iptables state is a bit tricky here as you are several 
layers away from iptables.  (netfilter hook interface, iptables table 
interface). You also have time to worry about as the iptable may have 
been modified when the packet is later reinjected.

Regards
Henrik
