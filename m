From: Patrick McHardy <kaber@trash.net>
Subject: Re: does sip_conntrack support TCP and TCP/TLS media transport?
Date: Mon, 19 Jan 2009 15:27:43 +0100
Message-ID: <49748DDF.8010006@trash.net>
References: <49739CDE.4000804@cegetel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Christophe Lohr <christophe.lohr@cegetel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40191 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbZASO1p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:27:45 -0500
In-Reply-To: <49739CDE.4000804@cegetel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christophe Lohr wrote:
> Hi,
> Does the sip_conntrack support TCP (rfc4145) and TCP/TLS (rfc4572) media 
> transport?

No, I couldn't find a SIP application supporting TCP for testing
or an application/server supporting TLS.

> (also, does it accept  "application", "data" and "control" media types?)

It supports "audio" and "video". IIRC there was one more (probably
application) that I didn't add for the same reason, I couldn't find
an application for testing. The other two I've not heard of yet.

