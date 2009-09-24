From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: new target - ebtables dynamic snat, kernel and userspace patch
Date: Thu, 24 Sep 2009 10:12:30 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909241011400.13479@obet.zrqbmnf.qr>
References: <4ABB2336.6040806@storwize.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, bdschuym@pandora.be,
	shai.tahar@storwize.com
To: Shai Tahar <shait@storwize.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34233 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbZIXIMa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:12:30 -0400
In-Reply-To: <4ABB2336.6040806@storwize.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-09-24 09:43, Shai Tahar wrote:

> ---- README ---
> ebt_dyn_snat - ebtable dynamic snat
>    Authors:
>      Shai Tahar <shai.tahar@storwize.com>
>
>    Changes source mac address according to source ip address based on local
> arp table
>    to be used when source ip address is snated
>
> Copyright (C) 2009 Storwize
>
> ebtables target for transparent bridge
> [user]<--->[transparent bridge]<--->[server]
>
> if the transparent bridge maskes user ip address towards the server,
> the bridge normally would replace the source mac address

Well, if you want to have the client's original MAC address in the
packet, do not SNAT it. It (seems) as simple as that.
