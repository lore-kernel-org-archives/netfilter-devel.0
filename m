From: "Middour, Chris" <cmiddour@amplifynet.com>
Subject: Delete Conntrack Entries From Userspace?
Date: Mon, 3 Feb 2003 17:09:22 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <95E2AB7E9225D211ABE100104B9E8E119E4C48@anet1.amplifynet.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have a need to remove a conntrack entry for ip protocol 50 (the IPSEC
protocol).

I've found that using the tcp-reset target (-j REJECT --reject-with
tcp-reset) works very well for this when the TCP protocol is involved, but
unfortunately, that doesn't help with protocol 50.

I've tried using the normal reject rule (-j REJECT), and that does indeed
send an icmp port unreachable message, but it does not remove the conntrack
entry.

Is there any way to get iptables to remove a conntrack entry (without coding
it myself in the kernel?)

Thanks very much!

--Chris Middour
