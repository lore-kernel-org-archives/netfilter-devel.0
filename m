From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnfq: mark functions as extern C
Date: Tue, 24 Jun 2008 18:14:44 +0200
Message-ID: <48611D74.7040809@trash.net>
References: <alpine.LNX.1.10.0806230955540.22994@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57527 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYFXQOs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Jun 2008 12:14:48 -0400
In-Reply-To: <alpine.LNX.1.10.0806230955540.22994@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 7f2678a05bd590f18fa6688785ba11ec6845007b
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Mon Jun 23 09:54:14 2008 +0200
> 
> mark functions as extern C
>     
> This is needed when #included from C++.

Also applied, thanks.
