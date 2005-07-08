From: Dirk Morris <dmorris@metaloft.com>
Subject: Re: REDIRECT differences in 2.6.12.2
Date: Fri, 08 Jul 2005 11:50:35 -0700
Message-ID: <42CECAFB.6070709@metaloft.com>
References: <42CADB0F.5010804@metaloft.com> <42CDD0DA.20303@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42CDD0DA.20303@trash.net>
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

eve: iptables -t nat -A PREROUTING -p tcp --destination-port 1234 -j 
REDIRECT --to-port 1234
eve: echo 255 > /proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid
eve: nc -p -l 1234

alice: telnet bob 1234

messages on eve (192.168.2.2) shows:

Jul  8 11:47:34 cartman kernel: ip_ct_tcp: invalid packet ignored IN= 
OUT= PHYSIN=eth0 SRC=192.168.2.1 DST=192.168.2.3 LEN=60 TOS=0x10 
PREC=0x00 TTL=64 ID=18927 DF PROTO=TCP SPT=33080 DPT=1234 SEQ=1119072953 
ACK=0 WINDOW=5840 RES=0x00 SYN URGP=0 OPT 
(020405B40402080A18B1070F0000000001030307)


192.168.2.1 is alice, 192.168.2.3 is bob

Thanks,
-Dirk

Patrick McHardy wrote:

> Dirk Morris wrote:
>
>> notice how the syn/ack comes from eve instead of bob, and it only 
>> matches 1 packet (the SYN I assume)
>> I suspect the syn/ack isnt matching in the conntrack table for some 
>> reason?
>> Could it be because the syn is marked, but the syn/ack isnt?
>
>
> No, that doesn't affect association with a conntrack entry. Please retry
> after doing "echo 255 > /proc/sys/net/ipv4/netfilter/ip_ct_log_invalid"
> and "modprobe ipt_LOG".
>
> Regards
> Patrick
>
