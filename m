From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: can expectations be marked persistent, so they can match
 repeatedly until they timeout?
Date: Tue, 29 Mar 2011 11:54:15 -0700
Message-ID: <AANLkTinP8AMGwmyX7WxCrXTLNZcc_4ofAO7_D+ASkvu_@mail.gmail.com>
References: <AANLkTi=dEfb8f1moPE5Mp2yS5DqiB=abuJcFP99opXy9@mail.gmail.com>
	<4D9070AA.60100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41700 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1C2SyQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2011 14:54:16 -0400
Received: by vws1 with SMTP id 1so418289vws.19
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2011 11:54:15 -0700 (PDT)
In-Reply-To: <4D9070AA.60100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 28, 2011 at 4:27 AM, Patrick McHardy <kaber@trash.net> wrote:
> On 24.03.2011 18:43, Sam Roberts wrote:
>> I'm writing a userspace conntrack, using nfqueue and conntrack.

>> However, unlike ftp, the negotiated ephemeral port is used by multiple
>> simultaneous tcp connections for some period. I'd like the expectation
>> to be kept in place until it times out, even when its matched.

> You should be able to use NF_CT_EXPECT_PERMANENT.

Yes, that works perfectly. Thank you.

Sam
