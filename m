From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipq_compat not work ?
Date: Thu, 17 Sep 2009 13:47:51 +0200
Message-ID: <4AB221E7.1040109@trash.net>
References: <4AAE532C.1010100@nitrosecurity.com> <2af341ab0909140734g4ac9a696o4fb54a1827edd02c@mail.gmail.com> <09853F7CBDC04312ABC7E869B2E967F3@kerio.local> <4AAE7836.3020406@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Ondrej Slanina <oslanina@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59221 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913AbZIQLru (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:47:50 -0400
In-Reply-To: <4AAE7836.3020406@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Ondrej Slanina wrote:
>> Hi,
>> thanks for response. In my code I can use it, but as I said, I tried to
>> compile Snort inline which is third - party software and which is still
>> depended on libipq. And I think that we can find more old software which
>> depends on libipq. I only want to know, if I just missed something or if
>> I'am doing something wrong or if it's not implemented yet.
> 
> It has never been finished and does not work. snort inline supports
> nfnetlink_queue nowadays however.

I've removed it from the git tree to avoid confusion in the future.
