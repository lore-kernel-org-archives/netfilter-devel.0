From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: libxt_string: fix undefined behavior/incorrect patlen
 calculation
Date: Mon, 2 Mar 2009 03:25:09 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903020324590.10419@fbirervta.pbzchgretzou.qr>
References: <20090301223735.GA25389@safeTpin.homeunix.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: pud <pud@subnet666.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52102 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299AbZCBCZM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:25:12 -0500
In-Reply-To: <20090301223735.GA25389@safeTpin.homeunix.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-03-01 23:37, pud wrote:
>(sorry, msg-id lost)
>
>> commit 19b0cd770d1e042c85bf0b278261a61d4cea8193
>> Author: Jan Engelhardt <jeng...@medozas.de>
>> Date: Thu Feb 12 01:18:35 2009 +0100
>...
>> - stringinfo->patlen=strlen((char *)&stringinfo->pattern);
>> + stringinfo->patlen = strnlen((char *)&stringinfo->pattern,
>> +                           sizeof(stringinfo->patlen));
>
>sorry, this doesn't work here, did you mean
>sizeof(stringinfo->pattern)?

What do you mean "doesnot work"?
