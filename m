From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Suggestion: "--match recent --set --life-span <secs>"  to prevent
 table filling up
Date: Tue, 10 Mar 2009 21:43:43 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903102142300.23653@fbirervta.pbzchgretzou.qr>
References: <49B59CC7.7080002@bluebottle.com> <alpine.LSU.2.00.0903101712400.19523@fbirervta.pbzchgretzou.qr> <49B6BD2E.7010908@bluebottle.com> <alpine.LSU.2.00.0903102026470.23653@fbirervta.pbzchgretzou.qr> <200903102010.n2AKAf9t003525@mi0.bluebottle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Chris Hanson <chanson@bluebottle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54547 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbZCJUnr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2009 16:43:47 -0400
In-Reply-To: <200903102010.n2AKAf9t003525@mi0.bluebottle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-10 21:10, Chris Hanson wrote:
>>> I also believe that the "--rcheck ! --seconds x" check didn't work.
>>>
>>> I will investigate and report back.
>>>    
> I made a mistake in the syntax. It should be "! --rcheck --seconds x".
>
> So, in the end, all I have to complain about is that "--rcheck ! --seconds x"
> doesn't throw an error. It is accepted as if there was no "!".
>
That might be. Some modules have missing "! not allowed here" checks
and just ignore it without warning about it, but Patrick has put me
on hold (it seems like an infinity) with regard to new patches :-/ :-p


