From: Chris Friesen <chris_friesen@sympatico.ca>
Subject: any plan for firewalling before the packet socket hooks?
Date: Tue, 09 Sep 2003 22:58:38 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F5E935E.5020006@sympatico.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I'm interested in filtering packets before the packet socket gets a copy
of them, and after the packet socket writes them but before it gets to
the device.

Would it be sufficient to add a new NF_HOOK call (for
PF_PACKET/NF_PACKET_PRE_ROUTING or something similar) in
netif_receive_skb() to handle the incoming side?

Is there anything else required to allow me to create a module to bind
in at that hook and do my filtering?

In my personal case, I'm trying to filter the traffic going into my
vmware session, and it seems to use a packet socket to do networking,
which means that the normal iptables stuff doesn't affect it at all.  I'm
sure there would be other uses for this kind of thing.

Thanks,

Chris
