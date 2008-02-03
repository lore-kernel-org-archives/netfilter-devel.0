From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [PATCH 01/34]  Introduce new SQL schema.
Date: Sun, 03 Feb 2008 13:37:30 +0100
Message-ID: <873asamd11.fsf@kruemel.eitzenberger.org>
References: <1201987469575-git-send-email-eric@inl.fr>
	<1201987469368-git-send-email-eric@inl.fr>
	<47A5A411.9040307@netfilter.org> <20080203115028.GA25411@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.183]:55808 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936363AbYBCMhm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 07:37:42 -0500
In-Reply-To: <20080203115028.GA25411@bayen.regit.org> (Eric Leblond's
 message of "Sun, 3 Feb 2008 12:50:28 +0100")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond <eric@inl.fr> writes:

>> and what about sqlite3?
>
> I don't think sqlite3 will be able to support SQL things used in this
> schema. Holger, do you confirm that ?

AFAIK sqlite3 does not have stored procedures as other databases have,
instead you can use triggers with somewhat limited functionality
compared to stored procedures.  Alternatively you can write extensions
in plain C, but those may not be what you need.

Does your change optimize DB memory consumption or is it targeted at
improving access times?

 /holger
