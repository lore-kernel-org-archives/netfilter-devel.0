From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: REOUTE target extenstion
Date: Wed, 27 May 2015 13:37:37 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1505271337190.1023@nerf40.vanv.qr>
References: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Eddi Linder <eddi@guardicore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:40241 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbbE0Lhi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 07:37:38 -0400
In-Reply-To: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2015-05-27 12:11, Eddi Linder wrote:

>Hey,
>
>I am planning to write a "redirection" extension that based on a match
>will copy the matched packet to other interfaces.
>Any suggestions or comments will be appreciated.

We already have the TEE target that does exactly that.
