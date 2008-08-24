From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Packet marking based on IP header
Date: Sat, 23 Aug 2008 20:41:00 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808232040390.8996@fbirervta.pbzchgretzou.qr>
References: <48AA807C.5020108@fel.cvut.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Marek Becka <beckam2@fel.cvut.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54274 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbYHXAlB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Aug 2008 20:41:01 -0400
In-Reply-To: <48AA807C.5020108@fel.cvut.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-08-19 04:12, Marek Becka wrote:

> Hi, I'm working on iptables target, that enables marking ipv4/6
> packet based on their headers. I need this for high performance
> gateway that marks packet by part of source address.

For that purpose, there is IPMARK in Xtables-addons.
