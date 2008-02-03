From: Pierre Chifflier <p.chifflier@inl.fr>
Subject: Re: [PATCH 01/34]  Introduce new SQL schema.
Date: Sun, 3 Feb 2008 18:34:21 +0100
Message-ID: <20080203173421.GC18888@piche.inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr> <47A5A411.9040307@netfilter.org> <20080203115028.GA25411@bayen.regit.org> <873asamd11.fsf@kruemel.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:41430 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755471AbYBCRe0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:34:26 -0500
Content-Disposition: inline
In-Reply-To: <873asamd11.fsf@kruemel.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 03, 2008 at 01:37:30PM +0100, Holger Eitzenberger wrote:
> Eric Leblond <eric@inl.fr> writes:
> 
> >> and what about sqlite3?
> >
> > I don't think sqlite3 will be able to support SQL things used in this
> > schema. Holger, do you confirm that ?
> 
> AFAIK sqlite3 does not have stored procedures as other databases have,
> instead you can use triggers with somewhat limited functionality
> compared to stored procedures.  Alternatively you can write extensions
> in plain C, but those may not be what you need.
> 
> Does your change optimize DB memory consumption or is it targeted at
> improving access times?

Hi,

The new SQL schema has the following advantages:

 - storage: split packets into several tables (instead of one big
   table). This can help a lot on storage efficiency, depending on the
   DB

 - indexes: many indexes were missing

 - SQL schema independence: stored procedures and views are used to
   ensure the C code does not have to know how SQL data are stored. This
   abstraction layer allows to change the SQL layout without changing
   the C code

 - extensibility: a unique ID is used as a relation between tables. This
   way, a third-party application can create tables to add information,
   without changing the default SQL schema.
   Foreign keys are used to ensure consistency.

The main idea was to introduce this abstraction layer to "hide"
insertions into multiple tables. Unfortunately, I'm not sure how to
handle this with sqlite ..
Using stored procedures may improve access times by preparing the query
once (sort of compilation) and executing it faster, though this is not
the first objective.
Using several tables will mostly help for read access.

Regards,
Pierre
