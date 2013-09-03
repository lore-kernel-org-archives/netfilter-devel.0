From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] netfilter: ipset: refactor hash types to use address/cidr arrays.
Date: Tue, 03 Sep 2013 18:24:57 +0200
Message-ID: <1485492.M40ntNg2zf@gentoovm>
References: <1378213974-21425-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: kadlec@blackhole.kfki.hu
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:33749 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab3ICQZt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:25:49 -0400
In-Reply-To: <1378213974-21425-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 03 September 2013 15:12:54 Oliver wrote:
> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> We now use an array in the structs for hash types so that they can be
> arbitrarily expanded to situate as many ip/cidr values as required.
> 
> The primary purpose of this change is in preparation for the
> hash:net,net ipset type, it otherwise carries no change in
> functionality. As an aside, small comparison optimisations could
> additionally be made in the future by making a union from the compared
> types that encompasses them (such as bundling together cidr values).
> 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Trash this, needed to make a few fixes, will resend corrected patch.

Thanks,
Oliver.
