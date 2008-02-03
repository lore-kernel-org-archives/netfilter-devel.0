From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 01/34]  Introduce new SQL schema.
Date: Sun, 03 Feb 2008 13:14:38 +0100
Message-ID: <47A5B02E.5000103@netfilter.org>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr> <47A5A411.9040307@netfilter.org> <20080203115028.GA25411@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org,
	Holger Eitzenberger <holger@eitzenberger.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60238 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933133AbYBCMRX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:17:23 -0500
In-Reply-To: <20080203115028.GA25411@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
>> Since now we use user-defined procedures and call them, we have to
>> remove the old mysql and pgsql definitions from doc/ as well which does
>> not use it,
> 
> You're right?
> 
>> and what about sqlite3?
> 
> I don't think sqlite3 will be able to support SQL things used in this
> schema. Holger, do you confirm that ?

Then, my guess is that we have to introduce some kind of compatibility
if we decide to support sqlite3. Holger?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
