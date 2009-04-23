From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack_proto_udplite
Date: Thu, 23 Apr 2009 12:30:12 +0200
Message-ID: <49F04334.9000905@trash.net>
References: <200904222106.29497.steven@springl.ukfsn.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080104040403060603030806"
Cc: netfilter-devel@vger.kernel.org
To: Steven Jan Springl <steven@springl.ukfsn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46456 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbZDWKaS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:30:18 -0400
In-Reply-To: <200904222106.29497.steven@springl.ukfsn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080104040403060603030806
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Steven Jan Springl wrote:
> Hello
> 
> Whilst testing kernel 2.6.30-rc3 I have noticed that when I issue command: 
> 
> modprobe nf_conntrack_proto_udplite
> 
> the following message is produced:
> 
> FATAL: Error inserting nf_conntrack_proto_udplite 
> (/lib/modules/2.6.30-rc3/kernel/net/netfilter/nf_conntrack_proto_udplite.ko): 
> Invalid argument
> 
> Is this a kernel bug or have I done something wrong?

Thanks for the report, it seems the IPv6 udplite protocol was
forgotten during a recent API change.

Does this patch help?


--------------080104040403060603030806
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 4614696..0badedc 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -204,6 +204,7 @@ static struct nf_conntrack_l4proto nf_conntrack_l4proto_udplite6 __read_mostly =
 	.error			= udplite_error,
 #if defined(CONFIG_NF_CT_NETLINK) || defined(CONFIG_NF_CT_NETLINK_MODULE)
 	.tuple_to_nlattr	= nf_ct_port_tuple_to_nlattr,
+	.nlattr_tuple_size	= nf_ct_port_nlattr_tuple_size,
 	.nlattr_to_tuple	= nf_ct_port_nlattr_to_tuple,
 	.nla_policy		= nf_ct_port_nla_policy,
 #endif

--------------080104040403060603030806--
