From: Ulysses Almeida <munky@maluco.com.br>
Subject: Multiple links / multiple routes
Date: Thu, 27 Jan 2005 18:37:00 -0300
Message-ID: <20050127213700.GA24329@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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

Hi folks,

    I Have the following scenario:

  - One server with two links:
    * First link has dynamic IP (cheap one)
    * Second links has fixed IP (expensive one)

  - Link(1) is used by my intranet users, they use Internet
  services by this link. To do this, I just setuped Link(1)
  as my default gw. And made my server a linux router.
    # echo 1 > /proc/sys/net/ipv4/ip_forward
    # iptables -t nat -A POSTROUTING -s <intranet_net> -o <eth_link(1)> -j MASQUERADE
    # ip route add default via <link(1)_gw> dev <eth_link(1)>

  - Link(2) is used by some incomming requests from internet
  to this server. This services are HTTP and SMTP services.
  To use second link properly, I setuped iproute2
    # echo 100 link2 >> /etc/iproute2/rt_tables
    # ip route add <intranet_net> dev <eth_intranet> src <server_intranet_ip> table link2
    # ip route add <link(2)_net> dev <eth_link(2)> src <server_link(2)_ip> table link2
    # ip route add default via <link(2)_gw> dev <eth_link(2)> table link2
    # ip rule add from <server_link(2)_ip> lookup link2

  Almost every thing works at this point. All my intranet users, are
using Link(1) to navigate on Internet, use MSN/ICQ/Jabber, and etc.
  When someone on Internet want's to access my WEB page, they use
server_link(2)_ip to get into. The same when they want to accesse their
e-mails. If some MTA on internet, needs to deliver some e-mail to my
smtp server, it also uses the server_link(2)_ip. And it's work fine.

  There's only one problem. If my MTA wants to deliver an e-mail, it
tries it by Link(1), what's reasonable, because that's the server default
gateway. But  it's not good, when the link(1) (dynamic IP) is a black
listed one

  To solve this problem, on 2.4 time I played with iptables and iproute2:

  Every outgoing packet, with destination port set to 25, I will mark.
    # iptables -t mangle -A OUTPUT -p tcp --dport 25 -j MARK --set-mark 0x02

  Now I can say to iproute2 use the right routing table.
    # ip rule add fwmark 0x02 lookup link2

  Still not working, if i log outgoing packts, with destination port 25,
I see SMTP packets going through eth_link(2), but with server_link(1)_ip.
Let's handle those packets a little more.
    # iptables -t nat -I POSTROUTING -o <eth_link(2)> -j SNAT --to-source <server_link(2)_ip>

  Yes, now I'm sure every outgoing trafic through eth_link(2) is going
with the correct IP.


  Everything above use to work on 2.4.5 vanilla kernel. Now i'm trying the same at 2.6.10 kernel, and that's the result:

  # iptables -t mangle -m tcp -I OUTPUT -p tcp --dport 25 -j LOG --log-level 3 --log-prefix 'mangle OUTPUT: '
  # iptables -t nat -m tcp -I POSTROUTING -p tcp --dport 25 -j LOG --log-level 3 --log-prefix 'nat POSTROUTING:
  # iptables -t mangle -m tcp -I PREROUTING -p tcp --sport 25 -j LOG --log-level 3 --log-prefix 'mangle PREROUTING: '
  # iptables -t nat -m tcp -I PREROUTING -p tcp --sport 25 -j LOG --log-level 3 --log-prefix 'nat PREROUTING: '
  # iptables -t mangle -m tcp -I INPUT -p tcp --sport 25 -j LOG --log-level 3 --log-prefix 'mangle INPUT: '
  # iptables -t filter -m tcp -I INPUT -p tcp --sport 25 -j LOG --log-level 3 --log-prefix 'filter INPUT: '


  To simulate, I started a telnet some_smtp_server 25. I could see:

  - packet on output mangle -> postrouting nat.
  - packet on prerouting mangle.

  After packet appears on mangle's prerouting, it disappers? I can't
understando why. What could broke this on 2.6 series?

  I tried with 2.6.5 before, and got the same result.

  I alredy tried with -j ROUTE from pom-ng, but it's not working too, or maybe a missunderstood the man page.

  I don't know if i'm missing some conntrack with this multiple routing table or something like this.... And the most strange is the "answer" packet appearing on mangle PREROUTING, but not on filter INPUT.

  Any help, I thanks in advance.

  Regards.

-- 
    .~.  Ulysses Almeida
   / V \  munky@maluco.com.br
 / (   ) \  Seja livre, use GNU/Linux! 
   ^^-^^
