From: "doxboy" <doxboy@163.com>
Subject: =?gb2312?B?SSB3YW5uYSBzaW11bGF0ZSB0aGUgYWN0aW9uIG9mIGlwdGFibGVzIC10IG5hdCAtQSBQUkVS
	T1VUSU5HIC1pIGV0aDEgLXAgdGNwIC1zIDE5Mi4xNjguMS4xIC0tZHBvcnQgODAgLWogUkVE
	SVJFQ1QgLS10by1wb3J0IDgwODA=?=
Date: Fri, 16 May 2003 12:59:07 +0800 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EC4701B.000019.23264@bj245.163.com>
Mime-Version: 1.0
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

hi all
I am just a green hand of iptables.
My work needs a function similar with  what the command
"iptables -t nat -A PREROUTING -i eth1 -p tcp -s 192.168.1.1 --dport 80 -j REDIRECT --to-port 8080" does.
In fact,that is one auth windows pops up when the interior user visits 
the internet via IE or othere web browsers.

but now we can't use iptables in our OS(vxworks).

I wanna know how the REDIRECT command(as above)  does work in details
so I can futher my work.

so anyone could help me?thx in advance.





=============================================================
年度十佳女性站点评选开赛了！               http://www.nease.net
百分百女友 - 春季选美活动!                 http://love.163.com
