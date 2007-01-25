From: Retesh <retesh.chadha@gmail.com>
Subject: ULOG with hashlimit not working as expected
Date: Thu, 25 Jan 2007 11:39:44 +0530
Message-ID: <b322db070701242209l2a8cbef4yc8869e592dec8162@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi All
I am facing a issue with ULOG along with hashlimit, where hashlimit is
not working as expected.

I have rules as follows

1. iptables -A INPUT -m set --set SET1 src -m hashlimit --hashlimit
100/s --hashlimitname foo1 -j ACCEPT
2. iptables -A INPUT -m set --set SET1 src -m hashlimit --hashlimit
200/s --hashlimitname foo2 -j DROP
3. iptables -A INPUT -m set --set SET1 src -m hashlimit --hashlimit
1/min --hashlimitname foo3 -j ULOG
4. iptables -A INPUT -m set --set SET1 src -m hashlimit --hashlimit
1/min --hashlimitname foo4 -j LOG
5. iptables -A INPUT -j DROP

Here I have noticed that hashlimit of 1/min is not working, even
though the hashlimits of 1st 2 rules is working fine. What is
happening is that I am bombarding the system from a source endpoint in
SET1, with 300/s.
My expectation is that 100 packets will be accepted (1), another 100
will be dropped (2), and rest all will be dropped with ULOG/LOG
happening 1 per minutes (3,4,5). But ULOG is not happening at 1/min.
What i see is that if say I bombard for 90 seconds at the rate of
300/s, ULOG/LOG messages that are generated are 11.

Anyone aware if this is a  limitation of hashlimit or am I missing
something here.

Thanks in advance

With Regards
Retesh Chadha
