From: "Alexandre Chaves Fonseca" <alex.f-linux@specialist.com.br>
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?
Date: Thu, 10 Mar 2005 14:23:22 -0300
Message-ID: <019f01c52595$dd3a56b0$0a00a8c0@alexandre>
References: <019201c52592$e181a4b0$0a00a8c0@alexandre>
	<42307E2A.5060806@trash.net>
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

This means that I have this ?!

Before (with kernel <= 2.6.10), I had the rule:

iptables -t nat -A OUTPUT -p tcp -s 127.0.0.1 -d 127.0.0.1 --dport 25 -j 
DNAT --to 192.168.0.50:25

And now, with 2.6.11, the rule doesn't work... and syslog show:

NAT: no longer support implicit source local NAT
NAT: packet src 192.168.0.50 -> dst 127.0.0.1

Alexandre

----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Alexandre Chaves Fonseca" <alex.f-linux@specialist.com.br>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Thursday, 10 March, 2005 14:04
Subject: Re: Patch for CONFIG_IP_NF_NAT_LOCAL in 2.6.11 ?


>> Someone has a patch to CONFIG_IP_NF_NAT_LOCAL in kernel 2.6.11
>
> It was enabled unconditionally.


---------------------------------------------------------------
Esta mensagem foi verificada pelo e-mail seguro wstation.
McAfee VirusScan / Vacina v4444 atualizada em 10/03/2005
powered by wstation (www.wstation.com.br)
