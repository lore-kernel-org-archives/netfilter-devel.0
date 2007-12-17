From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC][PATCH] Per-conntrack timeout target v3
Date: Mon, 17 Dec 2007 22:28:49 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712172228060.32270@fbirervta.pbzchgretzou.qr>
References: <20071127190745.GA2080@linuxace.com> <474D2F88.5050707@trash.net>
 <20071217212010.GA23837@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52923 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361AbXLQV2w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:28:52 -0500
In-Reply-To: <20071217212010.GA23837@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 17 2007 13:20, Phil Oester wrote:
>On Wed, Nov 28, 2007 at 10:06:16AM +0100, Patrick McHardy wrote:
>> I think the patch is useful, but I wonder how long it will take until
>> people want to override timeouts for other connection states. I'm
>> also looking for a way to pass parameters for new connections to
>> helpers (most of the things that are currently module parameters),
>> so maybe we could generalize this to a conntrack parameter target?
>
>In thinking about this, it seems like a HELPER target would be
>useful, for instance if some random FTP server ran on a non-standard
>port and we wanted the FTP helper to be used.  Something like:
>
>    -s X -p 210 -j HELPER --helper ftp

BTW, the helper code is said to already do that (man iptables):

	--helper ftp-2121

