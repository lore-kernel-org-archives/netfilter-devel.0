From: "Alexandre Chaves Fonseca" <alex.f-linux@specialist.com.br>
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?
Date: Thu, 10 Mar 2005 16:39:40 -0300
Message-ID: <028a01c525a8$e71e4020$0a00a8c0@alexandre>
References: <019201c52592$e181a4b0$0a00a8c0@alexandre>
	<42307E2A.5060806@trash.net>
	<019f01c52595$dd3a56b0$0a00a8c0@alexandre>
	<42308509.4040902@trash.net>
	<01cd01c5259a$89ab8dc0$0a00a8c0@alexandre>
	<42308B4E.3030303@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
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

I put a "-j LOG" before in both rules:

iptables -t nat -A OUTPUT -p tcp -s 127.0.0.1 -d 127.0.0.1 --dport 25 -j 
LOG --log-prefix "OUT = "
iptables -t nat -A OUTPUT -p tcp -s 127.0.0.1 -d 127.0.0.1 --dport 25 -j 
DNAT --to 192.168.0.50:25
iptables -t nat -A POSTROUTING -p tcp -s 127.0.0.1 -d 192.168.0.50 --dport 
25 -j LOG --log-prefix "POST = "
iptables -t nat -A POSTROUTING -p tcp -s 127.0.0.1 -d 192.168.0.50 --dport 
25 -j SNAT --to 192.168.0.10

But in syslog only show the first rule (I tried "telnet 127.0.0.1 25")...

Mar 10 16:14:09 backup kernel: OUT = IN= OUT=lo SRC=127.0.0.1 DST=127.0.0.1 
LEN=60 TOS=0x10 PREC=0x00 TTL=64 ID=27422 DF PROTO=TCP SPT=2107 DPT=25 
WINDOW=32767 RES=0x00 SYN URGP=0
Mar 10 16:14:12 backup kernel: OUT = IN= OUT=lo SRC=127.0.0.1 DST=127.0.0.1 
LEN=60 TOS=0x10 PREC=0x00 TTL=64 ID=27424 DF PROTO=TCP SPT=2107 DPT=25 
WINDOW=32767 RES=0x00 SYN URGP=0
Mar 10 16:17:06 backup kernel: OUT = IN= OUT=lo SRC=127.0.0.1 DST=127.0.0.1 
LEN=60 TOS=0x10 PREC=0x00 TTL=64 ID=13046 DF PROTO=TCP SPT=3133 DPT=25 
WINDOW=32767 RES=0x00 SYN URGP=0

some ideia?


----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Alexandre Chaves Fonseca" <alex.f-linux@specialist.com.br>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Thursday, 10 March, 2005 15:00
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?


> Alexandre Chaves Fonseca wrote:
>> you say that I have to do this:
>> iptables -t nat -A OUTPUT -p tcp -s 127.0.0.1 -d 127.0.0.1 --dport 25 -j 
>> DNAT --to 192.168.0.50:25
>> iptables -t nat -A POSTROUTING -p tcp -s 127.0.0.1 -d 
>> 192.168.0.50 --dport 25 -j SNAT --to 192.168.0.10
>> but it doesn't work yet...
>
> Check if the rules are used and what happens on the network ..


---------------------------------------------------------------
Esta mensagem foi verificada pelo e-mail seguro wstation.
McAfee VirusScan / Vacina v4444 atualizada em 10/03/2005
powered by wstation (www.wstation.com.br)
