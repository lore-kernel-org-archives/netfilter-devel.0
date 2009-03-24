From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Correct signatur for target
Date: Tue, 24 Mar 2009 14:25:00 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903241424470.27859@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903240606v1efab2eds2a40a1dbe820af00@mail.gmail.com>  <alpine.LSU.2.00.0903241410130.27859@fbirervta.pbzchgretzou.qr> <17e3a8f80903240621ic1a86f0gac018b02cd0fa9da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56836 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbZCXNZC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:25:02 -0400
In-Reply-To: <17e3a8f80903240621ic1a86f0gac018b02cd0fa9da@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-24 14:21, Kristian Evensen wrote:

>> To make Xtables-addons's compat_xtables.ko work with all supported
>> kernel versions, it has to slightly deviate from the latest kernel
>> API and use a double-pointer. So if you write your module with the
>> help of the compat layer, you need to be aware of this minor
>> difference. I think the latest version of the e-book also mentions
>> this.
>
>Thank you very much. When I no longer included "compat_xtables.h" and
>changed the signature, it worked.
>
>When I read the related paragraph (second in section 5.2) in the book
>again now, I see that it is mentioned. However, since I am not so
>familiar with xtables, I did not connect "glue code" with the
>"compat_xtables.h".

I'll try to do some editorial work on the phrasing then ;-)
