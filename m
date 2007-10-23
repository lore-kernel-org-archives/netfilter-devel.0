From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] let DO_MULTI=1 work for ip6tables* binaries
Date: Tue, 23 Oct 2007 16:17:22 +0200
Message-ID: <471E0272.8040704@trash.net>
References: <200710220740.l9M7ecqU063002@mail.ascenvision.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel list <netfilter-devel@vger.kernel.org>
To: Hann-huei Chiou <koala@ascenvision.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46915 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbXJWOST (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:18:19 -0400
In-Reply-To: <200710220740.l9M7ecqU063002@mail.ascenvision.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hann-huei Chiou wrote:
> Hi,
> 
> When defining DO_MULTI=1 in Makefile, only iptables is built as
> a single multipurpose binary. This patch makes ip6tables also be
> built in the same manner.


Applied, thanks Hann-huei.
