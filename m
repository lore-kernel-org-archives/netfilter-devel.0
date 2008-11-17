From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Problem compiling
Date: Mon, 17 Nov 2008 23:01:33 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811172259080.17946@fbirervta.pbzchgretzou.qr>
References: <49219BF2.6090904@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56965 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYKQWBf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:01:35 -0500
In-Reply-To: <49219BF2.6090904@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-11-17 17:29, John Haxby wrote:

> Hello All,
>
> I'm having problems compiling this:
> http://marek.terminus.sk/prog/ipt_sysrq.shtml
>
> This is on Fedora 9 and RHEL5 and in both cases I get this error:
>
> /usr/include/iptables.h:5:29: error: libiptc/libiptc.h: No such file or
> directory

(Just noting that this error has nothing to do with ipt_sysrq.)

> Now, the easiest way to "fix" this is it to make sure that libiptc/libiptc.h is
> installed into /usr/include

What iptables version?
