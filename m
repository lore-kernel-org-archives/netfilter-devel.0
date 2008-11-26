From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Building the conntrack rule from scratch
Date: Wed, 26 Nov 2008 23:20:41 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811262320120.21265@fbirervta.pbzchgretzou.qr>
References: <492DC363.3040304@astrocorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@astrocorp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43039 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbYKZWUn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:20:43 -0500
In-Reply-To: <492DC363.3040304@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-11-26 22:45, Bryan Duff wrote:

> If I build a conntrack rule (before any traffic actually traverses), and then
> send traffic through, the conntrack rule gets used, but no SNAT takes place.

Elaborate?

> Tell me if I'm missing something, or if more information is needed.

The actual "rule".
