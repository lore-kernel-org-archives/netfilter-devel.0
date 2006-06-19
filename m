From: Manish Jain <jain_m79@yahoo.com>
Subject: New to IPSets - Not working as expected
Date: Sun, 18 Jun 2006 22:36:46 -0700 (PDT)
Message-ID: <20060619053646.47093.qmail@web42203.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

I want to dump all packets coming from IP 192.168.1.18
in syslog. For this, I have created following ipset
and iptable. But it is not working for me. Please
guide me.

ipset -N test2 ipmap --from 192.168.1.1 --to
192.168.255.255
iptables -A INPUT -m set --set test2 src -j LOG

Best Regards,
Manish Jain

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
