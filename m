From: Anton <anton.vazir@gmail.com>
Subject: ULOGD2 PostgresSql errors
Date: Fri, 11 Apr 2008 16:05:39 +0500
Message-ID: <200804111605.39957.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:57408 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382AbYDKLFk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Apr 2008 07:05:40 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

There is some misbehaviour of ULOGD2. I managed to log connection data to the DB - but while it's logging something - at the same time I see this 
output in the ulogd.log - Looks abnormal.

The following I use to get logging. 

RANGE="--nflog-range 100"
THRESHOLD="--nflog-threshold 10"

iptables -F INPUT
iptables -F OUTPUT

iptables -A INPUT -j NFLOG -s 82.198.21.17/32 --nflog-group 0 --nflog-prefix ANTON_IN $RANGE $THRESHOLD
iptables -A OUTPUT -j NFLOG -d 82.198.21.17/32 --nflog-group 0 --nflog-prefix ANTON_OUT $RANGE $THRESHOLD

Database is PGSQL 8.3

Kernel 2.6.24.4 with NFLOG

NFLOG libraries are the latest from the netfilter.org

ULOGD - Latest SVN (7450)

Iptables 1.4.0

Please let me know if you need any additional info.

ulogd.log output is below:

Fri Apr 11 16:00:10 2008 <7> ../../util/db.c:185 no connection to database, attempting to reconnect after 2 seconds
Fri Apr 11 16:00:10 2008 <5> ulogd.c:488 error during propagate_results
Fri Apr 11 16:00:12 2008 <1> ulogd_output_PGSQL.c:99 SELECT nspname FROM pg_namespace n WHERE n.nspname='public'
Fri Apr 11 16:00:12 2008 <1> ulogd_output_PGSQL.c:109 using schema public
Fri Apr 11 16:00:12 2008 <7> ulogd_output_PGSQL.c:295 execute failed (ERROR:  function insert_packet_full(unknown, unknown, integer,
 unknown, integer, unknown, unknown, integer, unknown, unknown, integer, integer, integer, integer, integer, integer, integer, integ
er, integer, integer, integer, bigint, integer, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unk
nown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, integer) does not
exist at character 8
HINT:  No function matches the given name and argument types. You might need to add explicit type casts.
)
Fri Apr 11 16:00:12 2008 <7> ../../util/db.c:185 no connection to database, attempting to reconnect after 2 seconds
Fri Apr 11 16:00:12 2008 <5> ulogd.c:488 error during propagate_results
Fri Apr 11 16:00:14 2008 <1> ulogd_output_PGSQL.c:99 SELECT nspname FROM pg_namespace n WHERE n.nspname='public'
Fri Apr 11 16:00:14 2008 <1> ulogd_output_PGSQL.c:109 using schema public
Fri Apr 11 16:00:14 2008 <7> ulogd_output_PGSQL.c:295 execute failed (ERROR:  function insert_packet_full(unknown, unknown, integer,
 unknown, integer, unknown, unknown, integer, unknown, unknown, integer, integer, integer, integer, integer, integer, integer, integ
er, integer, integer, integer, bigint, integer, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unk
nown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, unknown, integer) does not
exist at character 8
HINT:  No function matches the given name and argument types. You might need to add explicit type casts.
)
Fri Apr 11 16:00:14 2008 <7> ../../util/db.c:185 no connection to database, attempting to reconnect after 2 seconds
Fri Apr 11 16:00:14 2008 <5> ulogd.c:488 error during propagate_results
Fri Apr 11 16:00:17 2008 <1> ulogd_output_PGSQL.c:99 SELECT nspname FROM pg_namespace n WHERE n.nspname='public'
Fri Apr 11 16:00:17 2008 <1> ulogd_output_PGSQL.c:109 using schema public
Fri Apr 11 16:00:17 2008 <7> ulogd_output_PGSQL.c:295 execute failed (ERROR:  smallint out of range
CONTEXT:  SQL function "insert_icmp" statement 1
SQL statement "SELECT  INSERT_ICMP( $1 , $2 , $3 , $4 , $5 , $6 , $7 )"
PL/pgSQL function "insert_packet_full" line 10 at PERFORM
)
Fri Apr 11 16:00:17 2008 <7> ../../util/db.c:185 no connection to database, attempting to reconnect after 2 seconds
Fri Apr 11 16:00:17 2008 <5> ulogd.c:488 error during propagate_results
