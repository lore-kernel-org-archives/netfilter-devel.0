From: Patrick McHardy <kaber@trash.net>
Subject: Re: REDIRECT differences in 2.6.12.2
Date: Sat, 09 Jul 2005 16:52:05 +0200
Message-ID: <42CFE495.9000904@trash.net>
References: <42CADB0F.5010804@metaloft.com> <42CDD0DA.20303@trash.net>
	<42CECAFB.6070709@metaloft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dirk Morris <dmorris@metaloft.com>
In-Reply-To: <42CECAFB.6070709@metaloft.com>
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

Dirk Morris wrote:
> eve: iptables -t nat -A PREROUTING -p tcp --destination-port 1234 -j 
> REDIRECT --to-port 1234
> eve: echo 255 > /proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid
> eve: nc -p -l 1234
> 
> alice: telnet bob 1234
> 
> messages on eve (192.168.2.2) shows:
> 
> Jul  8 11:47:34 cartman kernel: ip_ct_tcp: invalid packet ignored IN= 
> OUT= PHYSIN=eth0 SRC=192.168.2.1 DST=192.168.2.3 LEN=60 TOS=0x10 
> PREC=0x00 TTL=64 ID=18927 DF PROTO=TCP SPT=33080 DPT=1234 SEQ=1119072953 
> ACK=0 WINDOW=5840 RES=0x00 SYN URGP=0 OPT 
> (020405B40402080A18B1070F0000000001030307)

You didn't mention anything about a bridge. Please describe your setup
in full detail. And please use IPs instead of names.

Regards
Patrick
