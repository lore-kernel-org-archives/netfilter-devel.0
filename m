From: Patrick McHardy <kaber@trash.net>
Subject: Re: Some iptables-1.4.3 issues
Date: Tue, 24 Mar 2009 13:47:21 +0100
Message-ID: <49C8D659.5020705@trash.net>
References: <49C79C90.80804@trash.net> <1237882157.9988.2533.camel@localhost> <alpine.LSU.2.00.0903240951060.25646@fbirervta.pbzchgretzou.qr> <49C8C146.3040507@netfilter.org> <alpine.LSU.2.00.0903241219200.15443@fbirervta.pbzchgretzou.qr> <49C8C622.3060805@netfilter.org> <alpine.LSU.2.00.0903241248500.15443@fbirervta.pbzchgretzou.qr> <49C8CA58.9020003@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, Peter Volkov <pva@gentoo.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32955 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbZCXMr1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 08:47:27 -0400
In-Reply-To: <49C8CA58.9020003@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Jan Engelhardt wrote:
>> On Tuesday 2009-03-24 12:38, Pablo Neira Ayuso wrote:
>>>> Nope, it is complete as far as posted. But no patches were supplied
>>>> for issue (1) and (3)  :-)
>>>>
>>>> Please pull from  git://dev.medozas.de/iptables master
>>> Pulled and pushed. Thanks. If there's no more complains, we can release
>>> the 1.4.3.1.
>> Right now there are no complaints, as most next-level developers
>> will most likely only update within the next week.
> 
> Oh, still one minor nitpick. Patrick forgot to bump the version in
> configure.ac :)
> 
> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commitdiff;h=ca6ccdb172b1846152dea421c215122759b84d29;hp=1288bf7e5c39af3ca690a12f419dde507c5a556d

D'oh. I did this two or three times since other things went wrong,
I must have forgotten the last time.

Are you releasing a .1 version?
