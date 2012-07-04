From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Building xtables-addons
Date: Wed, 4 Jul 2012 16:51:41 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207041651190.19493@frira.zrqbmnf.qr>
References: <a9zfirwy.fsf@s1.test.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: AFT <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:54401 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2GDOvn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:51:43 -0400
In-Reply-To: <a9zfirwy.fsf@s1.test.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-07-04 15:20, AFT wrote:
>
>I have cloned xtables-addons git repo from SF. It has a "autogen.sh" to
>create the configure script. ./autogen.sh is failing with following
>message:
>
>/usr/bin/m4:configure.ac:33: Warning: excess arguments to builtin `m4_if' ignored

Can you ask your system which versions of autoconf, automake, libtool 
and m4 you have installed?
