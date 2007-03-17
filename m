From: Sergei Lavrov <lavrov2005@yahoo.com>
Subject: Need fast reply: how does iptables interact with kernel space code
	??
Date: Sat, 17 Mar 2007 07:39:32 -0700 (PDT)
Message-ID: <354050.44203.qm@web36413.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

I went through some of the iptables code because I
want to understand how iptables interact with the
kernel space.

For example, the following command redirects all the
web traffic to the local port 10080.

iptables -t nat -A PREROUTING -i ppp0 -p tcp -j
REDIRECT --to-port 10080 --dport 80

I went through extensions/ipt_REDIRECT.c and
libiptc/libiptc.c and libiptc/libip4tc.c.

But I still don't understand what iptables does to the
kernel so that the kernel will redirect the traffic ?
Exactly, what does iptables communicate to the kernel
? Can someone explain the gist to me ??

For understanding of the kernel side, should I read
iptable_filter.c, ip_nat_standalone.c, or
ip_nat_rule.c ??

Thanks,

Sergei


 
____________________________________________________________________________________
Food fight? Enjoy some healthy debate 
in the Yahoo! Answers Food & Drink Q&A.
http://answers.yahoo.com/dir/?link=list&sid=396545367
