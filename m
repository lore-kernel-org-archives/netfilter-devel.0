From: Patrick McHardy <kaber@trash.net>
Subject: Re: can we use nfq_set_verdict to accept packets more than once with
 one packet_id?
Date: Tue, 30 Aug 2011 14:48:36 +0200
Message-ID: <4E5CDC24.6050000@trash.net>
References: <D39C71B66797974C8687C6F5AC74A781069358FF@CNSHGSMBS01.ad4.ad.alcatel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: ZOU YOUTAO <Youtao.Zou@alcatel-sbell.com.cn>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54710 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab1H3Msh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Aug 2011 08:48:37 -0400
In-Reply-To: <D39C71B66797974C8687C6F5AC74A781069358FF@CNSHGSMBS01.ad4.ad.alcatel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29.08.2011 16:03, ZOU YOUTAO wrote:
> 
> I need to develop an user space routing applcation.
> 
> My question is that I need to split an incoming udp packet to several
> small ones and forward them to different servers.
> Can I implement the requirement by  using libnetfilter_queue?

Not directly, each packet needs exactly one verdict and you can only
modify the contents once. You could split the packet, transmit all
but one using raw or packet sockets and issue a verdict for the
remaining one.

> another requirement is that the incoming packet is not forwarded
> immediately. A timer is set instead. The packet forwarding is performed
> in the timeout handler. So we cannot invoke nfq_set_verdict in the end
> of libnetfilter_queue callback function. We have to hold the packet_id
> for the timeout handler for forwarding.
> Does this introduce performance issue?

You just have to make sure your queue is sized approriately.
