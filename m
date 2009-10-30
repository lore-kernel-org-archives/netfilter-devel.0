From: Fred Leeflang <fredl@dutchie.org>
Subject: Re: ulogd extension
Date: Sat, 31 Oct 2009 00:11:05 +0100
Message-ID: <30defc5b0910301611i1cbd6993h2846a5b7167f023b@mail.gmail.com>
References: <30defc5b0910301317u331d641cgec85c6a225bb37ab@mail.gmail.com>
	 <20091030222312.GA11601@piche.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org,
	vuurmuur-devel@lists.sourceforge.net
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f188.google.com ([209.85.222.188]:60641 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070AbZJ3XLB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2009 19:11:01 -0400
Received: by pzk26 with SMTP id 26so2188532pzk.4
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2009 16:11:06 -0700 (PDT)
In-Reply-To: <20091030222312.GA11601@piche.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2009/10/30 Pierre Chifflier <chifflier@inl.fr>:
> On Fri, Oct 30, 2009 at 09:17:26PM +0100, Fred Leeflang wrote:
>> Hi,
>>
>> For vuurmuur I would like to write an ulogd extension that writes out
>> a log somewhat comparable to syslog. Currently vuurmuur parses syslog
>> line generated with the LOG target, we are considering changing this
>> to having ulogd do this for us through the ULOG target and said
>> extension. What's the best way to go about doing this to keep the
>> extension maintainable?
>>
>
> Hi Fred,
>
> Have you looked at the SYSLOG or LOGEMU output plugins ? Writing a
> similar plugin should be fairly easy.
> Writing external plugins is not supported. It's very easy, yet Pablo
> prefers [1] to keep things in mainline when possible, which is of course
> a good thing [2].
>
> Pierre
>
> [1] http://marc.info/?t=123996560400005&r=1&w=2
> [2] external plugins would require us to create, document, and
> maintain a stable API, for ex. Not that it can't be done, but I'm not
> sure it was part of the original plans :)
>



Hi Pierre,

Yes I was looking at those although I looked at the ulogd 1 source and
only very briefly at ulogd 2, looking at those actually gave somebody
else in #vuurmuur the idea to check into this way. It's far easier for
us to make such an extension and require ulogd to run and parse
packets for us than it is to parse a syslog text file. So if I were to
write an extension that would do what we want it to do, could that
extension be part of the builltin extensions of ulogd[1|2] ? I'm more
than happy to hack something together and let the list have a look at
it.

-Fred
