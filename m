From: =?ISO-8859-1?Q?Pekka_Pietik=E4inen?= <pp@ee.oulu.fi>
Subject: netfilter: xt_socket: add XT_SOCKET_NOWILDCARD flag causes behavioural
 change in userspace?
Date: Tue, 22 Oct 2013 16:33:48 +0300
Message-ID: <52667EBC.5010709@ee.oulu.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: edumazet@google.com, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ee.oulu.fi ([130.231.61.23]:58509 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab3JVOZs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:25:48 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

After a kernel update to 3.11 (feat. commit 
681f130f39e10087475383e6771b9366e26bab0c) my "generate fake tcp 
connections from random ip addresses" app broke, test case as simple as 
running (on default gw of victim):

s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
s.setsockopt(socket.SOL_IP, socket.IP_TRANSPARENT, 1)

s.bind(("5.5.5.5",6666))
s.connect(("192.168.122.46",22))

---

ip route flush table 100
ip rule add fwmark 1 lookup 100
ip route add local 0.0.0.0/0 dev lo table 100

---

*mangle
-N DIVERT
-A DIVERT -j MARK --set-mark 1
-A DIVERT -j ACCEPT
-A PREROUTING -p tcp -m socket -j DIVERT

and the 3-way handshake never finishes. Without -m socket (or with the 
new --nowildcard) it does.

Bug, feature or end-user cluelessness? (no problem fixing my ruleset, 
but it's still a behaviourial change :P )

