From: Drunkard Zhang <gongfan193@gmail.com>
Subject: Re: ipset v6.24: Comment string is too long!
Date: Sun, 3 Jan 2016 19:13:11 +0800
Message-ID: <CAJiejCTrix5wemwSYftbCDck=PM+rHBroQ+FM2+tF1KFzvwtqg@mail.gmail.com>
References: <CAJiejCQizhn--05MnVzKFLyEFki=K6xzJbL+_b7yVgxYKYmitA@mail.gmail.com>
 <alpine.DEB.2.10.1601012338430.12801@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: maillist-netfilter <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33878 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbcACLNc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jan 2016 06:13:32 -0500
Received: by mail-wm0-f52.google.com with SMTP id u188so118623710wmu.1
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Jan 2016 03:13:32 -0800 (PST)
In-Reply-To: <alpine.DEB.2.10.1601012338430.12801@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-01-02 6:39 GMT+08:00 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>:
> Hi,
>
> On Wed, 30 Dec 2015, Drunkard Zhang wrote:
>
>>     I'm trying ipset, and misleaded by the error message: "ipset
>> v6.24: Comment string is too long!", when doing this:
>>
>> 15:26:34 ~ # ipset create bypass hash:net
>> 15:26:40 ~ # ipset add bypass 42.62.0.0/16 comment "cnc"
>> ipset v6.24: Comment string is too long!
>>
>> it took me some time to identify where the problem is: "comment"
>> extension should be enabled when creating the set.
>>
>> So, WOULD YOU PLEASE replace these words with more accurate sentence?
>> In this situation, say "'comment' extension not enabled", others say
>> "Comment string is too long!".
>>
>> Or, emphasize/highlight "extensions must be enabled before use" in man page.
>
> I'll look into it - I mean both, i.e. better error message and updated
> manpage :-)
>
Thanks, best ;-)
