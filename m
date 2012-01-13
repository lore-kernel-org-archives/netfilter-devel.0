From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ulogd2 suggest
Date: Fri, 13 Jan 2012 22:43:33 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201132211040.24827@blackhole.kfki.hu>
References: <4F0F6757.8090700@gmail.com> <20120113142833.GA21240@1984> <4F105E2B.4050400@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: marty <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:60296 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab2AMVnf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:43:35 -0500
In-Reply-To: <4F105E2B.4050400@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Marty,

On Fri, 13 Jan 2012, marty wrote:

> 1. when ulogd logs to mysql, and a failure occurs, the last
> auto_increment value may still contain a previous, used value.
> So mysql will hang terminally. Transactions should prevent this.

You wrote about it earlier, but I still don't understand. As far as I see, 
ulogd2 doesn't use any auto_increment value and doesn't expect such a 
parameter to be returned when inserting entries to the database. So 
where's this auto_increment value which may store a previous value after a 
failure?
 
> 2. transactions cannot be used in a mysql function, only a procedure.
> 
> 3. When you call a stored procedure from a function, that puts the sproc into
> the same execution environment as the function, with the same restrictions,
> e.g. transactions don't work.
> 
> 4. mysql provides a warning but ulogd2 ignores it.
> mysql is not logging those warnings but they can be seen on command line
> 
> 5. You cannot execute a procedure with a select statement.
>    Mysql will look for a function, not a procedure.
> 
> 6. Ulogd is hardwired to use SELECT statements for ALL DBMS in db.c.
> So this breaks things and therfor I consider it wrong..

As we discussed, this is (partly) a documentation issue. In PostgresSQL 
there's no real difference between a stored procedure and a stored 
function. In mySQL the two things are quite different, as you described 
above. The current doc is unfortunately quite misleading because it talks 
about stored procedures but internally invokes SELECT, in which case only 
stored functions are allowed in mySQL.

It could be solved by querying first the database whether the named object 
is a stored procedure or a function and issuing the proper SQL command 
(which is, again, pgsql/mysql dependent).

> 7. All key values, except "addresses" are in host byte order.
> This inconsistency is problematic on little endian systems because
> it breaks the native math processes for all client applications.
> 
> eg: You cannot do a SQL geo_ip lookup with wrong_endian numbers.
> Converting a numeric address to host order is not practical in SQL.

Your patch modified the current behaviour: the proper way is to add 
supporting new table fields which the filled out with the host ordered 
data.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
