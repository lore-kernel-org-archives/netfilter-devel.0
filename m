From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in 2.6.22.6
Date: Tue, 06 Nov 2007 15:05:12 +0100
Message-ID: <47307498.70104@trash.net>
References: <001601c81ccc$682bb4a0$bb0b10ac@FireEye.com> <47303E9D.2050909@trash.net> <001e01c82077$b4d67610$6500a8c0@ronPc> <47306B0E.7050401@trash.net> <001801c8207c$00307b70$6500a8c0@ronPc>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060900080400090104060606"
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: ron lai <ronlai@cs.stanford.edu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <001801c8207c$00307b70$6500a8c0@ronPc>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060900080400090104060606
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

ron lai wrote:
> My ruleset is
> iptables -t nat -A POSTROUTING -s 172.16.119.91 -j SNAT --to-source 
> 172.16.255.123
> 
> I am using a bridge containing only one physical interface and the FTP 
> traffic goes through the bridge.


That explains it. The bridge netfilter code calls the IP POST_ROUTING
hook for outgoing packets, but the packet already went through it
during forwarding. Please try this patch, which makes the bridge
netfilter code only call the IP hook for packets that also came in
on the bridge.




--------------060900080400090104060606
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 3ee2022..d8e5c94 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -773,7 +773,7 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff **pskb,
 	}
 #endif
 
-	if (!nf_bridge)
+	if (!nf_bridge || !nf_bridge->physindev)
 		return NF_ACCEPT;
 
 	if (!realoutdev)

--------------060900080400090104060606--
