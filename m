From: "Eugene & Yuna Portnoy" <yueupo@comcast.net>
Subject: Two Userspace Transparrent Proxies -- Please Help
Date: Mon, 21 Jul 2003 09:04:39 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000501c34fa1$ca8fda60$0101a8c0@MONSTER>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I'm trying to combine two userspace applications on a single host running
2.4 kernel Linux.
One of the applications is actually well known squid, another one is
not-so-well-known TCP proxy. I need the wan output of squid to be picked up
by this second proxy which transparency is implemented using TUN/TAP driver.

By itself, both proxies work just fine. Squid by usual "REDIRECT -- to-ports
3128" clause and the other using FMARKs, corresponding ip rules and virtual
interfaces.

So, it looks like this

TCP
(LAN) eth0 <--> tun0 <--> TCP proxy <--> tun1 <-->eth1 (WAN)

or

HTTP
(LAN) eth0 <--> Squid <-->eth1 (WAN)

I'd imagine something like this

HTTP eth0 <--> Squid
                           /\
                            |
                           V
TCP   eth0 <--> tun0 <--> TCP proxy <--> tun1 <-->eth1

My goal is to do this without modifying the code of any of the applications,
but rather using iptables/iproute2. Does it make sense?

Or maybe this is the right question? Will a locally originated packet
traverse the iptables chains from the very beginning starting from the
PREROUTING queue if routed to tun0? And if yes, how to avoid an infinite
loop then?

Thanks in advance,
Eugene.
