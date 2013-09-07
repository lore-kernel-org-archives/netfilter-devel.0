From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH] build: add DESTDIR to vx_bin_links
Date: Sat, 7 Sep 2013 02:49:37 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1309070244090.3288@nerf07.vanv.qr>
References: <1378503540-16134-1-git-send-email-ljlane@debian.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:58555 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3IGAtj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Sep 2013 20:49:39 -0400
In-Reply-To: <1378503540-16134-1-git-send-email-ljlane@debian.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2013-09-06 23:39, Laurence J. Lane wrote:

>Fixes dangling symlinks when using DESTDIR.
>
>Signed-off-by: Laurence J. Lane <ljlane@debian.org>
>-	for i in ${vx_bin_links}; do ${LN_S} -f \
>           "${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;
>+	for i in ${vx_bin_links}; do ${LN_S} -f \
>           "${DESTDIR}${sbindir}/xtables-multi" "${DESTDIR}${bindir}/$$i"; done;

This seems totally incorrect. By including DESTDIR in the symlink 
target, you are *creating* a dangling symlink. RPM, DEB (and whatever 
other packages) would suddenly contain a file that goes like

 $ rpm -ql iptables
 lrwxrwxrwx 1 root root 13 Jan 27 2013 /usr/sbin/iptables ->
   /home/abuild/rpmbuild/BUILDROOT/iptables-1.4.20/usr/bin/xtables-multi
