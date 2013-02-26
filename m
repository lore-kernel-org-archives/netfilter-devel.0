From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] iptables-save: add --chain argument, limits output to
 a chain
Date: Tue, 26 Feb 2013 15:48:18 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1302261547450.7232@nerf07.vanv.qr>
References: <1361878382-11959-1-git-send-email-jonh.wendell@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Jonh Wendell <jonh.wendell@oiwifi.com.br>
To: jonh.wendell@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40427 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759386Ab3BZOsT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 09:48:19 -0500
In-Reply-To: <1361878382-11959-1-git-send-email-jonh.wendell@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2013-02-26 12:33, jonh.wendell@gmail.com wrote:

>From: Jonh Wendell <jonh.wendell@oiwifi.com.br>
>
>Similar to the --table argument, if a --chain (or -C) argument
>is passed, we limit the output to rules of that chain.

But we have `iptables -S chain` for that, don't we.
