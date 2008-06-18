From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] libnetlink-log byte alignment
Date: Wed, 18 Jun 2008 15:13:46 +0200
Message-ID: <48590A0A.3020102@netfilter.org>
References: <1212488472.29489.41.camel@pumper.lan.luxnet.ch> <1213648356.29727.12.camel@pumper.lan.luxnet.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40793 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753425AbYFRNOD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:14:03 -0400
In-Reply-To: <1213648356.29727.12.camel@pumper.lan.luxnet.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Use union of char buffer and message header to ensure proper byte
> alignment.

Applied. Thanks.

> This patch increases portability, but alignment is still not respected
> in nflog_get_*() which still leaves libnetfilter_log unusable on
> particular platforms.

Sorry, I lost track of this alignment issues, what's problem?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
