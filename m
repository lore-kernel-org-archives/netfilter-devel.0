From: Mario Tasev <netfilter@mail.bg>
Subject: TTL Target DOESN'T work with kernel 2.6.x!
Date: Mon, 23 Feb 2004 07:11:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402230711.04608.netfilter@mail.bg>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've tried the latest pom-ng.The patch applies successful.
I precompile the kernel 2.6.3 after that iptables 1.2.9.
I insert PREROUTING rules in the mangle table to set incoming TTL.
No erros. I'm pinging some hosts but there ttl wasn't set. Using
tcpdump i saw that ttl was changed (may be) it looks like that.
Local programs show me the real ttl, not the set one. I tried to route to
my other pc it doesn't work (my ISP sets incoming ttl to 1)...so whats the 
point? This patch doesn't work correctrly or maybe i'm wrong.
Does anybody know where the problem is? Did anybody test?

Mario
