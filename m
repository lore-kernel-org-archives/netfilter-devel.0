From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC PATCH nft] src: add support for interface wildcard name
Date: Sun, 20 Oct 2013 13:49:33 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1310201346510.13725@nerf07.vanv.qr>
References: <1381846993-30093-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:37730 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3JTLte (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Oct 2013 07:49:34 -0400
In-Reply-To: <1381846993-30093-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2013-10-15 16:23, Florian Westphal wrote:

> Caveats:
>  - I am not convinced '+' is a good idea -- it is ambiguous since
>  'foo+' is a legal interface name.
>  Maybe we should use 'foo/' (Linux forbids / in interface names) instead?

While there are almost no limitations on the interface name, there
is a limit to what characters are _useful_ to have in an interface
name. Picking foo+ was a sensible decision back then, and continues
to be, unless you want to go for the optically different 'foo*'.
