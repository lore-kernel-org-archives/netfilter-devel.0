From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Packet cloning
Date: Fri, 16 Oct 2009 19:55:30 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0910161955120.24545@obet.zrqbmnf.qr>
References: <4AD8A129.8080606@ecessa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@ecessa.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38838 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbZJPRz1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:55:27 -0400
In-Reply-To: <4AD8A129.8080606@ecessa.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-10-16 18:36, Bryan Duff wrote:

>Is it possible to have a CLONE target?

There is TEE in xtables-addons.

>Where matching packets will be cloned and 2 packets will emerge and
>continue traversing the chain?

You always have to ask yourself what the purpose of that is supposed to 
be.
