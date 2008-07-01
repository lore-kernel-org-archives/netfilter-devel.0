From: Patrick McHardy <kaber@trash.net>
Subject: Re: POM Xtables???
Date: Tue, 01 Jul 2008 13:57:40 +0200
Message-ID: <486A1BB4.10905@trash.net>
References: <935fab200806271054oa7c340evbf465b7a9984498b@mail.gmail.com>  <alpine.LNX.1.10.0806272003170.12725@fbirervta.pbzchgretzou.qr>  <4866F152.7030109@riverviewtech.net> <935fab200806300904rc7dc7b2kf58ab7893c3ef20a@mail.gmail.com> <486907EA.60105@trash.net> <alpine.LNX.1.10.0806302218500.30639@fbirervta.pbzchgretzou.qr> <48694787.3080906@trash.net> <Pine.LNX.4.64.0807011135120.30394@blackhole.kfki.hu> <4869FCE7.9000404@trash.net> <alpine.LNX.1.10.0807011326351.12878@fbirervta.pbzchgretzou.qr> <486A1865.40106@trash.net> <alpine.LNX.1.10.0807011346590.12878@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Dave <finalglide@gmail.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34169 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbYGAL5m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:57:42 -0400
In-Reply-To: <alpine.LNX.1.10.0807011346590.12878@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Added netfilter-devel to CC.

Jan Engelhardt wrote:
> On Tuesday 2008-07-01 13:43, Patrick McHardy wrote:
>>> You only added the nfmark, and it is printed unconditionally at that,
>>> the latter of which I do not see as thrilling. Seems like it is time
>>> for a new revision? Also I think the two modules should be unified
>>> first.
>> It doesn't need a new revision, it doesn't affect the userspace
>> API in any way. As for the argument of parsers that might not
>> handle this: any parser needs to expect new things to be added
>> at the end of the line, otherwise its giving us no possibility
>> of ever extending the output, which is not reasonable.
>>
> That is why LOGMARK has been LOGMARK so far, where the (undocumented)
> requirement is that parsers have to split at whitespace and may not
> assume any particular order of fields. This allows to selectively log
> things by means of flags passed in from userspace and thus sparing
> syslog from being spammed with unwanted fields.

Spammed with unwanted fields in a huge exaggeration. And nobody
sane is using LOG for anything but debugging anyway due to the
unreliable nature of the ringbuffer and the huge slowdown this
might cause when using serial console.

> So the only way is to introduce a LOG2 target?

Only way for what? As I stated, you're free to add new fields
at the end.


