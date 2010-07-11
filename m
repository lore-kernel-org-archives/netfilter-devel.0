From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv2] extensions: libxt_CHECKSUM extension
Date: Sun, 11 Jul 2010 22:00:20 +0300
Message-ID: <20100711190020.GA11244@redhat.com>
References: <20100711151453.GA7563@redhat.com>
 <alpine.LSU.2.01.1007111755250.22644@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604Ab0GKTFh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jul 2010 15:05:37 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1007111755250.22644@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 11, 2010 at 05:57:07PM +0200, Jan Engelhardt wrote:
> 
> >This adds a `CHECKSUM' target, which can be used in the iptables mangle 
> >table.
> >
> >You can use this target to compute and fill in the checksum in a packet 
> >that lacks a checksum.  This is particularly useful, if you need to 
> >work around old applications such as dhcp clients, that do not work 
> >well with checksum offloads, but don't want to disable checksum offload 
> >in your device.
> >
> >The problem happens in the field with virtualized applications. For 
> >reference, see Red Hat bz 605555, as well as 
> >http://www.spinics.net/lists/kvm/msg37660.html
> 
> Added to Xtables-addons.

Please do not drop the explanation that bits were copied from ECN.c.

-- 
MST
