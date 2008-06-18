From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] libnetfilter-conntrack byte alignment
Date: Wed, 18 Jun 2008 14:40:05 +0200
Message-ID: <48590225.8040002@netfilter.org>
References: <1212488483.29489.42.camel@pumper.lan.luxnet.ch> <1213648369.29727.13.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53719 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752482AbYFRMkK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:40:10 -0400
In-Reply-To: <1213648369.29727.13.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Use union of char buffer and message header to ensure proper byte
> alignment.

Also applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
