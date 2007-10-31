From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_TCPMSS loading issue
Date: Wed, 31 Oct 2007 12:31:58 +0100
Message-ID: <472867AE.5020702@trash.net>
References: <Pine.LNX.4.64.0710301853110.31325@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54440 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXJaLen (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:34:43 -0400
In-Reply-To: <Pine.LNX.4.64.0710301853110.31325@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Using iptables 1.4.0rc1(svn7083), iptables seems to have problems 
> autoloading TCPMSS:
> 
> 18:53 ichi:/ws/iptables # strace -e open ./iptables -t mangle -A OUTPUT 
> -d 1.3.3.7 -p tcp --syn -j TCPMSS --clamp-mss-to-pmtu
> open("/ws/iptables/extensions/libxt_tcp.so", O_RDONLY) = 3
> open("/ws/iptables/extensions/libxt_TCPMSS.so", O_RDONLY) = 3
> iptables: No chain/target/match by that name
> 
> 18:53 ichi:/ws/iptables # modinfo xt_TCPMSS
> filename:       
> /lib/modules/2.6.23.1-900.ccj58-regular/kernel/net/netfilter/xt_TCPMSS.ko
> alias:          ip6t_TCPMSS
> alias:          ipt_TCPMSS
> description:    x_tables TCP MSS modification module
> author:         Marc Boucher <marc@mbsi.ca>
> license:        GPL
> srcversion:     F9280CB30B14724A70F943F
> depends:        x_tables
> vermagic:       2.6.23.1-900.ccj58-regular SMP mod_unload 586 
> 
> The aliases are there (a common source of errors is lacking these 
> aliases). If I manually `modprobe xt_TCPMSS`, iptables succeeds. Any 
> idea?


Works fine for me. Does "modprobe ipt_TCPMSS" work?
