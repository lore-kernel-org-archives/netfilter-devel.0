From: Old Cowhand <oldcowhanddoug@yahoo.com>
Subject: Connection tracking bug with DNAT?
Date: Sat, 27 Mar 2004 08:24:15 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040327162415.63769.qmail@web21323.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hello everyone--

I posted this question to the regular netfilter list,
but never received a response.

I have what should be a simple configuration for
proxy, but it doesn't seem to work, and I don't know
why.  I've reproduced the problem in multiple
locations with different 2.4 kernels.  Here's the test
layout in ASCII (I hope you're using monospaced
fonts!):

                                   |--Web server
       eth0                   eth1 |  192.168.64.15/24
PC---------------Linux 2.4.19-------
172.16.1.2/30    172.16.1.1/30     |
                 192.168.64.1/24   |--Web server
                                      192.168.64.5/24

My DNAT rule:

iptables -t nat -A PREROUTING -s 172.16.1.2 -d
192.168.64.5 -p tcp --dport 80 -j DNAT --to
192.168.64.15

In tcpdump, I see the HTTP request come from the PC
with a destination of .5 on eth0.  I see the DNAT rule
match in iptables -L -n -v -t nat.  I see the HTTP
request go on eth1 to .15 (DNAT rule works).  I see
the HTTP server at .15 reply to 172.16.1.2 on eth1. 
The data is dropped and never returned after that. 
The reply never appears on eth0.

ip_conntrack shows SYN_SENT [UNREPLIED] on that
connection.

A few notes:

1) The PC can talk directly to .15's Web server with
no problems.  Routing is just fine.

2) If I configure .5 on the Linux box and ditch the
second Web server, everything works normally.

3) The DNAT rule is the ONLY iptables rule in place.

4) I have no dynamic routing, proxy arp, route filters
or other configurations in place.  It's simple static
routing.

I'm stumped.  Ultimately, I want to be able to take IP
addresses for my customers and point any Web requests
to a server that returns a page saying "Sorry, you
didn't pay your bill."  That's why #2 above won't work
for me in the long run.

Doug

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
