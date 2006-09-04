From: Patrick McHardy <kaber@trash.net>
Subject: Re: statistic match support in iptables snapshots
Date: Mon, 04 Sep 2006 15:37:59 +0200
Message-ID: <44FC2C37.6080607@trash.net>
References: <BAY103-F36FEB3485724F0D8FFDB56B2330@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-F36FEB3485724F0D8FFDB56B2330@phx.gbl>
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

Marco Berizzi wrote:
> 6455   387300 SNAT       tcp  --  *      eth0    hdsl_ip     
> !172.16.0.0/12       multiport dports
> 20,21,80,123,443,2080,8080,8201,10000,8102,1443 statistic mode nth every
> 2 to:adsl_b_ip
> 3227   193620 SNAT       tcp  --  *      eth0    hdsl_ip     
> !172.16.0.0/12       multiport dports
> 20,21,80,123,443,2080,8080,8201,10000,8102,1443 statistic mode nth every
> 2 packet 1 to:adsl_a_ip
> 
> This is a tcpdump capture taken on the eth0 (external nic):
> 
> 14:46:16.783465 IP (tos 0x0, ttl  64, id 28099, offset 0, flags [DF],
> proto: TCP (6), length: 60) adsl_ip_a.3808 > 217.199.3.51.80: S,
> 14:46:17.493837 IP (tos 0x0, ttl  64, id 1810, offset 0, flags [DF],
> proto: TCP (6), length: 60) adsl_ip_b.2130 > 217.199.3.51.80: S,
> 14:46:17.634456 IP (tos 0x0, ttl  64, id 59103, offset 0, flags [DF],
> proto: TCP (6), length: 60) hdsl_ip.3929 > 217.199.3.34.80: S,
> 14:46:17.672954 IP (tos 0x0, ttl  64, id 25522, offset 0, flags [DF],
> proto: TCP (6), length: 60) adsl_ip_b.1291 > 217.199.3.51.80: S,
> 14:46:19.316781 IP (tos 0x0, ttl  64, id 5334, offset 0, flags [DF],
> proto: TCP (6), length: 60) adsl_ip_a.3296 > 207.46.115.7.80: S,
> 14:46:20.231297 IP (tos 0x0, ttl  64, id 18663, offset 0, flags [DF],
> proto: TCP (6), length: 60) adsl_ip_b.3196 > 207.46.115.13.80: S,
> 14:46:21.186856 IP (tos 0x0, ttl  64, id 12641, offset 0, flags [DF],
> proto: TCP (6), length: 60) hdsl_ip.1196 > 216.120.228.12.80: S,
> 14:46:27.217423 IP (tos 0x0, ttl  64, id 54559, offset 0, flags [DF],
> proto: TCP (6), length: 60) adsl_ip_b.2128 > 207.46.115.14.80: S,
> 14:46:27.919826 IP (tos 0x0, ttl  64, id 25297, offset 0, flags [DF],
> proto: TCP (6), length: 60) adsl_ip_a.4349 > 207.46.115.3.80: S,
> 14:46:31.697147 IP (tos 0x0, ttl  64, id 21406, offset 0, flags [DF],
> proto: TCP (6), length: 60) adsl_ip_b.1545 > 207.46.115.6.80: S,
> 14:46:32.484631 IP (tos 0x0, ttl  64, id 2001, offset 0, flags [DF],
> proto: TCP (6), length: 60) hdsl_ip.4650 > 207.46.115.14.80: S,
> 14:46:34.996772 IP (tos 0x0, ttl  64, id 16676, offset 0, flags [DF],
> proto: TCP (6), length: 60) adsl_ip_b.2644 > 195.149.150.239.80: S,
> 14:46:35.726995 IP (tos 0x0, ttl  64, id 36671, offset 0, flags [DF],
> proto: TCP (6), length: 60) adsl_ip_a.3929 > 85.248.115.230.80: S,
> 
> As you may see sometimes the hdsl_ip isn't nated,
> so I have modified the the rule:
> 
> 421    25260 SNAT       tcp  --  *      eth0    hdsl_ip     
> !172.16.0.0/12       multiport dports
> 20,21,80,123,443,2080,8080,8201,10000,8102,1443 statistic mode nth every
> 2 to:adsl_b_ip
> 211    12660 SNAT       tcp  --  *      eth0    hdsl_ip     
> !172.16.0.0/12       multiport dports
> 20,21,80,123,443,2080,8080,8201,10000,8102,1443 statistic mode nth every
> 2 to:adsl_a_ip
> 
> but results doesn't change...
> Am I missing anything?

All NAT targets are terminal, so the first rule already eats half the
packets and the second one only matches on one half of the remaining
half. Try without nth in the second line.
