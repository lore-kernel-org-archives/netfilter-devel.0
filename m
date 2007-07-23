From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] ulogd 1.24 mysql bad identification
Date: Mon, 23 Jul 2007 10:01:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707230952530.32367@fbirervta.pbzchgretzou.qr>
References: <46A3EB93.6080701@free.fr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: "eescar@free.fr" <eescar@free.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46A3EB93.6080701@free.fr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Jul 23 2007 01:43, eescar@free.fr wrote:

>checking for MySQL files... found mysql_config in /usr/bin
>checking for mysql_real_escape_string support... strings: invalid option -- L
>Usage: strings [option(s)] [file(s)]
> Display printable strings in [file(s)] (stdin by default)
>
>So, as it may help some folks around, I send it on this mailling-list ...

No, the configure script is fundamentally broken.

        MYSQLLIBS=`$d/mysql_config --libs`

...

        MYSQL_FUNCTION_TEST=`strings ${MYSQLLIBS}/libmysqlclient.so |
	grep mysql_real_escape_string

Which is really wrong, because `mysql_config --libs` returns
*linker flags*, not a directory. A better fix is to replace it
with

AC_SEARCH_LIBS(mysql_real_escape_string, mysqlclient_r mysqlclient,
	[
		AC_MSG_NOTICE([found old MySQL])
		EXTRA_MYSQL_DEF="-DOLD_MYSQL=1"
	],
	[
		AC_MSG_NOTICE([found new MySQL])
	])

(untested)



	Jan
-- 
