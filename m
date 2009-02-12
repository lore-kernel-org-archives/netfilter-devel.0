From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: pull request
Date: Thu, 12 Feb 2009 07:05:57 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902120700280.32504@fbirervta.pbzchgretzou.qr>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de> <4993B3AC.1060707@trash.net> <alpine.LSU.2.00.0902120632140.32504@fbirervta.pbzchgretzou.qr> <4993B7B4.70901@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40371 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbZBLGF7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 01:05:59 -0500
In-Reply-To: <4993B7B4.70901@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-02-12 06:46, Patrick McHardy wrote:
>>>> 13 files changed, 108 insertions(+), 182 deletions(-)
>>> 11 files changed, 73 insertions(+), 67 deletions(-)
>>>
>>> Any idea whats going on there?
>> I used git diff --stat instead of whatever merge outputs.
>
> That gives the same (different) output for me.

I just found out that `git diff --stat` is not the right thing to use,
at least in its form that I did. With appropraite(?) measures,
I do get the expected:

 11 files changed, 73 insertions(+), 67 deletions(-)

> I'll skip this pull, please send a new request (with or without Jamal's
> patches, as you like) once you figured out where those differences are
> coming from.

Now please :)
