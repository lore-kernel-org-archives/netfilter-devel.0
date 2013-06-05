From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Locally transmitted Multicast packets are being looped back,
 even if IP_MULTICAST_LOOP option is set to zero
Date: Wed, 05 Jun 2013 06:46:43 -0700
Message-ID: <1370440003.24311.249.camel@edumazet-glaptop>
References: <51AF172C.9090803@india.tejasnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Vijay Tandeker <vijayt@india.tejasnetworks.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40811 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab3FENqq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:46:46 -0400
In-Reply-To: <51AF172C.9090803@india.tejasnetworks.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2013-06-05 at 16:17 +0530, Vijay Tandeker wrote:

> My questions:-
>   - Is this done intentionally ?
>   - If No, please suggest the solution to restore skb->sk pointer.
>   - If Yes, please suggest the solution to restore skb->sk pointer.
> 
> Kindly let me know in case if the problem is not clear or you need any 
> more data.
> 

Have you tried 

int one = 1;
setsockopt(fd, SOL_IP, IP_NODEFRAG, &one, sizeof(one));


