From: Torge Szczepanek <netfilter-devel@szczepanek.de>
Subject: iptables bad byte counter?!?
Date: 05 Jun 2002 21:07:35 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023304055.2845.69.camel@cygnus>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

I am using iptables 1.2.5 on SuSE 8.0 using the standard SuSE kernel
2.4.18-4GB, with some minor modifications (I increased the number of
maximum devices in net/core/dev.c, which is normally limited to 100). I
am accounting traffic using iptables [...] -n -v -x -Z. I am doing this
hourly.

Sometimes (once a day) iptables is reporting the wrong byte counter for
only some (about 10) ip adresses out of 400. 

All my users are on a vpn connection (poptop) server and I am setting up
a rule for every user by executing the following in my /etc/ppp/ip-up
script:

iptables -A TRAFFIC -i eth0 -o ppp+ -s ! x.y.0.0/16 -d $SUBNET/24 -j
TRAF$SUBNET
$IPTAB -A TRAF$SUBNET -d $5

(I only want to account incoming traffic, which is not comming from a
specific Class-B network). In my crontab I have a script, that is
dumping the iptables output to a file.

I am getting byte counters like this:

18446744073707058701

The byte counters differ (18446744073707 is mostly the same) so I think
this might be an overflow of a (longint?!?) counter.

The machine is under very heavy load, because it terminates more vpn
connections than planned. This does not happen on another machine, which
is under normal load. The other machine has EXACTLY the same setup as
the machine where I have these problems.

I am sorry that I cannot provide more detailed information about this
behaviour, since I can not play with my machine setup, because there are
about 2300 possible users, who would get very angry. :-]

Is this already known?!?

As a small bugfix I am now grepping out traffic, which has a byte
counter beginning with 184467440737. I am also writing on a trafficlog
daemon, which is doing the accounting using libipulog, which is very
more efficient, since I do not have to setup single rules for every user
and do not have to traverse many iptables chains for every packet (just
one single rule to log all traffic to userspace).
