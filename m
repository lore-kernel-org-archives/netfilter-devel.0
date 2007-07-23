From: "eescar@free.fr" <eescar@free.fr>
Subject: Re: [PATCH] ulogd 1.24 mysql bad identification
Date: Mon, 23 Jul 2007 13:12:31 +0200
Message-ID: <46A48D1F.4060601@free.fr>
References: <46A3EB93.6080701@free.fr>
	<Pine.LNX.4.64.0707230952530.32367@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707230952530.32367@fbirervta.pbzchgretzou.qr>
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

Hi,

Jan Engelhardt a =E9crit :
> On Jul 23 2007 01:43, eescar@free.fr wrote:
>
>  =20
>> checking for MySQL files... found mysql_config in /usr/bin
>> checking for mysql_real_escape_string support... strings: invalid opti=
on -- L
>> Usage: strings [option(s)] [file(s)]
>> Display printable strings in [file(s)] (stdin by default)
>>
>> So, as it may help some folks around, I send it on this mailling-list =
...
>>    =20
>
> No, the configure script is fundamentally broken.
>
>         MYSQLLIBS=3D`$d/mysql_config --libs`
>
> ...
>
>         MYSQL_FUNCTION_TEST=3D`strings ${MYSQLLIBS}/libmysqlclient.so |
> 	grep mysql_real_escape_string
>
> Which is really wrong, because `mysql_config --libs` returns
> *linker flags*, not a directory. A better fix is to replace it
> with
>
> AC_SEARCH_LIBS(mysql_real_escape_string, mysqlclient_r mysqlclient,
> 	[
> 		AC_MSG_NOTICE([found old MySQL])
> 		EXTRA_MYSQL_DEF=3D"-DOLD_MYSQL=3D1"
> 	],
> 	[
> 		AC_MSG_NOTICE([found new MySQL])
> 	])
>
> (untested)
>
>
>
> 	Jan
>  =20

tested it :

....
checking for strerror... (cached) yes
./configure: line 1762: syntax error near unexpected token
`mysql_real_escape_string,'
./configure: line 1762: `AC_SEARCH_LIBS(mysql_real_escape_string,
mysqlclient_r mysqlclient,'

So as I don't understand your things (don't know if AC_SEARCH_LIBS is a
predefined function somewhere...) as I am not any kind of developper,
only a poor little wanabe hacker, I continue my way as I understand that
by modifying the content of MYSQLLIBS, I may break some other things
(really stupid !), I now use MYSQLLIBSDIR to store the directory;

so maybe this is more correct :

--- ulogd-1.24/configure        2006-01-25 12:15:22.000000000 +0100
+++ ulogd-1.24.new/configure    2007-07-23 13:00:26.000000000 +0200
@@ -1729,6 +1729,7 @@

         MYSQLINCLUDES=3D`$d/mysql_config --include`
         MYSQLLIBS=3D`$d/mysql_config --libs`
+       MYSQLLIBSDIR=3D`$d/mysql_config --libs | awk '{ print $1 }' | cut
-c3-`

        DATABASE_DIR=3D"${DATABASE_DIR} mysql"

@@ -1747,7 +1748,7 @@
        echo $ac_n "checking for mysql_real_escape_string support""...
$ac_c" 1>&6
 echo "configure:1749: checking for mysql_real_escape_string support" >&5

-       MYSQL_FUNCTION_TEST=3D`strings ${MYSQLLIBS}/libmysqlclient.so |
grep mysql_real_escape_string`
+       MYSQL_FUNCTION_TEST=3D`strings ${MYSQLLIBSDIR}/libmysqlclient.so =
|
grep mysql_real_escape_string`

        if test "x$MYSQL_FUNCTION_TEST" =3D x
        then


Tested it on two hosts with different locations for libmysqlclient.so
and it give the good path in both case.

Best Regards,

MaNU
