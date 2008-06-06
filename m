From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Git author cleanup?
Date: Fri, 6 Jun 2008 12:43:05 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806061241580.11044@fbirervta.pbzchgretzou.qr>
References: <1212738005.27106.31.camel@localhost.localdomain> <484911ED.5010005@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jdb@comx.dk, Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59760 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbYFFKnI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:43:08 -0400
In-Reply-To: <484911ED.5010005@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-06-06 12:31, Patrick McHardy wrote:
> Jesper Dangaard Brouer wrote:
>> Hi Patrick and Jan
>> 
>> You did come author cleanup during the SVN -> GIT conversion.  But you
>> only did it for the "iptables" git repository.  
>> The reason I like correct author information is due to "ohloh.net".  As
>> we give credit to the right people and our project looks more mature, we
>> get the ohloh statement "Very large, active development team".
>> 
>>  http://www.ohloh.net/projects/iptables
>> 
>> If you cleanup the other repositories, then I'll create the seperate
>> projects on ohloh.net. 
>
>
> Rewriting the history requires people to reclone/rebase.
> If someone sends me a script for this I'll do it, but
> only if it soon so we don't cause to much disturbance.
>

You already have the scripts! :-)
Just run "do_rewrite" (not do_rewrite2) from the tarball I posted within
the specific (checkouted) repository.
If there are any X.509 names left, you may need to adjust
the translation in do_rewrite/envfilter.
