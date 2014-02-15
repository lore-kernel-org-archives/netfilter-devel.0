From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: Re: [RFC PATCH] netfilter: nf_tables: add new write expression
Date: Sat, 15 Feb 2014 14:19:09 +0100
Message-ID: <52FF694D.1070700@redhat.com>
References: <1392470242-4515-1-git-send-email-nikolay@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4776 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753050AbaBONTp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Feb 2014 08:19:45 -0500
In-Reply-To: <1392470242-4515-1-git-send-email-nikolay@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/15/2014 02:17 PM, Nikolay Aleksandrov wrote:
> The new "write" expression can be used to manipulate packet data.
> The parameters that it has are source register (source for the bytes
> which are to be written), offset in the packet and length to write.
> It uses a select_ops method to choose between fast ops in the cases
> length is 1,2 or 4 bytes and slow ops (i.e. using memcpy) in other
> cases.
> 
> Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
> ---
> I needed a way (other than passing the packets to user-space) to alter
> the ToS field via nftables, so I decided to make it a bit more general. I
> use it with the immediate expression to load the new ToS and then write it.
> If you find this useful I can post the libnftnl patch as well.
> Right now as you can see it continues even if the "write" wasn't successful
> which should be probably changed to NFT_BREAK for that case.
> This patch applies to Dave's net-next tree.
> 
And I'll fix the direct skb->data references and some other small issues,
thus the RFC :-)

