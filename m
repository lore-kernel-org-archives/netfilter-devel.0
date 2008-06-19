From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables-1.4.1.1 but no iptables file
Date: Thu, 19 Jun 2008 08:24:44 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806190823240.14231@fbirervta.pbzchgretzou.qr>
References: <66c5208e0806182131n581a29bbhcc02d6c3f1b9215@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: michael <mteicher@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42976 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057AbYFSGYp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 02:24:45 -0400
In-Reply-To: <66c5208e0806182131n581a29bbhcc02d6c3f1b9215@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2008-06-19 06:31, michael wrote:

>Hello,
>
>Sorry for the cross post.  I mistakenly posted to the users mailing list.
>
>On linux 2.4.34
>ran configure && make && make install
>Everything looks good but I cannot see where iptables was installed.

/usr/local/sbin/iptables.

>The only new file I can see installed is /usr/local/bin/iptables-xml ,
>/usr/local/libexec/xtables (no files in there),

You probably disabled modules.

>and several man pages in /usr/local/share/man/man8.
>
>The install exited cleanly.
>
>I have been running iptables 1.3.37 for awhile.  I have done a cursory
>search and have yet to understand what I am missing.
