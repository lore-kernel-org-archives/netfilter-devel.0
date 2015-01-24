From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH iptables] iptables: use flock() instead of abstract unix
 sockets
Date: Sat, 24 Jan 2015 14:35:04 -0800
Message-ID: <20150124223503.GA22316@home>
References: <1421690957-11279-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, lennart@poettering.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:47564 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbbAXWfG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jan 2015 17:35:06 -0500
Received: by mail-pa0-f53.google.com with SMTP id kx10so4234877pab.12
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Jan 2015 14:35:04 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1421690957-11279-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 19, 2015 at 07:09:17PM +0100, Pablo Neira Ayuso wrote:
> Abstract unix sockets cannot be used to synchronize several concurrent
> instances of iptables since an unpriviledged process can create them and
> prevent the legitimate iptables instance from running.
> 
> Use flock() and /run instead as suggested by Lennart Poettering.
> 
> Fixes: 93587a0 ("ip[6]tables: Add locking to prevent concurrent instances")
> Reported-by: Lennart Poettering <lennart@poettering.net>

Looks good Pablo.  Thanks for finding this Lennart.  

Phil
