From: Hellwolf Misty <hellwolf@seu.edu.cn>
Subject: the connection is ESTABLISHED but UNREPLIED?What's up?
Date: Wed, 17 Aug 2005 17:11:06 +0800
Message-ID: <1124269866.6032.1.camel@cocteau.hellwolf-misty.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

I got this from /proc/net/ip_conntrack:

tcp      6 425241 ESTABLISHED src=218.93.152.132 dst=61.178.246.98
sport=58070 dport=80 packets=1 bytes=40 [UNREPLIED] src=61.178.246.98
dst=218.93.152.132 sport=80 dport=58070 packets=0 bytes=0 mark=0 use=1

But I don't understand why did it happen.
