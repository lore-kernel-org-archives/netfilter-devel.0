From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RFC][PATCH] Per-conntrack timeout target v3
Date: Mon, 17 Dec 2007 14:01:00 -0800
Message-ID: <20071217220100.GA24118@linuxace.com>
References: <20071127190745.GA2080@linuxace.com> <474D2F88.5050707@trash.net> <20071217212010.GA23837@linuxace.com> <Pine.LNX.4.64.0712172228060.32270@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:47583
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753590AbXLQWBC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:01:02 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712172228060.32270@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 17, 2007 at 10:28:49PM +0100, Jan Engelhardt wrote:
> >In thinking about this, it seems like a HELPER target would be
> >useful, for instance if some random FTP server ran on a non-standard
> >port and we wanted the FTP helper to be used.  Something like:
> >
> >    -s X -p 210 -j HELPER --helper ftp
> 
> BTW, the helper code is said to already do that (man iptables):
> 
> 	--helper ftp-2121

Actually that's for the helper _match_, so you could for instance
match packets which are part of a helper configured on a non-standard
port via module parameter.  So this is different, in that it would
allow you to specify non-standard ports at runtime.

Phil
