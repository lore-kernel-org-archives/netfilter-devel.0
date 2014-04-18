From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v2] xt_quota2: introduce support for network namespaces
Date: Fri, 18 Apr 2014 19:20:52 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1404181920430.11175@nerf08.vanv.qr>
References: <20140305110756.GA16910@earthship.local.cellrox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jpa@google.com, john.stultz@linaro.org,
	containers@lists.linux-foundation.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Daniel Golle <dgolle@cellrox.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:35337 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaDRRUy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:20:54 -0400
In-Reply-To: <20140305110756.GA16910@earthship.local.cellrox.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2014-03-05 12:07, Daniel Golle wrote:

>Initialize a separate xt_quota2 instance for each network
>namespace so data limit can be set and enforced per container.

That's applied now.
