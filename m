From: paridhi bansal <paridhibansal@yahoo.com>
Subject: pls help...urgent
Date: Thu, 6 Feb 2003 00:54:21 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030206085421.2406.qmail@web10801.mail.yahoo.com>
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

Hi!!
I have observed that  with iptables nat enabled ,
return ICMP pkts(not the TCP pkts) directly enter
INPUT hook without passing through Prerouting
hook???Why is this so????

Is it possible to redirect a pkt from INPUT hook to
prerouting hook?????

By the way, i am using iptables queuing(libipq for
queuing pkts to user spaceapplication that is doing
the nat..I am checking that if the pkt has come to
prerouting, then do so and so..Because, actually the
ICMP reply pkt is not meant for nat box but other m/c
inside LAN,my appliocation shld reNAt it to ip of
destination m/c and then forward it.. but if it enters
input hook, i have no control of redirecting the pkt
to the destination m/c on LAN even if i reNAT it
correctly)

Pls somebody help me out of this situation..IT'sreally
URGENT...............

Thanx in advvance,
Paridhi

__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
