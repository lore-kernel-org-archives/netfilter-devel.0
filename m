From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: skb_* function to get pointer to udp payload
Date: Wed, 8 Aug 2012 20:03:43 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208082003270.4912@frira.zrqbmnf.qr>
References: <1344346961.4763.12.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Arif Hossain <etothepowerpi@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:52890 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932Ab2HHSDo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Aug 2012 14:03:44 -0400
In-Reply-To: <1344346961.4763.12.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-08-07 15:42, Arif Hossain wrote:

>Hi,
>
>I need to get a pointer to udp payload in my xtables module in following
>scenario:
>
>1. From NF_INET_LOCAL_PREROUTING hook. As Transport headers are not yet
>initialized, may be i need to play with offsets like
>skb_header_pointer(skb, par->thoff,....). Not sure if its correct to use
>skb_header_pointer this way though.

It is correct to use skb_h_p in either chain.
