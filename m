From: Matthias Benkmann <haferfrost@web.de>
Subject: [feature request] packet replication for easier NAT
Date: Thu, 10 Oct 2002 17:36:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021010173619.65782c29.haferfrost@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

We have a Linux box as NAT router. Sometimes the users in our LAN want to
set up listening sockets on random ports (e.g. server written as compsci
homework). Reconfiguring the NAT router every time to route the respective
port to the right computer is unfeasible. I'd like to have a feature that
replicates connection request packets coming from the Internet and sends
them to all computers in the network. The computer listening on the
requested port would acknowledge the request and the other computers would
drop or reject it. If the NAT router does not route reject packets, only
the acknowledgement will get out on the Internet and the connection will
get established. 
This feature (if it can be implemented, I don't know enough about TCP/IP
and NAT to say for sure) would make NAT a lot more transparent. It would
lose the firewall aspects but that's no worse than a direct connection. 
It would fail sometimes (2 programs on different computers picking the
same port for listening) but in a small home LAN that can be coordinated
easily. On the bright side, this feature should make it possible to use a
lot of services from behind a NAT router without any additional
configuration effort.

MSB

-- 
An army of sheep led by a lion
is stronger than an army of lions
led by a sheep.
