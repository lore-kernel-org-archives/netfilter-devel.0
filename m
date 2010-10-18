From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Question about ebtables.
Date: Mon, 18 Oct 2010 10:08:06 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010181007480.9631@obet.zrqbmnf.qr>
References: <C13A00ED-B438-44A6-82A0-6E7530FB7E8B@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sumin Xia <xiasumin1984@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45192 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094Ab0JRIII (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:08:08 -0400
In-Reply-To: <C13A00ED-B438-44A6-82A0-6E7530FB7E8B@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2010-10-18 03:26, Sumin Xia wrote:

> Hello,
>
> I am new to ebtables. Recently, I am working on a project, which needs to
> modify mac address of each frame in a middle box in order to forward the frame
> to next expected middle box. I want to know whether I can modify mac headers by
> ebtables. And how to modify it?

man ebtables
=> see snat, dnat.
