From: "Harout Hedeshian" <harouth@codeaurora.org>
Subject: RE: [PATCH nf-next] netfilter: xt_socket: add XT_SOCKET_RESTORESKMARK flag
Date: Tue, 16 Jun 2015 07:38:44 -0600
Message-ID: <008a01d0a839$c4bb0ee0$4e312ca0$@codeaurora.org>
References: <1434415243-15474-1-git-send-email-harouth@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "'Lorenzo Colitti'" <lorenzo@google.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46245 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbbFPNir (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 09:38:47 -0400
In-Reply-To: <1434415243-15474-1-git-send-email-harouth@codeaurora.org>
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-
> owner@vger.kernel.org] On Behalf Of Harout Hedeshian
> Sent: Monday, June 15, 2015 6:41 PM
> To: netfilter-devel@vger.kernel.org
> Cc: Lorenzo Colitti; Harout Hedeshian
> Subject: [PATCH nf-next] netfilter: xt_socket: add
> XT_SOCKET_RESTORESKMARK flag
> 
> xt_socket is useful for matching sockets with IP_TRANSPARENT and
> taking some action on the matching packets. However, it lacks the
> ability to match only a small subset of transparent sockets.
> 
> Suppose there are 2 applications, each with its own set of transparent
> sockets. The first application wants all matching packets dropped,
> while the second application wants them forwarded somewhere else.
> 
> Add the ability to retore the skb->mark from the sk_mark. The mark
> is only restored if a matching socket is found and the transparent /
> nowildcard conditions are satisfied.
> 
> Now the 2 hypothetical applications can differentiate their sockets
> based on a mark value set with SO_MARK.
> 
> iptables -t mangle -I PREROUTING -m socket --transparent \
>                                            --restore-skmark -j action
> iptables -t mangle -I PREROUTING -m socket --transparent \
>                                            --restore-skmark -j action

Oops, redundant command in the commit message. I'll submit a v2 if we are
happy with the rest of the patch.

> iptables -t mangle -A action -m mark --mark 10 -j action2
> iptables -t mangle -A action -m mark --mark 11 -j action3
> 

