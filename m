From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [iptables PATCH] build: add DESTDIR to vx_bin_links
Date: Sat, 7 Sep 2013 23:41:08 -0700
Message-ID: <CAHo-OozRAQw+WffYW0JyD37wdVUFQmgyi_6ePLst0s5Kz+cgBA@mail.gmail.com>
References: <1378503540-16134-1-git-send-email-ljlane@debian.org>
	<alpine.LSU.2.11.1309070244090.3288@nerf07.vanv.qr>
	<CA+0KVf2vdjHfcS=p9Z9RLy-vgogvan2S2RrU2CcsOBDWe-JBHg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51194 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3IHGlJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Sep 2013 02:41:09 -0400
Received: by mail-vc0-f172.google.com with SMTP id m17so3270284vca.3
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Sep 2013 23:41:08 -0700 (PDT)
In-Reply-To: <CA+0KVf2vdjHfcS=p9Z9RLy-vgogvan2S2RrU2CcsOBDWe-JBHg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It should probably be a relative link, but that's probably hard to do
seeing as we don't know how many levels up you need to go...

On Fri, Sep 6, 2013 at 7:14 PM, Laurence J. Lane <ljlane@debian.org> wrote:
> You're right. Withdrawn.
>
> On Fri, Sep 6, 2013 at 8:49 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>>
>> On Friday 2013-09-06 23:39, Laurence J. Lane wrote:
>>
>>>Fixes dangling symlinks when using DESTDIR.
>>>
>>>Signed-off-by: Laurence J. Lane <ljlane@debian.org>
>>>-      for i in ${vx_bin_links}; do ${LN_S} -f \
>>>           "${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
>>>+      for i in ${vx_bin_links}; do ${LN_S} -f \
>>>           "${DESTDIR}${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
>>
>> This seems totally incorrect. By including DESTDIR in the symlink
>> target, you are *creating* a dangling symlink. RPM, DEB (and whatever
>> other packages) would suddenly contain a file that goes like
>>
>>  $ rpm -ql iptables
>>  lrwxrwxrwx 1 root root 13 Jan 27 2013 /usr/sbin/iptables ->
>>    /home/abuild/rpmbuild/BUILDROOT/iptables-1.4.20/usr/bin/xtables-multi
>>
>> !DSPAM:522a78438821787114786!
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
