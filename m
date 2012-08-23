From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Building xtables-addons
Date: Thu, 23 Aug 2012 15:19:20 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208231513500.32157@frira.zrqbmnf.qr>
References: <a9zfirwy.fsf@s1.test.com> <alpine.LNX.2.01.1207041651190.19493@frira.zrqbmnf.qr> <CAGuaRCu6vPxPY03rH3kZCEWUoG2dr4Mb+k2cJZLNqzAFbNnWXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Aft nix <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:50957 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758681Ab2HWNTV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Aug 2012 09:19:21 -0400
In-Reply-To: <CAGuaRCu6vPxPY03rH3kZCEWUoG2dr4Mb+k2cJZLNqzAFbNnWXg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2012-07-04 17:09, Aft nix wrote:

>On Wed, Jul 4, 2012 at 8:51 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>> On Wednesday 2012-07-04 15:20, AFT wrote:
>>>
>>>I have cloned xtables-addons git repo from SF. It has a "autogen.sh" to
>>>create the configure script. ./autogen.sh is failing with following
>>>message:
>>>
>>>/usr/bin/m4:configure.ac:33: Warning: excess arguments to builtin `m4_if' ignored
>
>[root@s1 xtables-addons]# m4 --version
>m4 (GNU M4) 1.4.13
>[root@s1 xtables-addons]# autoconf --version
>autoconf (GNU Autoconf) 2.63

Really don't know. I cannot reproduce this even after downgrading to
1.4.13/2.63. Maybe ask the autoconf folks?
