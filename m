From: Valentina Giusti <valentina.giusti@oss.bmw-carit.de>
Subject: Re: [PATCH] xt_owner: enable xt_owner on INPUT chain
Date: Wed, 04 Sep 2013 14:58:13 +0200
Message-ID: <52272E65.5070208@oss.bmw-carit.de>
References: <1377866623-25948-1-git-send-email-valentina.giusti@bmw-carit.de> <1377866623-25948-2-git-send-email-valentina.giusti@bmw-carit.de> <20130904123459.GA4900@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: valentina.giusti@bmw-carit.de, netfilter-devel@vger.kernel.org,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:49620 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756285Ab3IDNHx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:07:53 -0400
In-Reply-To: <20130904123459.GA4900@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

thanks for having a look at this patch.

On 09/04/2013 02:34 PM, Pablo Neira Ayuso wrote:
> On Fri, Aug 30, 2013 at 02:43:43PM +0200, valentina.giusti@bmw-carit.de wrote:
>> From: Valentina Giusti <valentina.giusti@bmw-carit.de>
>>
>> Since (41063e9 ipv4: Early TCP socket demux), we can apply the owner
>> extension on the INPUT chain and match established TCP sockets.
>> However, because of the same commit, we can have skb->sk pointing to a
>> timewait socket, in which case accessing skb->sk->sk_socket is invalid.
> This only works for established TCP sockets. Thus, this rule:
>
> -A INPUT -m owner --socket-exists -j ACCEPT
> -A OUTPUT -m owner --socket-exists -j ACCEPT
>
> are semantically different depending on the path.

True, in fact my idea is to enable early demultiplexing also for other 
kinds of sockets - as mentioned in the cover letter to this patch: 
http://marc.info/?l=netfilter-devel&m=137786715327396&w=2.

Sorry, I should probably have made it clear that also this patch was 
part of the [RFC], since of course I didn't mean to have it applied now.

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

