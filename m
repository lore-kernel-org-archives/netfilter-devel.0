From: yh <walteyh@sohu.com>
Subject: [bug-reaport] netfilter extentions iplimit mod bugs.
Date: Mon, 14 Jul 2003 11:27:28 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030714112728.24bdb6aa.walteyh@sohu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

HI guys,

I download netfilter extentions via cvs yestoday, the iplimit code has some bug, in 214 lin in linux/net/ipv4/netfilter/ipt_connlimit.c

static struct ipt_match connlimit_match
= { { NULL, NULL }, "connlimit", &match, &check, &destroy, THIS_MODULE };

notic the "connlimit", it's must should be "iplimit", I don't know when it was changed, but the userspace tool iptable haven't changed yet.  so when you type "iptables -A INPUT -p tcp --syn --dport http -m iplimit --iplimit-above 4 -j REJECT" , the result is "Invailid command."..:)

change the "connlimit" into "iplimit", recompiled kernel, it's OK now.;)

by the way, I wan to know when the netfilter will wok will in kernel 2.5.* ? until 2.6 release? ( yestoday, I compiled kernel 2.5.74, build netfilter with in, but iptables reaport that "no 'filter' table in kernel".)

-------------
thx all guy work for netfilter project..
