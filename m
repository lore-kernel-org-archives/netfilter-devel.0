From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: LVS HA
Date: Fri, 23 Apr 2004 09:54:18 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404230946300.16668-100000@filer.marasystems.com>
References: <20040423040711.GA13648@maluco.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: lvs-users@LinuxVirtualServer.org,
   Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ulysses Almeida <munky@maluco.com.br>
In-Reply-To: <20040423040711.GA13648@maluco.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 23 Apr 2004, Ulysses Almeida wrote:

>   For this task, I wonder to implement in NF_PREROUTING NetFilter hook
> and NF_QUEUE. I would send the packet to user space, and with a daemon
> on user space, I create a copy of this packet and send to another
> daemon on Backup LVS, while the original packet goes back to kernel
> space to finish its journey. So if LVS fails, the daemon on Backup LVS
> could reinject the pending packets on kernel again, with libipq (can
> this reinjection be done?)  and no one(Real Servers and clients) would
> notice the fail.

I doubt this will give any meaningful results, or even be needed as TCP/IP
is designed to handle slight packet losses by retransmission and packet
loss is a normal nature of IP networking.

What you really want to have replicated is the LVS session state details
on your current connections.  For this there already exists LVS tools.

>   - Can the reinjection be done on Backup LVS, from user space with
>   some kernel interface? Maybe with libipq, and the same iptables
>   queue?

Not using libipq but you can use tun/tap. But as I said above I doubt this 
is something you need to bother with as the hosts already do 
retransmissions if needed due to packet loss.

>   - If yes, what happens with ip connection track? 'Cose we're talking
>   about packets from an alredy established connection.

See the LVS documentation on how to syncronise LVS state tables. This is 
not an netfilter/iptables question and is quite well documented in LVS.


If you are using iptables NAT/conntrack then it would be a
netfilter/iptables question, and work is apparently ongoing for adding
session state syncronisation to iptables.

Regards
Henrik
