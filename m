From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: differences between win and unix tcp clients.
Date: Wed, 17 Mar 2004 08:19:16 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403170815260.4188-100000@filer.marasystems.com>
References: <024b01c40b4f$e3341620$3f32a8c0@ds.ig.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fabiano Reis <silos.reis@ig.com.br>
In-Reply-To: <024b01c40b4f$e3341620$3f32a8c0@ds.ig.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 16 Mar 2004, Fabiano Reis wrote:

> To start the test I added a rule to block the connections that came 
> from the two clients I have.
> 
> iptables -A INPUT -p tcp --source 192.168.0.2 --dport 23 -j REJECT
> iptables -A INPUT -p tcp --source 192.168.0.3 --dport 23 -j REJECT

For best operation you should reject TCP packets with a "TCP RESET". See
the documentation for the REJECT target.

By default REJECT rejects the packet by returing an "ICMP Administratively 
Probited" message, and different TCP implementation behave differently in 
receiving this message.

The semantic difference between using TCP Reset or ICMP administratively 
probited is that TCP Reset tells the client that the TCP port is closed 
while the ICMP message tells the client that he is not allowed to talk to 
this port.

Regards
Henrik
