From: <pivik@intelserv.kiev.ua>
Subject: Problen with transpartent proxy
Date: Sat, 1 Nov 2003 23:46:44 +0200 (EET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1464.192.168.0.240.1067723204.squirrel@192.168.0.1>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-u
Content-Transfer-Encoding: 8bit
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

Now i writing application on perl to calculate traffic on linux box using
iptables. Your can download it from

Now it work :) It can calculate traffic for hosts and routers, many lists
of dst/src networks may calculate separately,
Sorry docs now only in russian :(( for now

example can be download from
http://traffica.kiev.ua/download/traffica-1.9.b.3.tar.gz

but there is a problem "transparent proxy".


I have IPTABLES + SQUID transparent proxy.
==========================================
I need LOG all forward packets using -j LOG for billing reason.

I need have in the LOG address of a source. With out SQUID all ok!
iptables -I FORWARD -j LOG

But after I have setup transparent proxy all source addresses changed to
address of
my proxy server :((.

iptables  -I OUTPUT -s ! 192.168.0.1  -j LOG
Show nothing  :(

tcpdump -i eth0 not src host 192.168.0.1

Show all resuts ok like no transparent squid exists at all?
What should a do to protocol all sources with IPTABLES + transparent SQUID??
