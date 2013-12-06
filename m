From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 3/3] build: use automake and pkgconfig
Date: Fri, 6 Dec 2013 18:47:12 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1312061844040.10270@nerf07.vanv.qr>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de> <1382280491-9921-4-git-send-email-jengelh@inai.de> <20131119202815.GC4929@localhost> <alpine.LSU.2.11.1311201008300.24243@nerf07.vanv.qr> <20131120140605.GB7599@localhost>
 <alpine.LSU.2.11.1311201510170.17186@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:35727 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab3LFRrO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:47:14 -0500
In-Reply-To: <alpine.LSU.2.11.1311201510170.17186@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2013-11-20 15:14, Jan Engelhardt wrote:
>>
>>If you convince me in that it is way too complex to make it, then
>>I'll consider this move to automake.
>
> 16 files changed, 87 insertions(+), 482 deletions(-)

Is this ever going to be merged or not? Shelving 400 lines should speak 
for the simplicity of this proposal.
