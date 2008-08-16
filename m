From: "Changli Gao" <xiaosuo@gmail.com>
Subject: Re: [IPTABLES] the same options for different kinds of matches don't work
Date: Sun, 17 Aug 2008 07:44:08 +0800
Message-ID: <412e6f7f0808161644m33be9b90p2d21872766578d34@mail.gmail.com>
References: <412e6f7f0808150951u2f2d58afn8340c64fed9de2a2@mail.gmail.com>
	 <Pine.LNX.4.64.0808152127180.20054@blackhole.kfki.hu>
	 <412e6f7f0808151705j58845461y952805d122bcf2a7@mail.gmail.com>
	 <Pine.LNX.4.64.0808161902320.20936@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:13972 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYHPXoL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 19:44:11 -0400
Received: by ti-out-0910.google.com with SMTP id b6so623459tic.23
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Aug 2008 16:44:08 -0700 (PDT)
In-Reply-To: <Pine.LNX.4.64.0808161902320.20936@blackhole.kfki.hu>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 17, 2008 at 1:12 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> On Sat, 16 Aug 2008, Changli Gao wrote:
>
>> On Sat, Aug 16, 2008 at 3:31 AM, Jozsef Kadlecsik
>> > With your patch applied we'd loose supporting multiple matches of the same
>> > type.
>> >
>>
>> No we don't loose that function. Look at this example:
>
> Yes, you are right: it seems it was too late yesterday for mental
> patching, compiling and testing ;-).
>
> Still, with your patch we'd break backward compatibility by making
> mandatory for match options to strictly follow '-m matchname'.
>
Yea, but the question is is there anyone know and relay this feature?
And is using this feature is encouraged?

BTW: how about this idea to avoid calling the function parse for the
options not for it:

--- iptables-1.3.8/iptables.c   2007-04-30 07:03:30.000000000 +0800
+++ iptables-1.3.8.new2/iptables.c      2008-08-16 19:44:11.000000000 +0800
@@ -2322,6 +2322,10 @@
                                for (matchp = matches; matchp; matchp
= matchp->next) {
                                        if (matchp->completed)
                                                continue;
+                                       if (c < matchp->match->option_offset ||
+                                           c >= matchp->match->option_offset +
+                                                OPTION_OFFSET)
+                                               continue;
                                        if (matchp->match->parse(c -
matchp->match->option_offset,
                                                     argv, invert,
                                                     &matchp->match->mflags,

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
