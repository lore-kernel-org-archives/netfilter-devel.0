From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Increasing XT_EXTENSION_MAXNAMELEN to 32
Date: Sat, 29 Sep 2012 18:46:22 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209291844490.19330@nerf07.vanv.qr>
References: <1348934029.10238.15.camel@cr0>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Cong Wang <amwang@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:36774 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab2I2QqY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Sep 2012 12:46:24 -0400
In-Reply-To: <1348934029.10238.15.camel@cr0>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2012-09-29 17:53, Cong Wang wrote:

>Hi, netfilter experts,
>
>A customer wants to increase XT_EXTENSION_MAXNAMELEN to at least 31 (1
>for '\0'), so I just increase it to 32. Do you have any comments or
>objections for the following patch?

This is a no-no. You are breaking the ABI.
