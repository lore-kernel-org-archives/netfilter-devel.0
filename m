From: "liran tal" <liransgarage@gmail.com>
Subject: The cause of NAT/Masquerading not perfomed
Date: Wed, 19 Sep 2007 16:05:05 +0200
Message-ID: <3ed55890709190705t229ccb08i59f27daa0308bb2a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Netfilter Developer Mailing List" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hey everyone,

What can be attributed as the cause for the problem of not performing an
NAT/Masquerade?
This is a basic scenario where a computer on the LAN attempts to reach a
computer beyond
the WAN port and what happens is that no Masquerading is being performed -
i.e: with a sniffer
I can see that the IP that was received is of the LAN computer (wasn't
replaced by the WAN IP address).

I can answer the question above with several possibilities:
1. wrong iptables rules
2. no NAT support compiled in kernel (or as module)
3. (bad network driver?)

I've had this problem with a kernel 2.4 and now I migrated completely to
kernel 2.6 (2.6.10)
and still encounter this problem.

Any comment on this issue would mean alot to me.

Regards,
Liran.
