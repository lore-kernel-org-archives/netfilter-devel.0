From: Amin Azez <azez@ufomechanic.net>
Subject: Re: -m owner for incoming packets
Date: Tue, 06 Mar 2007 12:48:47 +0000
Message-ID: <45ED632F.6070909@ufomechanic.net>
References: <1173136142.45eca30ed0cdc@webmail.alinto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: octane indice <octane@alinto.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1173136142.45eca30ed0cdc@webmail.alinto.com>
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

* octane indice wrote, On 05/03/07 23:09:
> Hello
> 
> the man says that -m owner is here for locally generated packet.
> Is it possible to use it for incoming packet?
> 
> As of:
> iptables -A INPUT -p tcp -m owner --cmd-owner /usr/local/sbin/myprog -j ACCEPT
> 

No. Until a packet has actually been received by a process it is
impossible to tell which process may receive it. The process that
finally receives it might not even be running (or have an open socket)
at the point at which iptables handles the packet.  There may be more
than one running process, all of which appear to be candidates to
receive the packet, but only one will.

Consider the case of the apache webserver where many processes are
ACCEPT'ing on the same socket, but only one of the will receive the
packet. It so happens that with apache all the processes have the same
owner but it need not be the case.

The final reason (apart from it not being meaningful) is that it can't
actually be done; the task table may not be safe to examine during
iptables interrupt time even if we were able to work out which process
would receive the packet.

The only answer that fits your model is to invent a new chain that was
fakingly called from the kernel as an application's system call to read
the packet was being processed. Probably the only available targets
would be drop or accept or return.

Sam
