From: Bradley King <bking@freesurf.fr>
Subject: Re: Linux 2.6.12 REDIRECT bug?
Date: Tue, 28 Jun 2005 11:24:13 +0200
Message-ID: <42C1173D.7010802@freesurf.fr>
References: <42B956F7.8080704@freesurf.fr>
	<Pine.LNX.4.62.0506231428220.3964@kaber.coreworks.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.62.0506231428220.3964@kaber.coreworks.de>
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

Didn't hear back from anyone, this did indeed work.....(I don't need a 
response, but feared the message didn't arrive)

Thanks,
Brad

Patrick McHardy wrote:

> On Wed, 22 Jun 2005, Bradley King wrote:
>
>> [1.] One line summary of the problem:
>> the iptables REDIRECT kernel module seems to fail with kernel 2.6.12
>>
>> [2.] Full description of the problem/report:
>> Have been running previous 2.6.x versions w/o problems A command like:
>> iptables -t nat -A PREROUTING -i br0  -p tcp --dport 80 -j REDIRECT 
>> --to-port 8080
>> (used to redirect intranet traffic through a NAT/MASQUERADE firewall 
>> short circuits traffic (port 8080 see's no activity at all)
>> I tried DNAT with the same results
>> Note that the inferface is a bridge interface with an Ethernet and 
>> Wifi interface bridged togeter
>
>
> Does this patch help?
>
> Regards
> Patrick
>
>------------------------------------------------------------------------
>
>diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
>--- a/net/ipv4/ip_output.c
>+++ b/net/ipv4/ip_output.c
>@@ -188,7 +188,12 @@ static inline int ip_finish_output2(stru
> 		skb = skb2;
> 	}
> 
>-	nf_reset(skb);
>+#ifdef CONFIG_BRIDGE_NETFILTER
>+	/* bridge-netfilter defers calling some IP hooks to the bridge layer and
>+	 * still needs the conntrack reference */
>+	if (skb->nf_bridge == NULL)
>+#endif
>+		nf_reset(skb);
> 
> 	if (hh) {
> 		int hh_alen;
>  
>
