From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: new target: -j TEE
Date: Mon, 1 Oct 2007 15:01:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710011456130.7130@fbirervta.pbzchgretzou.qr>
References: <1188216512.6900.24.camel@basti79.freenet-ag.de>
 <Pine.LNX.4.64.0708271539140.11442@fbirervta.pbzchgretzou.qr>
 <1188237343.4548.4.camel@calypso> <46D5C304.9040102@trash.net>
 <Pine.LNX.4.64.0708292130520.24730@fbirervta.pbzchgretzou.qr>
 <20070830070004.GF8438@oknodo.bof.de>  <1189669027.22541.6.camel@basti79.freenet-ag.de>
  <1189677553.22541.11.camel@basti79.freenet-ag.de>
 <Pine.LNX.4.64.0709142354170.10168@fbirervta.pbzchgretzou.qr>
 <1191242647.6469.9.camel@basti79.freenet-ag.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sebastian Classen <sebastian.classen@freenet.ag>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40151 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbXJANBP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Oct 2007 09:01:15 -0400
In-Reply-To: <1191242647.6469.9.camel@basti79.freenet-ag.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 1 2007 14:44, Sebastian Classen wrote:
>
>i was in holiday, so i couldn't work on the patch for a while. But here
>is the current version which seems to work with current 2.6.22.9.
>
>For the Changelog:
> - fixed comment to route()
> - removed route_gw()
> - removed TTL handling
> - make compile without CONFIG_NF_CONNTRACK (no loop-prevention in this
>case!)
>

Updated.

