From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: statistic match support in iptables snapshots
Date: Mon, 04 Sep 2006 15:05:59 +0200
Message-ID: <BAY103-F36FEB3485724F0D8FFDB56B2330@phx.gbl>
References: <44F6F2D5.3030301@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44F6F2D5.3030301@trash.net>
To: kaber@trash.net
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

Patrick McHardy wrote:

>Marco Berizzi wrote:
> > Sorry for breaking you again: is not possible
> > having multiple counters with 'nth mode'?
>
>No, why is that useful? You can just use multiple matches.

Hi Patrick,

me again sorry.
I'm testing 2.6.18-rc6 + iptables-1.3.5-20060902
I'm trying to do a simple load-balacing between
two adsl lines.
This is my postrouting chain in the nat table:

6455   387300 SNAT       tcp  --  *      eth0    hdsl_ip      !172.16.0.0/12 
       multiport dports 20,21,80,123,443,2080,8080,8201,10000,8102,1443 
statistic mode nth every 2 to:adsl_b_ip
3227   193620 SNAT       tcp  --  *      eth0    hdsl_ip      !172.16.0.0/12 
       multiport dports 20,21,80,123,443,2080,8080,8201,10000,8102,1443 
statistic mode nth every 2 packet 1 to:adsl_a_ip

This is a tcpdump capture taken on the eth0 (external nic):

14:46:16.783465 IP (tos 0x0, ttl  64, id 28099, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.3808 > 217.199.3.51.80: S,
14:46:17.493837 IP (tos 0x0, ttl  64, id 1810, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.2130 > 217.199.3.51.80: S,
14:46:17.634456 IP (tos 0x0, ttl  64, id 59103, offset 0, flags [DF], proto: 
TCP (6), length: 60) hdsl_ip.3929 > 217.199.3.34.80: S,
14:46:17.672954 IP (tos 0x0, ttl  64, id 25522, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.1291 > 217.199.3.51.80: S,
14:46:19.316781 IP (tos 0x0, ttl  64, id 5334, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.3296 > 207.46.115.7.80: S,
14:46:20.231297 IP (tos 0x0, ttl  64, id 18663, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.3196 > 207.46.115.13.80: S,
14:46:21.186856 IP (tos 0x0, ttl  64, id 12641, offset 0, flags [DF], proto: 
TCP (6), length: 60) hdsl_ip.1196 > 216.120.228.12.80: S,
14:46:27.217423 IP (tos 0x0, ttl  64, id 54559, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.2128 > 207.46.115.14.80: S,
14:46:27.919826 IP (tos 0x0, ttl  64, id 25297, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.4349 > 207.46.115.3.80: S,
14:46:31.697147 IP (tos 0x0, ttl  64, id 21406, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.1545 > 207.46.115.6.80: S,
14:46:32.484631 IP (tos 0x0, ttl  64, id 2001, offset 0, flags [DF], proto: 
TCP (6), length: 60) hdsl_ip.4650 > 207.46.115.14.80: S,
14:46:34.996772 IP (tos 0x0, ttl  64, id 16676, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.2644 > 195.149.150.239.80: S,
14:46:35.726995 IP (tos 0x0, ttl  64, id 36671, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.3929 > 85.248.115.230.80: S,

As you may see sometimes the hdsl_ip isn't nated,
so I have modified the the rule:

421    25260 SNAT       tcp  --  *      eth0    hdsl_ip      !172.16.0.0/12  
      multiport dports 20,21,80,123,443,2080,8080,8201,10000,8102,1443 
statistic mode nth every 2 to:adsl_b_ip
211    12660 SNAT       tcp  --  *      eth0    hdsl_ip      !172.16.0.0/12  
      multiport dports 20,21,80,123,443,2080,8080,8201,10000,8102,1443 
statistic mode nth every 2 to:adsl_a_ip

but results doesn't change...
Am I missing anything?

14:55:39.524501 IP (tos 0x0, ttl  64, id 55823, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.2843 > 207.46.115.7.80: S,
14:55:39.535730 IP (tos 0x0, ttl  64, id 13613, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.3219 > 64.202.119.131.80: S,
14:55:40.468068 IP (tos 0x0, ttl  64, id 12719, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.2253 > 207.46.115.13.80: S,
14:55:40.779029 IP (tos 0x0, ttl  64, id 35299, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.3051 > 72.14.221.147.80: S,
14:55:45.413782 IP (tos 0x0, ttl  64, id 5390, offset 0, flags [DF], proto: 
TCP (6), length: 60) hdsl_ip.3908 > 194.20.158.101.80: S,
14:55:45.702878 IP (tos 0x0, ttl  64, id 9809, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.1443 > 195.110.122.162.80: S,
14:55:45.972760 IP (tos 0x0, ttl  64, id 31590, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.2182 > 195.110.122.162.80: S,
14:55:46.322893 IP (tos 0x0, ttl  64, id 4527, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.1222 > 195.110.122.162.80: S,
14:55:46.360383 IP (tos 0x0, ttl  64, id 64233, offset 0, flags [DF], proto: 
TCP (6), length: 60) hdsl_ip.4970 > 207.46.115.2.80: S,
14:55:46.456994 IP (tos 0x0, ttl  64, id 56844, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.4875 > 195.110.126.136.80: S,
14:55:46.564861 IP (tos 0x0, ttl  64, id 34169, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.4448 > 212.239.41.101.80: S,
14:55:48.146673 IP (tos 0x0, ttl  64, id 964, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.2207 > 207.46.115.3.80: S,
14:55:48.575692 IP (tos 0x0, ttl  64, id 62414, offset 0, flags [DF], proto: 
TCP (6), length: 60) hdsl_ip.1461 > 213.92.76.114.80: S,
14:55:48.710787 IP (tos 0x0, ttl  64, id 30414, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.3742 > 212.162.68.25.80: S,
14:55:49.454996 IP (tos 0x0, ttl  64, id 56845, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.4875 > 195.110.126.136.80: S,
14:55:50.086620 IP (tos 0x0, ttl  64, id 54523, offset 0, flags [DF], proto: 
TCP (6), length: 60) hdsl_ip.2023 > 213.92.76.114.80: S,
14:55:50.297110 IP (tos 0x0, ttl  64, id 49994, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.4284 > 207.46.115.8.80: S,
14:55:52.519131 IP (tos 0x0, ttl  64, id 919, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.1180 > 207.46.115.14.80: S,
14:55:52.569335 IP (tos 0x0, ttl  64, id 60555, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.4164 > 207.46.115.6.80: S,
14:55:53.318467 IP (tos 0x0, ttl  64, id 1412, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.1104 > 207.46.115.6.80: S,
14:55:53.952161 IP (tos 0x0, ttl  64, id 31980, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.4005 > 213.92.76.114.80: S,
14:55:54.102702 IP (tos 0x0, ttl  64, id 36293, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.3646 > 213.92.76.114.80: S,
14:55:55.914552 IP (tos 0x0, ttl  64, id 9611, offset 0, flags [DF], proto: 
TCP (6), length: 60) hdsl_ip.3636 > 194.20.158.101.80: S,
14:55:56.230173 IP (tos 0x0, ttl  64, id 57379, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.4272 > 195.110.122.162.80: S,
14:55:56.363610 IP (tos 0x0, ttl  64, id 25956, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.1527 > 207.46.115.2.80: S,
14:55:57.472111 IP (tos 0x0, ttl  64, id 9560, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.4967 > 72.14.221.99.80: S,
14:55:57.980268 IP (tos 0x0, ttl  64, id 9540, offset 0, flags [DF], proto: 
TCP (6), length: 60) hdsl_ip.4185 > 72.14.221.104.80: S,
14:55:59.532299 IP (tos 0x0, ttl  64, id 62589, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.1091 > 207.46.115.7.80: S,
14:56:00.471094 IP (tos 0x0, ttl  64, id 24450, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_a.3713 > 207.46.115.13.80: S,
14:56:00.636757 IP (tos 0x0, ttl  64, id 37289, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.2526 > 195.110.122.162.80: S,
14:56:01.101303 IP (tos 0x0, ttl  64, id 38086, offset 0, flags [DF], proto: 
TCP (6), length: 60) hdsl_ip.1506 > 195.110.126.136.80: S,
14:56:01.292540 IP (tos 0x0, ttl  64, id 3092, offset 0, flags [DF], proto: 
TCP (6), length: 60) adsl_ip_b.3287 > 217.212.240.172.80: S,
