From: "Kristof Cauwel" <kristof.cauwel@pandora.be>
Subject: multiple NAT on one box
Date: Sun, 16 Nov 2003 12:48:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000701c3ac37$81a3cbc0$0101a8c0@kc>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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

Hi boys and girls,


Just found this mailing list and I sure hope you are going to be able to
help me... I'll get started right away by describing the situation:
I have (let's say) 2 home networks and 1 linux gateway (kernel 2.4.22).
Actually the 2 networks are part of the same physical network, but they are
seperated by means of VLAN tagging. So it looks a bit like this:

NETWORK 1              NETWORK 2
------------------              ------------------
         |                                     |
      vlan1                             vlan2
------------------------------------------------
|             LINUX NAT BOX               |
------------------------------------------------
                   eth0:1/eth0:2
                            |
                    ---------------
                    INTERNET

--> vlan1 and vlan2 are virtual interfaces on eth1 (VLAN tagging enabled)
--> eth0:1 and eth0:2 are aliases of eth0

So I have 2 IP adresses towards the internet (one to serve network 1 and one
to serve network 2) and 2 different networks on my LAN side. What I want to
do is NAT all trafic comming from network 1 on the first IP and NAT all
trafic comming from network 2 on the second IP. To make my life a bit
easier, I've made sure that each VLAN corresponds with a whole subnet.
I know that you can do this stuff with the NAT module that excists but this
is a simplification of what I have to do. The idea is to create a virtual
home gateway that serves thousands of families at a time (I don't have
commercial plans with this, it's my thesis subject at university, just bo be
clear on this). So you would have way more than 2 networks on the LAN side
and I'm a bit afraid that the single nat table is gonna become too big (and
thus to slow to search in). It will also be almost impossible to remove a
user's nat rules if he disconnects from the service...
My idea was to have some sort of intermediate NAT table. If I check where a
packet came from or where it's going to (depends if it's going to or comming
from the internet), I can identify it with a user. Each user would have it's
own user-nat table (bit like user tables in the firewalling part of
iptables). In the intermediate table there would be some sort of pointer to
the user table. I hope you are getting the idea....

I've been browsing through the code and the howto's all weekend, but without
huge succes I'm afraid :-( First off all, where is the nat table searched? I
found the place where it's registered and I found a lot of code concerning
some hash table (or is this the code where you try to find a hit in the nat
table?). Am I correct in assuming that I would have to change code in not
only the nat part but also the conntrack part (if so, where is the table
updated in the conntrack code)?

Hope you don't think I'm lazy or anything but I'm sure you can understand
that it's not easy to be thrown in all that code... I'm just a newbie in
this sort of stuff, trying to survive in the code jungle :-)

Thanks for any comments, answers, ...
kristof
