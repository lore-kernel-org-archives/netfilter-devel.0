From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] iptables-save: add --chain argument, limits output to
 a chain
Date: Tue, 26 Feb 2013 23:18:33 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1302262317240.13412@nerf07.vanv.qr>
References: <1361878382-11959-1-git-send-email-jonh.wendell@gmail.com> <alpine.LNX.2.01.1302261547450.7232@nerf07.vanv.qr> <CABXqP=jq3rEE6b1xpgA0QtuwAQ04U5b3voMdTsuGmLB-qrsDxg@mail.gmail.com> <alpine.LNX.2.01.1302261639580.7776@nerf07.vanv.qr>
 <CABXqP=idCE0Rj8uC11VeGCpf7Cfb46A1OuD0SXAbjxpXXaxr-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jonh Wendell <jonh.wendell@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:41840 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab3BZWSe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:18:34 -0500
In-Reply-To: <CABXqP=idCE0Rj8uC11VeGCpf7Cfb46A1OuD0SXAbjxpXXaxr-Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2013-02-26 17:18, Jonh Wendell wrote:
>
>My particular use case is: I want to flush all iptables rules except
>those ones from a specific chain.
>So, I save them with iptables-save -C <chain-name>, flush, and then
>run iptables-restore on them.

But if chain-name is not a base chain, then you wipe out the
main rules for all practical purposes.
