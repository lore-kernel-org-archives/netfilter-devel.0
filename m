From: Martijn Lievaart <m@rtij.nl>
Subject: Re: [PATCH] Warn people that ipchains and ipfwadm are going away.
Date: Thu, 23 Sep 2004 16:56:12 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4152E40C.5080705@rtij.nl>
References: <1095721742.5886.128.camel@bach>	<Pine.LNX.4.58.0409221347010.23967@tux.rsn.bth.se>	<Pine.LNX.4.53.0409220800200.2147@chaos.analogic.com>
	<200409220841.34453.gene.heskett@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: gene.heskett@verizon.net
In-Reply-To: <200409220841.34453.gene.heskett@verizon.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Gene Heskett wrote:

>[root@gene root]# grep attackalert /var/log/messages*
>/var/log/messages.1:Sep 16 18:09:16 gene portsentry[1159]: 
>attackalert: UDP scan from host: home1.bellatlantic.net/199.45.32.43 
>to UDP port: 32771
>/var/log/messages.1:Sep 16 18:09:16 gene portsentry[1159]: 
>attackalert: Host 199.45.32.43 has been blocked via wrappers with 
>string: "ALL: 199.45.32.43"
>/var/log/messages.1:Sep 16 18:09:17 gene portsentry[1159]: 
>attackalert: Host 199.45.32.43 has been blocked via dropped route 
>using command: "/sbin/iptables -I INPUT -s 199.45.32.43 -j DROP"
>/var/log/messages.1:Sep 16 18:09:17 gene portsentry[1159]: 
>attackalert: UDP scan from host: home1.bellatlantic.net/199.45.32.43 
>to UDP port: 32771
>/var/log/messages.1:Sep 16 18:09:17 gene portsentry[1159]: 
>attackalert: Host: home1.bellatlantic.net/199.45.32.43 is already 
>blocked Ignoring
>
>Time to send another nastygram to verizon since thats one of their 
>nameservers, and clear out that address from the hosts.deny file.
>
>FWIW, the last time that happened, in April 2003, the hack attempt  
>trashed a siemans router and I had to replace it with that linksys.  
>Must be time to change the user and password in it again too...
>
>FWIW, verizon has apparently a problem keeping their nameservers from 
>being hacked.
>  
>

Isn't this just the replies to legitimate dns queries? Wouldn't be the 
first time legitimate traffic is recognised as a portscan.

HTH,
M4
