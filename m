From: "Tharanga" <tharanga@roomsnet.com>
Subject: Netfilter API and  a New firewall implementation
Date: Mon, 19 Feb 2007 14:31:15 +0600
Message-ID: <001201c75400$5479a560$2aff7893@RoomsNet.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Dear All,

Iam Tharanga and currenty a computer science student. Iam going to implement
a distributed firewall on linux 2.6.X kernel  (As my research project ). and
after reading lot of materials thought to use netfilter frame work. my main
objective is to build a centralized policy management server and
unicast/multicast rules propagation algoritm to its peer nodes.(update peer
nodes)

You guys are experts on this.but still i dont know how to block packets in
realtime withoout restarting my program or unloading/loading modules. its
basically like IPTABLES -A option . so please expalin me how to append a
firewall rule (iam not using IPTABLES, going to use my own firewall ) to my
program. so once the peer node receive the new rule from the polcy
management server it can block that traffic realtime.

and also i  like to know some suggestions from you guys abot my distributed
firewall please let me know ur comments on that so i can add more features
to that implementation.

thought to add

centrilized policy manager (it handles distributed server firewall rules,
one zone file for each host with its policies like DNS zone concept)
centralized firewall monitoring module  (php and AJAX based) / integrating
with Opensource SMS gateway and admininstraotrs can query the firewall
status via SMS

secure protocol to distribute firewall rules among peers.  in order to
prevent man-in the middle attacks and firewall poisoning.

sorry for the huge mail..please help me to achive my objectives..

Many thanks and have a great day !

Tharanga
