From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: [iptables PATCH] build: add DESTDIR to vx_bin_links
Date: Fri, 6 Sep 2013 22:14:57 -0400
Message-ID: <CA+0KVf2vdjHfcS=p9Z9RLy-vgogvan2S2RrU2CcsOBDWe-JBHg@mail.gmail.com>
References: <1378503540-16134-1-git-send-email-ljlane@debian.org> <alpine.LSU.2.11.1309070244090.3288@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ankh.ljlane.net ([71.19.149.249]:46645 "EHLO ankh.ljlane.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab3IGCPU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Sep 2013 22:15:20 -0400
Received: from mail-ve0-f182.google.com (mail-ve0-f182.google.com [209.85.128.182])
	(using TLSv1 with cipher ECDHE-RSA-RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: google-debian@ankh.ljlane.net)
	by ankh.ljlane.net (Postfix) with ESMTPSA id 8742B2B106
	for <netfilter-devel@vger.kernel.org>; Fri,  6 Sep 2013 22:15:19 -0400 (EDT)
Received: by mail-ve0-f182.google.com with SMTP id oy12so2165045veb.13
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Sep 2013 19:15:18 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.11.1309070244090.3288@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

You're right. Withdrawn.

On Fri, Sep 6, 2013 at 8:49 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Friday 2013-09-06 23:39, Laurence J. Lane wrote:
>
>>Fixes dangling symlinks when using DESTDIR.
>>
>>Signed-off-by: Laurence J. Lane <ljlane@debian.org>
>>-      for i in ${vx_bin_links}; do ${LN_S} -f \
>>           "${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
>>+      for i in ${vx_bin_links}; do ${LN_S} -f \
>>           "${DESTDIR}${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
>
> This seems totally incorrect. By including DESTDIR in the symlink
> target, you are *creating* a dangling symlink. RPM, DEB (and whatever
> other packages) would suddenly contain a file that goes like
>
>  $ rpm -ql iptables
>  lrwxrwxrwx 1 root root 13 Jan 27 2013 /usr/sbin/iptables ->
>    /home/abuild/rpmbuild/BUILDROOT/iptables-1.4.20/usr/bin/xtables-multi
>
> !DSPAM:522a78438821787114786!
>
>
