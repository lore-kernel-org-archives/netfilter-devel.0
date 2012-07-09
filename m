From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH v2 5/6] netfilter: tarpit: Add IPv6 support
Date: Mon, 09 Jul 2012 14:05:01 -0500
Message-ID: <4FFB2B5D.5050100@akamai.com>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com> <1341771085-5771-6-git-send-email-johunt@akamai.com> <alpine.LNX.2.01.1207082125590.11837@frira.zrqbmnf.qr> <4FFAE45D.6070603@akamai.com> <alpine.LNX.2.01.1207091855540.1876@frira.zrqbmnf.qr> <4FFB14B4.6040801@akamai.com> <alpine.LNX.2.01.1207092016370.5417@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:34486 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242Ab2GITFF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:05:05 -0400
In-Reply-To: <alpine.LNX.2.01.1207092016370.5417@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/09/2012 01:46 PM, Jan Engelhardt wrote:

> You send the files that are in xtables-addons to whoever is taking care
> of the Linux kernel business (currently that seems to be Pablo), of course
> in a form that is acceptable for the Linux kernel (i.e. minus xtables-addons
> lines).

Thanks yeah I wasn't sure if there was a natural progression from addons 
to mainline. Figured I'd ask.

>
> It certainly seems well-desired by $users. And normally, inclusion
> is to follow demand (that's how squashfs got in, IIRC). Expect
> to defend your case when making it upstream. Solicit more "we want
> this opinions" :)
>

Sounds good. Thanks for all your help Jan.

Josh

