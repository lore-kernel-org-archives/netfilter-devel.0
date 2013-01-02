From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v2] iptables: merge libip6t SNPT and DNPT to NPT
Date: Wed, 2 Jan 2013 19:27:50 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301021927250.9702@nerf07.vanv.qr>
References: <20130102160349.GB3760@uweber-WS> <50E46742.1050507@sophos.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ulrich Weber <ulrich.weber@sophos.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:58727 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3ABS1w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:27:52 -0500
In-Reply-To: <50E46742.1050507@sophos.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2013-01-02 17:58, Ulrich Weber wrote:

> Was to quick ;) Please find proper fix attached,
> merging DNPT and SNPT into new NPT file.

Now, if you also use xtables_register_targets (i.e. the plural form 
function), that would also be cool.
