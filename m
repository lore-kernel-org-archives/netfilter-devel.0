From: Dirk Morris <dmorris@metavize.com>
Subject: -m physdev iptables: Invalid Argument
Date: Fri, 24 Oct 2003 11:13:14 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F996BBA.5070106@metavize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

I'm running 2.6.0-test8 using the -m physdev --physdev-in (or 
--physdev-out) and I'm getting invalid argument.
This is with iptables 1.2.9-rc1.

This problem is referenced in a couple places on the web:
http://small.dropbear.id.au/docs/adslfirewall.html

Is this a bug? (if so I can do a formal bug report)
Or has this functionality been dropped?
If so, how can I filter based on the ethernet device of a bridged packet?

~/ # sudo /sbin/iptables -m physdev -t mangle -A FORWARD --physdev-in 
eth0 -p udp --source 10.0.0.0/255.255.255.0  --destination-port 7:7 -j 
DIVERT --to-port 20259
iptables: Invalid argument
~/ # sudo /sbin/iptables -m physdev -t nat -A PREROUTING --physdev-in 
eth0 -p tcp --source 10.0.0.0/255.255.255.0  --destination-port 7:7 -j 
REDIRECT --to-port 20259
iptables: Invalid argument

-dmorris
