From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] ipset 6.28 released
Date: Sat, 12 Mar 2016 23:06:53 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603122259210.6559@nerf40.vanv.qr>
References: <alpine.DEB.2.10.1603122210440.15491@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:55758 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbcCLWG4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 17:06:56 -0500
In-Reply-To: <alpine.DEB.2.10.1603122210440.15491@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>I'm happy to announce ipset 6.28 with a couple of important fixes, some 
>compatibility improvements and corrections.
>  - Support older pkg-config packages

Whatever you did, it broke.

[   51s] checking for libmnl... no
[   51s] configure: error: in `/home/abuild/rpmbuild/BUILD/ipset-default-6.28':
[   51s] configure: error: The pkg-config script could not be found or is too
old.  Make sure it
[   51s] is in your PATH or set the PKG_CONFIG environment variable to the full
[   51s] path to pkg-config.


$ bash -x configure
checking for libmnl... + test -n ''
+ test -n ''
+ pkg_failed=untried
+ test -n ''
+ test -n ''
+ pkg_failed=untried
+ test untried = yes
+ test untried = untried
+ printf '%s\n' 'configure:14007: result: no'
+ printf '%s\n' no
no
+ printf '%s\n' 'configure:14009: error: in `/home/abuild/rpmbuild/BUILD/ipset-default-6.28'\'':'
+ printf '%s\n' 'configure: error: in `/home/abuild/rpmbuild/BUILD/ipset-default-6.28'\'':'
configure: error: in `/home/abuild/rpmbuild/BUILD/ipset-default-6.28':
+ as_fn_error 0 'The pkg-config script could not be found or is too old.  Make sure it
is in your PATH or set the PKG_CONFIG environment variable to the full
path to pkg-config.


So the first occurrence of the substring "pkg-config" is this.
In other words, PKG_PROG_PKG_CONFIG appears to have never expanded.

Come to think of it, wonder why was there no PKG_PROG_PKG_CONFIG to begin
with. That may have been the original problem all along.

Revert a3a984901f580d1a7d07cbfceb5dc279c035dcb1 and then slap a
PKG_PROG_PKG_CONFIG before the first PKG_somethingelse line.
