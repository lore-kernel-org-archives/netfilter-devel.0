From: Grzegorz Janoszka <Grzegorz.Janoszka@pro.onet.pl>
Subject: New target IPMARK
Date: Thu, 29 May 2003 18:08:44 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.53.0305291747380.588@galaxy.uci.agh.edu.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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


Hello,

I'm new here and sorry for my poor English :)

I'm a member of a isp-linux mailing list for Polish Linux ISP's. A few
days ago there was a discussion "HTB and tousand queues". Some people
complained about big cpu load when they have for example a linux router
with tousand users, tousand separate htb queues and tousand entries long
POSTROUTING or PREROUTING mangle chains - they mark packets going to ever
user with uniq mark (based on user ip address), and then, with fw filter,
the packet is inserted into a adequate queue.

We knew about
http://www.linux.org/docs/ldp/howto/Adv-Routing-HOWTO/lartc.adv-filter.hashing.html
but it was a little 'magic' and not so fine.

So I have written the IPMARK target wich can replace tousand of single
mangle/mark entries with only one. This target has three parameters: which
addres to use, the AND mask and the OR mask. The source or destination IP
address is taken, ther order of its bytes is reversed to meet "human order
of bytes": 192.168.0.1 is 0xc0a80001, and then this address is binary
"anded" with AND mask and binary "ored" with OR mask.

We had earlier many entries like that:
iptables -t mangle -A POSTROUTING -o eth3 -d 192.168.5.2 -j MARK
 --set-mark 0x10502
iptables -t mangle -A POSTROUTING -o eth3 -d 192.168.5.3 -j MARK
 --set-mark 0x10502
...

and now we have only one:

iptables -t mangle -A POSTROUTING -o eth3 -j IPMARK --addr=dst
 --and-mask=0xffff --or-mask=0x10000

Our CPU system load decreased twice and everything is fine... And here is
the question: should I post the patch here or, in your opinion, is this
unnecessary, superflous to the kernel and so on.
If yes, I will post the patch here.

Best regards, and thanks for netfilter :)

-- 
Grzegorz Janoszka
