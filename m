From: Chris Friesen <chris_friesen@sympatico.ca>
Subject: Re: any plan for firewalling before the packet socket hooks?
Date: Sun, 14 Sep 2003 01:46:30 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F6400B6.2060708@sympatico.ca>
References: <3F5E9340.9040908@sympatico.ca> <20030912213131.GI4398@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030912213131.GI4398@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Tue, Sep 09, 2003 at 10:58:08PM -0400, Chris Friesen wrote:

>> Is there anything else required to allow me to create a module to 
>> bind in at that hook and do my filtering?

> Sure, you can certainly do that.  However, you can not just attach an
>  iptable to your newly created PF_PACKET hook... PF_PACKET hooks 
> receive all kinds of packets (not just IP)... and iptables is 
> something ipv4 only.

Sure, I realize it wouldn't be just for iptables.  I was expecting to
write my own netfilter module to bind in to the hook.

However, I tried this and must have missed some locking or something, since
the machine livelocked as soon as I loaded my module.

Anyways, I may take another look at it.  I'm kind of surprised that nobody
has done this before, unless there has been a convention that packet sockets
are allowed to receive everything that the system sees.

Chris
