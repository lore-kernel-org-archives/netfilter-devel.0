From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Fri, 11 Jan 2008 14:25:30 +0100
Message-ID: <47876E4A.2010608@trash.net>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>	 <9a4a382a0712200320mec29cm3c4ac7df62ff6799@mail.gmail.com>	 <476A5130.6050800@trash.net>	 <9a4a382a0712200521r6b8caee3v7b168d3d54b1a278@mail.gmail.com>	 <476CC345.7050108@trash.net>	 <9a4a382a0712260154l5f0773fy1d2da6cc94a780c6@mail.gmail.com>	 <4777DB2F.4010307@trash.net>	 <9a4a382a0801020118n4166e505l5eb84a9f07f620be@mail.gmail.com>	 <9a4a382a0801110010h3b4ed334sb53392ab564c00b5@mail.gmail.com>	 <47876013.2040405@trash.net> <9a4a382a0801110453m66b42329w15c6ae3b68d37699@mail.gmail.com> <478767A7.9000807@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080408000204020106070707"
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: =?ISO-8859-1?Q?Damien_Th=E9bault?= <damien.thebault@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51853 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757866AbYAKNZg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 08:25:36 -0500
In-Reply-To: <478767A7.9000807@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080408000204020106070707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Patrick McHardy wrote:
> Damien Thébault wrote:
>> On the router, I'm using this script :
>>
>> ifconfig eth0 0.0.0.0 up
>> brctl addbr br0
>> brctl addif br0 eth0
>> ifconfig br0 192.168.1.70 up
>> ifconfig br0:0 192.168.2.70 up
>> iptables -t nat -A POSTROUTING -d 192.168.2.0/24 -j MASQUERADE
>> iptables -t nat -A PREROUTING -d 192.168.2.250 -j DNAT
>> --to-destination 192.168.2.50 

>
> Thanks. Its the DNAT rule thats causing this, the bridge netfilter code
> calls dst_output directly for bridged dnated frames, causing these
> hook invocations:
>
>                PREROUTING
> dst_output()    POSTROUTING
>                FORWARD
>                POSTROUTING
>
>
> which is obviously broken. I'll see if I can come up with a fix for this.

It appears this has always been broken. Could you test this patch please?

The bridge code only calls dst_output to get a new destination MAC
address for the DNATed packet when the new destination is reachable
on the same bridge, so this patch simply hands the packet to the
neighbour output function without going through the IP stack.



--------------080408000204020106070707
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index c1757c7..362fe89 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -285,12 +285,17 @@ static int br_nf_pre_routing_finish_bridge(struct sk_buff *skb)
 	skb->nf_bridge->mask ^= BRNF_NF_BRIDGE_PREROUTING;
 
 	skb->dev = bridge_parent(skb->dev);
-	if (!skb->dev)
-		kfree_skb(skb);
-	else {
+	if (skb->dev) {
+		struct dst_entry *dst = skb->dst;
+
 		nf_bridge_pull_encap_header(skb);
-		skb->dst->output(skb);
+
+		if (dst->hh)
+			return neigh_hh_output(dst->hh, skb);
+		else if (dst->neighbour)
+			return dst->neighbour->output(skb);
 	}
+	kfree_skb(skb);
 	return 0;
 }
 

--------------080408000204020106070707--
