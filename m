From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Problems with nf_nat_ftp.ko and nf_conntrack_ftp.ko in  
 2.6.22.6
Date: Mon, 12 Nov 2007 07:00:22 +0100
Message-ID: <4737EBF6.6000506@trash.net>
References: <W352381485970601194435879@nocme1bl6.telenet-ops.be>	 <4731A7A9.1050606@trash.net> <1194478191.2983.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090505030506030600020206"
Cc: "bdschuym@pandora.be" <bdschuym@telenet.be>,
	ron lai <ronlai@cs.stanford.edu>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37044 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbXKLGAt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2007 01:00:49 -0500
In-Reply-To: <1194478191.2983.7.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090505030506030600020206
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Bart De Schuymer wrote:
> Op wo, 07-11-2007 te 12:55 +0100, schreef Patrick McHardy:
>> Could you check the attached patch?
> 
> Looks ok to me.
> 
>>  > Another solution I think is this:
>>> in br_nf_post_routing():
>>> change
>>> if (!nf_bridge)
>>> to
>>> if (!nf_bridge || !(nf_bridge->mask & BRNF_BRIDGED_DNAT))
>> Wouldn't that break the regular case of packets forwarded
>> through a single bridge?
> 
> Hmm, yes, we'd need to or it with BRNF_BRIDGED. I personally prefer
> something like that, leaving the call to nf_bridge_put when the skbuff
> is removed. But it's your call :)


Both are fine with me. Does this patch look correct to you?


--------------090505030506030600020206
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index da22f90..ce68284 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -766,6 +766,9 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 	if (!nf_bridge)
 		return NF_ACCEPT;
 
+	if (!nf_bridge->mask & (BRNF_BRIDGED | BRNF_BRIDGED_DNAT))
+		return NF_ACCEPT;
+
 	if (!realoutdev)
 		return NF_DROP;
 

--------------090505030506030600020206--
