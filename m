From: <linuxmail@ntlworld.com>
Subject: 2.6.0, advanced routing and masquerade
Date: Fri, 19 Dec 2003 15:58:45 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031219155846.RKME29762.mta02-svc.ntlworld.com@[10.137.100.62]>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hi,

Sorry for posting this to development - I did try the user list and didn't get a reply. From further experimentation (and implementing stable 2.6.0 for good measure) it looks like a bug.

I've been running my current network configuration for over a year on the 2.4.xx kernels without any issues. I'm now using using 2.6.0 and without any configuration changes I'm having issues with advanced routing combined with masquerading.

To reproduce the problem here is a simplified breakdown of my configuration.

eth0 : Internal Network
eth1 : Cable Modem
eth2 : ADSL modem

The default route for all traffic is the ADSL modem but certain protocols/machines route across the cable modem. The cable modem only has a single publish IP (bound to eth1) and, therefore, it is necessary to NAT.

So....

$ iptables -A POSTROUTING -s 192.168.0.10 -d ! 192.168.0.0/24 -o eth1 -t nat -j MASQUERADE

$ ip rule add from 192.168.0.10 table cm prio 1000

$ ip route add default via 1.2.3.254 dev eth1 table cm

----
$ ip rule list
0:      from all lookup local
1000:   from 192.168.0.10 lookup cm
32766:  from all lookup main
32767:  from all lookup default

$ ip route show table cm
default via 1.2.3.254 dev eth1

$ iptables -t nat -L -n
iptables -t nat -L

Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  192.168.10     !192.168.0.0/24

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

------

This works fine on the 2.4.22 kernel but in 2.6 traffic destined for the cable modem generates a "MASQUERADE: Route sent us somewhere else." error.

However, replacing the MASQUERADE config with SNAT (which I'd rather not do in production given the IP is dynamic on that gateway) -

iptables -A POSTROUTING -s 192.168.0.1 -d ! 192.168.0.0/24 -t nat -o eth1 -j SNAT --to-source 1.2.3.4

- Works fine!!!

I know this bug cropped up in 2.4.23 and a fix was issued. Could someone confirm there is a similar issue in 2.6.0?

Sorry if I've missed the point completely.

Steve.

-----------------------------------------
Email provided by http://www.ntlhome.com/
