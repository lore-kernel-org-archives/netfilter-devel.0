From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Hi again, get the process id associated to a packet
Date: Mon, 5 Jan 2009 03:56:00 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901050355380.4014@fbirervta.pbzchgretzou.qr>
References: <92770c820901041643t1b460c2bj4323a60ffcfc2c94@mail.gmail.com> <1231118620.3927.18.camel@ice-age>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ilninno <ilninno@gmail.com>, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35646 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZAEC4E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Jan 2009 21:56:04 -0500
In-Reply-To: <1231118620.3927.18.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-01-05 02:23, Eric Leblond wrote:
>
>By the way, you will find some libnetfilter_queue documentation here:
>http://www.nufw.org/doc/libnetfilter_queue/

By the way, I notice that nfq_errno is not thread-safe.
