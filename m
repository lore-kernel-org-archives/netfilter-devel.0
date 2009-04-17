From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables compile fails.
Date: Fri, 17 Apr 2009 16:02:48 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904171602170.3060@fbirervta.pbzchgretzou.qr>
References: <49E5EA1E.6060504@astrocorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@ecessa.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45723 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbZDQOCv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:02:51 -0400
In-Reply-To: <49E5EA1E.6060504@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-04-15 16:07, Bryan Duff wrote:

> From |(git://xtables-addons.git.sf.net/gitroot/xtables-addons/).|
>[...]
> //end snip
>
> I looked in /usr/src/linux/include/linux/proc_fs.h - and struct module *owner
> is now longer in 2.6.30.

Fixed, thanks.
(v1.14-9-ge36c757)
