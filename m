From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH] Store only one copy of mac address in SQL DB (resend)
Date: Thu, 12 Jun 2008 11:45:54 +0200
Message-ID: <4850F052.1050804@netfilter.org>
References: <20080612093820.GB23435@piche.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55479 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752976AbYFLJqH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:46:07 -0400
In-Reply-To: <20080612093820.GB23435@piche.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pierre Chifflier wrote:
> This patch modifies the SQL schema for MySQL and PostgreSQL to store
> the mac address only once (instead of duplicating the mac address for
> each packet).
> This is done by using a shared reference to the entry containing the
> tuple (mac_address,mac_protocol).

Applied. Thanks Pierre.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
