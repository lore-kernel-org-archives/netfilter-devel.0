From: "Alexandre Chaves Fonseca" <alex.f-linux@specialist.com.br>
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?
Date: Thu, 10 Mar 2005 14:56:50 -0300
Message-ID: <01cd01c5259a$89ab8dc0$0a00a8c0@alexandre>
References: <019201c52592$e181a4b0$0a00a8c0@alexandre>
	<42307E2A.5060806@trash.net>
	<019f01c52595$dd3a56b0$0a00a8c0@alexandre>
	<42308509.4040902@trash.net>
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

you say that I have to do this:

iptables -t nat -A OUTPUT -p tcp -s 127.0.0.1 -d 127.0.0.1 --dport 25 -j 
DNAT --to 192.168.0.50:25
iptables -t nat -A POSTROUTING -p tcp -s 127.0.0.1 -d 192.168.0.50 --dport 
25 -j SNAT --to 192.168.0.10

(192.168.0.10 is my IP)

right ?

but it doesn't work yet...

what I am doing wrong ?

thanks so much,
alexandre

----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Alexandre Chaves Fonseca" <alex.f-linux@specialist.com.br>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Thursday, 10 March, 2005 14:34
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?


>> NAT: no longer support implicit source local NAT
>> NAT: packet src 192.168.0.50 -> dst 127.0.0.1
>
> This means that NAT no longer fixes up the source address when
> doing DNAT in LOCAL_OUT, so the packet goes out with 127.0.0.1
> as source. You need to SNAT it manually if you want to get
> the old behaviour.


---------------------------------------------------------------
Esta mensagem foi verificada pelo e-mail seguro wstation.
McAfee VirusScan / Vacina v4444 atualizada em 10/03/2005
powered by wstation (www.wstation.com.br)
