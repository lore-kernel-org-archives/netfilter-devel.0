From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 snapshot 20090804
Date: Tue, 4 Aug 2009 15:26:45 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908041518580.15352@fbirervta.pbzchgretzou.qr>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de> <4A782DE8.90300@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44238 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbZHDN0p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 09:26:45 -0400
In-Reply-To: <4A782DE8.90300@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Tuesday 2009-08-04 14:47, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> 
>> It can be retrieved from
>> 
>> 	git://dev.medozas.de/linux  xt2-20090804
>> 
>>  181 files changed, 4060 insertions(+), 8823 deletions(-)
>
>I suggest you begin by submitting the removal patches of old
>revisions in a first series, then we can continue on with
>cleanups and finally discuss your proposed functional changes.
>But this is just too big to reasonably review in one go.

Well, true. I did not expect you to look at it all at once. But that
should not stop you from being able to piece-wise reply to the first,
say, 20-or-so patches.

The cleanups obviously come first because I assumed they are relatively 
easy to gulp.

  01-16  cleanups
     \__ 01-10  removals
     \__ 11-16  cosmetics

If there is overly large discussion potential in a patch (and there
probably is), just stop at the one, and we'll take it from there, ok?
I do not think resending the first group (01-16) makes much sense
given there is no discussion preceding it as there would be for
patches 20+.



thank you very much,
Jan
