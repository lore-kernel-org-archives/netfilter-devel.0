From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: Re: [ULOGD RFC 00/30] [ULOGD RFC] ulogd V2 improvements, round #1
Date: Wed, 30 Jan 2008 21:59:59 +0100
Message-ID: <47A0E54F.2010506@astaro.com>
References: <20080130185847.693274384@kruemel.intranet.astaro.de> <47A0CD7C.2010705@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-21.dex002.intermedia.net ([64.78.21.92]:26023 "EHLO
	dhost002-21.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752224AbYA3VAF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:00:05 -0500
In-Reply-To: <47A0CD7C.2010705@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:

> Thanks for sending these patches Holger, I'll try to review all of them
> tommorrow. Just for my understanding since the ones I already looked at
> look like I could merge them immediately, do you want me to already
> commit them or is this really just meant to gather comments?

Hi Patrick,

most of the code in those patches is quite an improvement, so there is 
IMO not much concern integrating those changes, as they change code 
which was sometimes not even working.  I was more thinking about 
presentation of those patches, which would eventually make it easier for 
others to understand all the motivation behind those changes.

My initial round of patches was more than 60 or so, what you see here is 
just a distillation of all those.  Some of those changes were quite 
small, which maybe let me think that this distillation would be helpfull 
in the end to just reduce the number of patches.

Of course, if you are fine even with the larger patches feel free to 
commit them.  Just remember that most of these patches are strongly 
in-order, you have to commit them in the same order.

Thanks.  /holger



