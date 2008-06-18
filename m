From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] libnfnetlink byte alignment
Date: Wed, 18 Jun 2008 14:39:29 +0200
Message-ID: <48590201.8040902@netfilter.org>
References: <1212488448.29489.40.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59496 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752392AbYFRMj6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:39:58 -0400
In-Reply-To: <1212488448.29489.40.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Aligns buffers to maximum alignment of architecture to make the cast of
> char pointers to struct pointers more portable.

Applied. Thanks Fabian.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
