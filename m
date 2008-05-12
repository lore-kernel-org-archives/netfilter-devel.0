From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [patch 2/4] Add support for --set-counters to iptables -P
Date: Mon, 12 May 2008 20:31:23 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805122030280.25441@fbirervta.pbzchgretzou.qr>
References: <1210616702.3442.33.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49395 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYELSbY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 14:31:24 -0400
In-Reply-To: <1210616702.3442.33.camel@henriknordstrom.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-05-12 20:25, Henrik Nordstrom wrote:

>Adds support for setting the policy counters
>
>iptables -P INPUT -J DROP -c 10 20

Could this perhaps be changed so that -c only takes one argument?
Like -c 10,20. This would ease integration with passthrough
argument parsing in 3rd party applications.

