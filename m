From: "zhou fan" <zhoufanking@hotmail.com>
Subject: A question about process on hook
Date: Tue, 12 Apr 2005 11:28:33 +0800
Message-ID: <BAY16-F3950D8555F85F461047F3BA5330@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312; format=flowed
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

hi:
   when i read the linux network source code ,i encountered a problem:
in ip_rcv(),there presented "NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, dev, 
NULL,ip_rcv_finish);" 

Does this means that ip_rcv_finish is a default func on the 
NF_IP_PRE_ROUTING HOOK?
Does "(okfn)(*skb);" on this HOOK point equals to "ip_rcv_finish(*skb);"?
If i registed a handler,take pre_route_handler for example, on the 
NF_IP_PRE_ROURING HOOK,dose the kernel processes the skb first by my 
pre_route_handler then ip_rcv_finish finally?


Thank you for your help in advance!

_________________________________________________________________
√‚∑—œ¬‘ÿ MSN Explorer:   http://explorer.msn.com/lccn  
