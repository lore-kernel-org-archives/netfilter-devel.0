From: kreuzritter2000@gmx.de
Subject: Suggestion: Marker option in iptable, netfilter chains
Date: Sun, 9 Nov 2003 04:46:21 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200311090446.21825.kreuzritter2000@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I have a suggestion about a new feature.
 ( i don't know if such thing allready exists so i assume it does not exist)


Normally you create a bash scipt where you set up all your rules of
your iptables firewall.

A bash script like this example:
(i know this example is unsecure and shound't be used in reality,
so it's just for showing what i want to tell you)

----------------
#!/bin/sh
iptables -P INPUT DROP
iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 29 -j REJECT
iptables -A INPUT -i eth0 -p tcp --dport 50 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 130 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 804 -j DROP
iptables -A INPUT -i eth0 -p tcp --dport 21456 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 2955 -j ACCEPT
-----------------

Now when you start this script and
check your iptable rules again with 
$ iptables -L 

you get something like this:
------------------
Chain INPUT (policy DROP)
target     prot opt source               destination
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:http
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:ftp
REJECT     tcp  --  anywhere             anywhere           tcp dpt:msg-icp 
reject-with icmp-port-unreachable
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:re-mail-ck
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:cisco-fna
DROP       tcp  --  anywhere             anywhere           tcp dpt:804
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:21456
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:2955
------------------


This firewall example is very easy to understand, but
sometimes your firewall is very complex and the rules chain is very long with 
branches to other chains etc..
In such a situtaion it would be great to have a thing like a "marker"
in the rule chain when using "iptables -L".
This marker would help you to find the exact position in your firewall script,
in other words the place where the marker was set.
Such a feature would be very handy for debugging the firewall.


To show what i meant we assume we have a marker option
in iptables which could be used in our firewall script.
Let's say this option can be used with a -S option:
-S = Set Marker

Now let's take a look at the same script but with a marker option:
------------------
#!/bin/sh
iptables -P INPUT DROP
iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 29 -j REJECT
iptables -S Marker-1
iptables -A INPUT -i eth0 -p tcp --dport 50 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 130 -j ACCEPT
iptables -S Marker-2
iptables -A INPUT -i eth0 -p tcp --dport 804 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 21456 -j DROP
iptables -S Marker-3
iptables -A INPUT -i eth0 -p tcp --dport 2955 -j ACCEPT
-----------------

When we now view our firewall rules with 
iptables -L we would see something like this:
------------------
Chain INPUT (policy DROP)
target     prot opt source               destination
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:http
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:ftp
REJECT     tcp  --  anywhere             anywhere           tcp dpt:msg-icp 
reject-with icmp-port-unreachable
Marker 1 was set!
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:re-mail-ck
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:cisco-fna
Marker 2 was set!
DROP       tcp  --  anywhere             anywhere           tcp dpt:804
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:21456
Marker 3 was set!
ACCEPT     tcp  --  anywhere             anywhere           tcp dpt:2955
------------------


It should be clear that such a feature would be realy helpfull for debugging 
the firewall script, especially when it is a very long firewall with a lot of 
ramifications.

Now my question is, would such a feature in iptables/netfilter be possible?


Best Regards,
 Oliver C.


Please send me a copy of your answers to me because i am not on the 
mailinglist.







 
