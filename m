From: "qianunix" <qianunix@126.com>
Subject: About tcp conntrack with UNREPLIED and ESTABLISHED
Date: Mon, 13 Oct 2003 10:45:20 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E1A8sgG-0005by-HU@kashyyyk.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

When I was using netfilter,rebooted system,then I found a conntrack:

tcp      6 430290 ESTABLISHED src=61.172.241.50 dst=1.2.3.4 sport=21 dport=1055 [UNREPLIED] src=1.2.3.4 dst=61.172.241.50 sport=1055 dport=21 use=1

the srp 1.2.3.4 is my firewall, and my doubt is that why the sport is 21? I think 21 must be a dport, and that UNREPLIED and ESTABLISHED is here, it is impossible, so I think the tcp conntrack with UNREPLIED is invalid,don't you think so?  
 please help me,thanks.
