From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [conntrack-tools] XML output is invalid
Date: Fri, 20 Jun 2008 16:03:04 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806201548540.11250@fbirervta.pbzchgretzou.qr>
References: <F7825499-A8F5-4F41-B3DD-2E13807954E2@rotsen.be> <485BAF8B.1050502@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sen Haerens <sen@rotsen.be>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58371 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbYFTODG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2008 10:03:06 -0400
In-Reply-To: <485BAF8B.1050502@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-06-20 15:24, Pablo Neira Ayuso wrote:
>> 
>> * The XML declaration is missing: <?xml version="1.0"?>
>> * There can only be one root element. We have to wrap all the flow
>> elements into a single root element:
>> <conntrack>
>> <flow>[...]</flow>
>> <flow>[...]</flow>
>> [...]
>> </conntrack>
>> 
>> My version: conntrack v0.9.7 (conntrack-tools)
>
>Does this patch help?

Also specify the encoding: <?xml version="1.0" encoding="utf-8" ?>
