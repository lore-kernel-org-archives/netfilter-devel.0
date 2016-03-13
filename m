From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] ipset 6.28 released
Date: Sun, 13 Mar 2016 12:07:36 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603131142500.23616@nerf40.vanv.qr>
References: <alpine.DEB.2.10.1603122210440.15491@blackhole.kfki.hu> <alpine.LSU.2.20.1603122259210.6559@nerf40.vanv.qr> <alpine.DEB.2.10.1603131133010.18557@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:35392 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491AbcCMLHm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Mar 2016 07:07:42 -0400
In-Reply-To: <alpine.DEB.2.10.1603131133010.18557@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2016-03-13 11:33, Jozsef Kadlecsik wrote:
>On Sat, 12 Mar 2016, Jan Engelhardt wrote:
>
>Does this patch help to solve the problem?
>
>diff --git a/configure.ac b/configure.ac
>index 1988836..b05646b 100644
>--- a/configure.ac
>+++ b/configure.ac
>@@ -12,6 +12,8 @@ LT_INIT([dlopen])
> LT_CONFIG_LTDL_DIR([libltdl])
> LTDL_INIT([nonrecursive])
> 
>+PKG_PROG_PKG_CONFIG
>+
> dnl Shortcut: Linux supported alone
> case "$host" in
> *-*-linux* | *-*-uclinux*) ;;

It does.
