From: "Tobias Koeck" <tobias.koeck@gmail.com>
Subject: Re: concurrency problems in a netfilter target extension?
Date: Thu, 31 Jul 2008 17:21:36 +0000
Message-ID: <379e30200807311021q349e121m665fe8a11b764db3@mail.gmail.com>
References: <4891C96A.20004@googlemail.com>
	 <alpine.LNX.1.10.0807311039180.6855@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:25511 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbYGaRVi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:21:38 -0400
Received: by fg-out-1718.google.com with SMTP id 19so323843fgg.17
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2008 10:21:37 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0807311039180.6855@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've read that. But does it solve the problem in a target extension
module? Will the modules only be cloned so that you have different
data structures? Or is only one instance in the memory and if one
processor changes something every other threads will use the changed
values?

On Thu, Jul 31, 2008 at 2:39 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
>
> On Thursday 2008-07-31 10:17, Tobias Koeck wrote:
>
>> I=B4m writing on a netfilter target extension.
>>
>> Are there some possible concurrency problems (means is it possible t=
hat my
>> target extension modules is loaded several times or could it be used=
 with
>> several cpu cores simultaniously)?
>
> Yes, see "Writing your own Netfilter modules" at
> http://jengelh.medozas.de/ , chapter "tricks and traps"
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
