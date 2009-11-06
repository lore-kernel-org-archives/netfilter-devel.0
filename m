From: Fred Leeflang <fredl@dutchie.org>
Subject: Re: ulogd extension
Date: Fri, 6 Nov 2009 16:36:58 +0100
Message-ID: <30defc5b0911060736g1dae26f7g6148e8eb7e3d76d3@mail.gmail.com>
References: <30defc5b0910301317u331d641cgec85c6a225bb37ab@mail.gmail.com>
	 <20091030222312.GA11601@piche.inl.fr>
	 <30defc5b0910301611i1cbd6993h2846a5b7167f023b@mail.gmail.com>
	 <20091101103612.GB11601@piche.inl.fr>
	 <30defc5b0911010308r6aa0f62cl6f910148932b924e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org,
	vuurmuur-devel@lists.sourceforge.net
To: Pierre Chifflier <pchifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:38092 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZKFPgx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 10:36:53 -0500
Received: by pwj9 with SMTP id 9so692142pwj.21
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2009 07:36:59 -0800 (PST)
In-Reply-To: <30defc5b0911010308r6aa0f62cl6f910148932b924e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pierre,

I've hacked support for creating nflog targets into vuurmuur. When experimenting
with this I've found that it was real easy to have ulogd2's syslogemu
output module write a syslog file that vuurmuur could use to do our
syslog parsing. This may be
more useful even than writing our own extension for ulogd2 as our project leader
decided not to want to obsolete the log parsing daemon.

So, we could simply add a requirement to vuurmuur (or at least a recommended)
of ulogd. Does ulogd1 also support nflog tgts? If not, when's ulogd2
scheduled to be
released? Are any distro packagers working on it already?

Thanks,
Fred


2009/11/1 Fred Leeflang <fredl@dutchie.org>:
> 2009/11/1 Pierre Chifflier <pchifflier@edenwall.com>:
>> On Sat, Oct 31, 2009 at 12:11:05AM +0100, Fred Leeflang wrote:
>>> Yes I was looking at those although I looked at the ulogd 1 source and
>>> only very briefly at ulogd 2, looking at those actually gave somebody
>>> else in #vuurmuur the idea to check into this way. It's far easier for
>>
>> Hi Fred,
>>
>> I'd suggest to look only for ulogd2 if possible. The architecture is
>> very different, and I think adding a plugin will be far easier.
>>
>
> I had already decided to do so and checked out
> git://git.netfilter.org/ulogd2.git (couldn't get to your personal git
> repo at the time) so I have a pretty decent idea what I'm looking at
> already.
>
>>> us to make such an extension and require ulogd to run and parse
>>> packets for us than it is to parse a syslog text file. So if I were to
>>> write an extension that would do what we want it to do, could that
>>> extension be part of the builltin extensions of ulogd[1|2] ? I'm more
>>> than happy to hack something together and let the list have a look at
>>> it.
>>
>> If the plugin is generic, it should not be a problem. Ulogd2 has 3 types
>> of plugins: input, filter, and output. So, from what you are telling,
>> I suppose it would be an input plugin ?
>>
>
> I suppose it would be an output plugin :) It should essentially do
> similar stuff from what I could see, kinda like the
> ulogd_output_SYSLOG.c. It would not do syslogging however but instead
> write out a logfile for vuurmuur UI displaying.
>
> I just discussed that this morning with the other developers and the
> project leader feels that we might be better off using
> libnetfilter_log directly from libvuurmuur as there's apparently a
> bigger chunk of library code in libvuurmuur that would have to be
> either ported to the plugin or we'd create a dependency on libvuurmuur
> in ulogd2, which he was pretty sure you wouldn't like :)
>
> So for now we'll stick to the approach of using libnetfilter_log from
> within our own library.
>
> Thanks,
> -Fred Leeflang
>
