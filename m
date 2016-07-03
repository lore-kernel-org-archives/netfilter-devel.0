From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: libxtables backward compatibility
Date: Sun, 3 Jul 2016 22:59:36 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1607032252110.20663@nerf40.vanv.qr>
References: <20160703160042.76f76433@playground>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:44724 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbcGCU7l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 16:59:41 -0400
In-Reply-To: <20160703160042.76f76433@playground>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2016-07-03 22:00, Neal P. Murphy wrote:

>Specifically, should programs linked to--and expecting to use--libxtables.so.7
>work with versions libxtables.so.10 and libxtables.so.11? I suspect yes

Absolutely not. Never has been in any shared library system.
