From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: libnftnl.pc lacks dependency from libmnl
Date: Fri, 27 Jun 2014 17:36:00 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1406271734110.32683@nerf08.vanv.qr>
References: <1005632599.974483.1403860585336.JavaMail.ngmail@webmail09.arcor-online.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: giorgio.nicole@arcor.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:46920 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbaF0PgE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:36:04 -0400
In-Reply-To: <1005632599.974483.1403860585336.JavaMail.ngmail@webmail09.arcor-online.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2014-06-27 11:16, giorgio.nicole@arcor.de wrote:

>Hi,
>
>I've noticed that the pkg-config file libnftnl.pc installed by the
>library package misses the dependency from libmnl in
>the 'Required:' line.
>
># cat libnftnl.pc.in
># libnftnl pkg-config file
>[...]
>Name: libnftnl
>Description: Netfilter nf_tables infrastructure library
>URL: http://netfilter.org/projects/libnftnl/
>Version: @VERSION@
>Requires:                                                             <=== this line

This seems correct, as the libmnl development files do not appear to be 
needed to write a libnftnl program.
