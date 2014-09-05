From: Thomas De Schampheleire <patrickdepinguin@gmail.com>
Subject: Re: iptables: missing connlabel.conf causes unnecessary error messages
Date: Fri, 5 Sep 2014 12:11:16 +0200
Message-ID: <CAAXf6LWOqA5276mD4v0QLuHp7vBh7tpyZS4y=57iffy8Z4k+uA@mail.gmail.com>
References: <CAAXf6LW4zfxOMeUO4=UPFUX=0VGjLbM_wKhdb3L7DK4SPBmbhg@mail.gmail.com>
 <20140905091305.GB934@breakpoint.cc> <CAAXf6LVWzjt_becB7dwFNtcevGZn-nsGxACtZHqrv+4MUSsSaA@mail.gmail.com>
 <20140905095137.GC934@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:42542 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557AbaIEKLj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:11:39 -0400
Received: by mail-la0-f53.google.com with SMTP id q1so5013024lam.12
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Sep 2014 03:11:36 -0700 (PDT)
In-Reply-To: <20140905095137.GC934@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 5, 2014 at 11:51 AM, Florian Westphal <fw@strlen.de> wrote:
> Thomas De Schampheleire <patrickdepinguin@gmail.com> wrote:
>> On Fri, Sep 5, 2014 at 11:13 AM, Florian Westphal <fw@strlen.de> wrote:
>> > Thomas De Schampheleire <patrickdepinguin@gmail.com> wrote:
>> >> Commit http://git.netfilter.org/iptables/commit/?id=51340f7b6a1103b12d86ef488f7140406d80401e
>> >> removed the default /etc/xtables/connlabel.conf file distributed with netfilter.
>> >>
>> >> From this commit onwards, every call to iptables will show the message:
>> >>     cannot open connlabel.conf, not registering 'connlabel' match: No
>> >> such file or directory
>> >
>> > Right, this happens for static builds.
>>
>> If with 'static' you mean 'statically linked', then this is not correct.
>> My iptables application is dynamically linked:
>
> I meant --enable-static during configure stage.

Ok, I see, this is indeed a flag passed in my configure step.

Thanks,
Thomas
