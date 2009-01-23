From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Patch for geoip match agains kernel 2.6.28
Date: Fri, 23 Jan 2009 10:23:07 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901231020310.17548@fbirervta.pbzchgretzou.qr>
References: <000301c97cd4$4b810f30$e2832d90$%olav@bjerkeset.com> <dd45289d0901221822v2d52b653h3f961dd8b4563843@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Svein Olav Bjerkeset <svein.olav@bjerkeset.com>,
	netfilter-devel@vger.kernel.org
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51706 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbZAWJXJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:23:09 -0500
In-Reply-To: <dd45289d0901221822v2d52b653h3f961dd8b4563843@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-01-23 03:22, NICOLAS BOULIANE wrote:
>
>Thanks for this patch. I'll update my patchlet repository as soon as I get home.
>
>peace,
>acidfu.

People still use POM patchlets? Gosh...

>On Thu, Jan 22, 2009 at 3:59 PM, Svein Olav Bjerkeset
><svein.olav@bjerkeset.com> wrote:
>> Hi,
>>
>> Changes in "struct xt_match" from kernel 2.6.27 to 2.6.28 made the latest
>> version og Geoip match (Feb 11th 2008) from kernel version 2.6.28 on. I have
>> developed a patch that will make Geoip match work with 2.6.28.
>>
>> The patch can be downloaded from the following URL:
>> http://bjerkeset.com/patches/geoip-match-2.6.28.patch.gz
>>
>> The patch is against
>> http://people.netfilter.org/acidfu/patchlets/geoip.tar.gz as of Feb 11th
>> 2008.

FYI, please try the geoip as packaged in xtables-addons.
Like all extensions in it, they automatically receive the necessary
API updates all at once the way it is written.
Also, this geoip has an exponential speedup.
Linux distros even have packages for it.


thanks,
Jan
