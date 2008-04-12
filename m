From: Anton <anton.vazir@gmail.com>
Subject: Re: ULOGD2 PostgresSql errors
Date: Sat, 12 Apr 2008 12:43:08 +0500
Message-ID: <200804121243.08408.anton.vazir@gmail.com>
References: <200804111605.39957.anton.vazir@gmail.com> <20080411193312.GE20469@bayen.regit.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:46659 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYDLHnL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2008 03:43:11 -0400
In-Reply-To: <20080411193312.GE20469@bayen.regit.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Erik,

Seems it fixes ICMP inserts. Just for testing I tried MYSQL 
logging too - it works without errors in log file, and 
looks it logs more data than PGSQL. 

Regards,
Anton.

On Saturday 12 April 2008 00:33, Eric Leblond wrote:
> Hello,
>
> On Friday, 2008 April 11 at 16:05:39 +0500, Anton wrote:
> > Hello!
> >
> > ulogd.log output is below:
> >
> > Fri Apr 11 16:00:10 2008 <7> ../../util/db.c:185 no
> > connection to database, attempting to reconnect after 2
> > seconds Fri Apr 11 16:00:10 2008 <5> ulogd.c:488 error
> > during propagate_results Fri Apr 11 16:00:12 2008 <1>
> > ulogd_output_PGSQL.c:99 SELECT nspname FROM
> > pg_namespace n WHERE n.nspname='public' Fri Apr 11
> > 16:00:12 2008 <1> ulogd_output_PGSQL.c:109 using schema
> > public Fri Apr 11 16:00:12 2008 <7>
> > ulogd_output_PGSQL.c:295 execute failed (ERROR: 
> > function insert_packet_full(unknown, unknown, integer,
> > unknown, integer, unknown, unknown, integer, unknown,
> > unknown, integer, integer, integer, integer, integer,
> > integer, integer, integ er, integer, integer, integer,
> > bigint, integer, unknown, unknown, unknown, unknown,
> > unknown, unknown, unknown, unknown, unknown, unk nown,
> > unknown, unknown, unknown, unknown, unknown, unknown,
> > unknown, unknown, unknown, unknown, unknown, unknown,
> > integer) does not exist at character 8
> > HINT:  No function matches the given name and argument
> > types. You might need to add explicit type casts. )
>
> This one is already spotted, we will try to work on this
> next week.
>
> > Fri Apr 11 16:00:14 2008 <7> ../../util/db.c:185 no
> > connection to database, attempting to reconnect after 2
> > seconds Fri Apr 11 16:00:14 2008 <5> ulogd.c:488 error
> > during propagate_results Fri Apr 11 16:00:17 2008 <1>
> > ulogd_output_PGSQL.c:99 SELECT nspname FROM
> > pg_namespace n WHERE n.nspname='public' Fri Apr 11
> > 16:00:17 2008 <1> ulogd_output_PGSQL.c:109 using schema
> > public Fri Apr 11 16:00:17 2008 <7>
> > ulogd_output_PGSQL.c:295 execute failed (ERROR: 
> > smallint out of range CONTEXT:  SQL function
> > "insert_icmp" statement 1 SQL statement "SELECT 
> > INSERT_ICMP( $1 , $2 , $3 , $4 , $5 , $6 , $7 )"
>
> This one is new, could you try the attached patch ? It
> should fix this last problem.
>
> BR,
