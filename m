From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Answers to broadcast ICMP pings
Date: Wed, 11 May 2005 05:18:31 +0200
Message-ID: <1115781511.6028.17.camel@anduril.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: pascal.news@plouf.fr.eu.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Is there a particular reason for which answers to broadcast ICMP pings
to local network are flaged as INVALID, as pointed out Pascal (Cced) ?

If I do :

	ping 192.168.1.255

Where 192.168.1.0/24 is my local network, then answers sent by this
network to me are flaged INVALID, as they don't match according entry in
conntrack table :

	icmp     1 29 src=192.168.1.2 dst=192.168.1.255 type=8 code=0
	id=6448 packets=2 bytes=168 [UNREPLIED] src=192.168.1.255
	dst=192.168.1.2 type=0 code=0 id=6448 packets=0 bytes=0 mark=0
	use=1

As I fully understand why a host would ignore ICMP broacast requests, I
can't see a reason why it should ignore responses to requests it had
emitted.


-- 
http://sid.rstack.org/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
