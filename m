From: Aft nix <aftnix@gmail.com>
Subject: Re: Building xtables-addons
Date: Wed, 4 Jul 2012 21:09:22 +0600
Message-ID: <CAGuaRCu6vPxPY03rH3kZCEWUoG2dr4Mb+k2cJZLNqzAFbNnWXg@mail.gmail.com>
References: <a9zfirwy.fsf@s1.test.com>
	<alpine.LNX.2.01.1207041651190.19493@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57411 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab2GDPJW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jul 2012 11:09:22 -0400
Received: by ghrr11 with SMTP id r11so6547890ghr.19
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jul 2012 08:09:22 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1207041651190.19493@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 4, 2012 at 8:51 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> On Wednesday 2012-07-04 15:20, AFT wrote:
>>
>>I have cloned xtables-addons git repo from SF. It has a "autogen.sh" to
>>create the configure script. ./autogen.sh is failing with following
>>message:
>>
>>/usr/bin/m4:configure.ac:33: Warning: excess arguments to builtin `m4_if' ignored
>
> Can you ask your system which versions of autoconf, automake, libtool
> and m4 you have installed?

Hi Jan,

i have the following versions for autotools in my system

[root@s1 xtables-addons]# m4 --version
m4 (GNU M4) 1.4.13

[root@s1 xtables-addons]# autoconf --version
autoconf (GNU Autoconf) 2.63

[root@s1 xtables-addons]# automake --version
automake (GNU automake) 1.11.1

[root@s1 xtables-addons]# libtool --version
ltmain.sh (GNU libtool) 2.2.6b

cheers
aft



-- 
-aft
