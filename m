From: Ed W <lists@wildgooses.com>
Subject: Re: How to access conntrack connection expiration in a netfilter
 module?
Date: Tue, 02 Oct 2012 18:02:37 +0100
Message-ID: <506B1E2D.3090501@wildgooses.com>
References: <506A084E.5060505@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.nippynetworks.com ([91.220.24.129]:47028 "EHLO
	mail1.nippynetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2JBRCi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:02:38 -0400
Received: from localhost (mail1.nippynetworks.com [127.0.0.1])
	by mail1.nippynetworks.com (Postfix) with ESMTP id 2D7C73404C7
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Oct 2012 18:02:37 +0100 (BST)
Received: from mail1.nippynetworks.com ([127.0.0.1])
	by localhost (mail1.nippynetworks.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id zZLccL7zViCT for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Oct 2012 18:02:37 +0100 (BST)
Received: from eds-macbook-pro.nippynetworks.local (unknown [212.69.38.73])
	(Authenticated sender: edward@wildgooses.com)
	by mail1.nippynetworks.com (Postfix) with ESMTPSA id E81A33404C6
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Oct 2012 18:02:36 +0100 (BST)
In-Reply-To: <506A084E.5060505@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Go on... I'm sure someone wants to have a stab at educating this twit on 
ways a netfilter module could do housekeeping and cleanup it's internal 
state when conntrack connections are destroyed (emphasis being on how to 
discover they have been destroyed in some timely manner?)

Thanks

Ed W

On 01/10/2012 22:17, Ed W wrote:
> Hi, I'm trying to update the opendpi-netfilter module to work with 
> more recent kernels and the ntop ndpi fork of the code (now that 
> opendpi seems to have gone away)
>
> The netfilter module registers a conntrack notifier in order to 
> release resources once a conntrack is destroyed
> https://github.com/ewildgoose/ndpi-netfilter/blob/master/src/main.c
> This is not possible though, if you also want to have conntrack events 
> through netlink... ( NF_CT_NETLINK grabs the conntrack notifier first)
>
> Now I have read the history on why this is the case, but what are the 
> obvious workarounds to this situation?  Can we extend the conntrack 
> connection with custom properties? Anything better than simply 
> scanning my flows occasionally and comparing with the conntrack list 
> to see if they have gone away?
>
> Thanks for any thoughts
>
> Ed W
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

