From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH xtables-addons] build: fix configure compatiblity with
 POSIX shells
Date: Sun, 3 Apr 2016 12:11:42 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1604031202380.31323@nerf40.vanv.qr>
References: <080ce332d72f144b21b5d63986b6e8ebd9bc3095.1459542934.git.mschiffer@universe-factory.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Matthias Schiffer <mschiffer@universe-factory.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:40558 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbcDCKLp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Apr 2016 06:11:45 -0400
In-Reply-To: <080ce332d72f144b21b5d63986b6e8ebd9bc3095.1459542934.git.mschiffer@universe-factory.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2016-04-01 22:35, Matthias Schiffer wrote:

>The kernel version detection code uses some bashisms, which makes the build
>fail on Debian systems where /bin/sh links to dash. Replace with POSIX-
>conforming commands at the cost of requiring awk.
>+	krel="$(make -sC "$kbuilddir" M=$PWD kernelrelease | $AWK -v 'FS=[[^0-9.]]' '{print $1; exit}')";
>+	save_IFS=$IFS;
>+	IFS='.';
>+	set x $krel;
>+	kmajor="$(($2+0))";
>+	kminor="$(($3+0))";
>+	kmicro="$(($4+0))";
>+	kstable="$(($5+0))";
>+	IFS=$save_IFS;
> 	if test -z "$kmajor" -o -z "$kminor" -o -z "$kmicro"; then

To test its resilience against silly krel strings (not exactly unheard of),
let's pretend that

	krel="4x.6.0"

The previous code would conclude (albeit with a silly broken-up version like
4.0.6.0 or 0.0.0.0). However, your change makes the script totally falls over:

checking kernel version that we will build against... ./configure: line
11957: 4x: value too great for base (error toke
n is "4x")
./configure: line 8: printf %s\n: command not found
./configure: line 14: AMDEPBACKSLASH: command not found
./configure: line 15: AMDEP_FALSE: command not found
./configure: line 16: AMDEP_TRUE: command not found
./configure: line 17: AMTAR: command not found
[...]

(and who knows what other commands - rm? - it tries to execute by sheer
chance).
Is it possible to harden the dash-compatible variant?
