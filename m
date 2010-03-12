From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Installing Xtables-Addons
Date: Fri, 12 Mar 2010 13:47:43 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003121347200.32149@obet.zrqbmnf.qr>
References: <2a3692de1003120439k75adfae3ie2bc484152c2b82b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Dominik Kaspar <dokaspar.ietf@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43274 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab0CLMro (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Mar 2010 07:47:44 -0500
In-Reply-To: <2a3692de1003120439k75adfae3ie2bc484152c2b82b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-03-12 13:39, Dominik Kaspar wrote:
>
>I tried installing the xtables-addons by first downloading it as follows:

(What about the tarball?)

>However, "./configure" does not work: "bash: ./configure: No such file
>or directory"
>There is no file "configure" in the repository, only a "configure.ac".
>I'm unfamiliar with "autotools"... what exactly is required to make
>this work?

./autogen.sh
