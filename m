From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in  
   2.6.22.6
Date: Wed, 07 Nov 2007 12:55:21 +0100
Message-ID: <4731A7A9.1050606@trash.net>
References: <W352381485970601194435879@nocme1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040901050101030304000807"
Cc: ron lai <ronlai@cs.stanford.edu>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: "bdschuym@pandora.be" <bdschuym@telenet.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59318 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbXKGLzm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 06:55:42 -0500
In-Reply-To: <W352381485970601194435879@nocme1bl6.telenet-ops.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040901050101030304000807
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

bdschuym@pandora.be wrote:
>> Patrick McHardy wrote:
>> I can reproduce this with forwarding between two bridges.
>> The reason is that skb->nf_bridge still contains the data
>>from the first bridge and so br_netfilter thinks this is
>> a bridged packet. I don't know how this is supposed to work,
>> but it seems to me that on packets going out a bridge device
>> this should be reset in case it originates from a different
>> bridge (actually I think it should be reset unconditionally
>> but that would probably break bridged DNAT).
>>
>> Bart, what do you think about changing this:
> 
> (sorry for the webmail mess)
> I think that would work. It shouldn't be reset unconditionally at that point since we allow IP dnating of bridged packets (bridged-and-DNAT'ed case).

Could you check the attached patch?

 > Another solution I think is this:
> in br_nf_post_routing():
> change
> if (!nf_bridge)
> to
> if (!nf_bridge || !(nf_bridge->mask & BRNF_BRIDGED_DNAT))

Wouldn't that break the regular case of packets forwarded
through a single bridge?

> This regression was introduced when the ip_out sabotage stuff was removed. br_nf_post_routing should now only consider bridged IP packets.

Yes, though the underlying problem seems to be that skb->nf_bridge
has no clearly defined lifetime. We want to pass the bridge port
information up exactly one layer, and then it should disappear.
But that seems to require sprinkling nf_bridge_put in lots of places.


--------------040901050101030304000807
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index da22f90..b7cac8d 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -713,8 +713,11 @@ static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff *skb,
 		return NF_ACCEPT;
 
 	nf_bridge = skb->nf_bridge;
-	if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT))
+	if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT)) {
+		nf_bridge_put(skb->nf_bridge);
+		skb->nf_bridge = NULL;
 		return NF_ACCEPT;
+	}
 
 	/* Bridged, take PF_BRIDGE/FORWARD.
 	 * (see big note in front of br_nf_pre_routing_finish) */

--------------040901050101030304000807--
