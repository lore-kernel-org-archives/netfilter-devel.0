From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 01/34]  Introduce new SQL schema.
Date: Mon, 04 Feb 2008 00:54:37 +0100
Message-ID: <47A6543D.4010406@netfilter.org>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr> <47A5A411.9040307@netfilter.org> <20080203115028.GA25411@bayen.regit.org> <873asamd11.fsf@kruemel.eitzenberger.org> <20080203173421.GC18888@piche.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Holger Eitzenberger <holger@eitzenberger.org>,
	Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Pierre Chifflier <p.chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41850 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753516AbYBCXzB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 18:55:01 -0500
In-Reply-To: <20080203173421.GC18888@piche.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pierre Chifflier wrote:
> The main idea was to introduce this abstraction layer to "hide"
> insertions into multiple tables. Unfortunately, I'm not sure how to
> handle this with sqlite ..

Since sqlite doesn't seem to have stored procedures, I think that we can
cook a modified version of sql_createstmt() for sqlite that recovers the
code that Eric's patch [1/34] has removed from util/db.c. Patches welcome.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
