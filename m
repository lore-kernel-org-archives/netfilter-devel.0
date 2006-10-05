From: "Retesh Chadha" <retesh.chadha@gmail.com>
Subject: Can i have a rate limit per source IP Address in IPSet?
Date: Thu, 5 Oct 2006 12:36:48 +0530
Message-ID: <b322db070610050006v73e69354t8d0106f2eec51597@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I have following questions regarding iptables -

1. Say I have 2 Ips in one IPset, and a rate limiting rule as follows -

ipset -N KNOWN iphash
ipset -A KNOWN 192.168.1.89
ipset -A KNOWN 192.168.3.114
iptables -A INPUT_CHAIN -m set --set KNOWN src -m limit --limit
100/second --limit-burst 5 -j ACCEPT

I have observed that the rate limit is the cumulative limit, and not per IP.
Is it possible to have a limit of say 100pps from each IP in KNOWN IPSET.

2. Is there a limit on the number of IPs in an ipset ?

3. I have observed that the limit rate in a rule can be as much as
10000packets/per/second. If say I am using an ipset with 1000 elements
and the rate limit 10000 pps (which is a limitation and also
cumulative), then effectively per IP limit becomes 10pps which cause
the problem. Any clue how to solve this.

Thanks & Regards
Retesh Chadha
