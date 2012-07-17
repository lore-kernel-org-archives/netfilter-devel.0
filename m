From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: pgsql-ulogd2
Date: Wed, 18 Jul 2012 00:29:47 +0100
Message-ID: <5005F56B.6000109@googlemail.com>
References: <50002CEF.508@googlemail.com>			 <1342194935.11019.12.camel@tiger.regit.org>			 <50016D84.5080207@googlemail.com>		 <1342300959.6098.8.camel@tiger.regit.org>	 <5002B688.4070907@googlemail.com> <1342385528.8476.2.camel@tiger.regit.org>	 <500345F1.3050407@googlemail.com> <1342420387.8476.20.camel@tiger.regit.org> <50040C8B.6010302@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40855 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab2GQX3w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Jul 2012 19:29:52 -0400
Received: by wibhr14 with SMTP id hr14so845604wib.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jul 2012 16:29:51 -0700 (PDT)
In-Reply-To: <50040C8B.6010302@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I managed to get some preliminary code working yesterday and later=20
> today when I get home I'll get the chance to test it with the real=20
> plug in to see whether SSL works. If it does, I'll propose some=20
> changes to include SSL capability to the PGSQL plugin.
OK, I've just done some testing using the PGSQL plugin with hard-coded=20
values to create a secure (SSL) connection and verify how that plugin=20
works. In short - it is absolutely flawless!

I am able to establish 4 types of SSL connections between ulogd and my=20
PostgreSQL database server and conducted tests on various (known)=20
attacks to see how it behaves - it passes with flying colours!

In the mean time, I found a bug and a "maybe" bug:

1. pgsql-ulogd2 script:

CREATE TABLE ulog2 (
  [...]
timestamp timestamp NOT NULL default 'now'

The above will insert a string, equivalent to the current timestamp whe=
n=20
the table was created as a default value (which PostgreSQL will=20
automatically convert to timestamp) and *not* when a record is inserted=
=20
into the table. The correct syntax is:

"timestamp" timestamp NOT NULL default now()


2. When I start using NFCT and it does the logging to the database, I a=
m=20
getting endless sequences of the following statement in the main=20
ulogd.log file:

<5> ulogd_inpflow_NFCT.c:697 unsupported message type

I don't know whether there is something I am doing wrong or whether=20
there is a message which ulogd cannot interpret. Maybe a bug, maybe not=
,=20
I don't know.

So, for SSL implementation in the PGSQL plugin, this is how I see it:=20
PostgreSQL (the server) allows for 6 different types of SSL connections=
=20
to be established between it and a client [1]:

Option          Description
~~~~~~        ~~~~~~~~~~~
disable          only try a non-SSL connection
allow          first try a non-SSL connection; if that fails, try an SS=
L=20
connection
prefer        (default) first try an SSL connection; if that fails, try=
=20
a non-SSL connection
require          only try an SSL connection
verify-ca     only try an SSL connection, and verify that the server=20
certificate is issued by a trusted CA
verify-full   only try an SSL connection, verify that the server=20
certificate is issued by a trusted CA and that the server host name=20
matches that in the certificate

The above option is configured with the "sslmode" connection option=20
("sslmode=3Dverfify-full" for example). In earlier PostgreSQL versions=20
(below 8, I think), there was only one possible option and that was=20
"requiressl" ("requiressl=3D1" is equivalent to "sslmode=3Drequire" abo=
ve,=20
while "requiressl=3D0" is the equivalent to "sslmode=3Dprefer").

As far as verification goes, there is one additional parameter which=20
could also be deployed on the PostgreSQL server to check request and=20
check the client certificate as well. So verification and checking coul=
d=20
be a dual process on both the client and the server.

In addition to the above parameter, 4 other connection options can be=20
specified:

sslcert - This parameter specifies the file name of the client SSL=20
certificate, replacing the default =E2=80=98~/.postgresql/postgresql.cr=
t=E2=80=99. This=20
parameter is ignored if an SSL connection is not made.

sslkey - This parameter specifies the location for the secret key used=20
for the client certificate. It can either specify a file name that will=
=20
be used instead of the default =E2=80=98~/.postgresql/postgresql.key=E2=
=80=99, or it can=20
specify a key obtained from an external =E2=80=9Cengine=E2=80=9D (engin=
es are OpenSSL=20
loadable modules). An external engine specification should consist of a=
=20
colon-separated engine name and an engine-specific key identifier. This=
=20
parameter is ignored if an SSL connection is not made. If this key is=20
protected with a password, this will be asked when the connection is=20
made. On the server side, it is stored internally and asked once when=20
the server starts up. on the client side it is asked every time an=20
attempt for a connection is made.

sslrootcert - This parameter specifies the name of a file containing SS=
L=20
certificate authority (CA) certificate(s). If the file exists, the=20
server's certificate will be verified to be signed by one of these=20
authorities. The default is =E2=80=98~/.postgresql/root.crt=E2=80=99.

sslcrl - This parameter specifies the file name of the SSL certificate=20
revocation list (CRL). Certificates listed in this file, if it exists,=20
will be rejected while attempting to authenticate the server's=20
certificate. The default is =E2=80=98~/.postgresql/root.crl=E2=80=99.

So, the way I see it, we can mirror all of the above 5 options,=20
including their default values quite easily and let PGconn do the rest=20
(please note that the PG .so object library takes care of opening the=20
certificate files as well as checking and validating the various=20
certificates contained within - this is done transparently to the clien=
t=20
- PGSQL plugin in this case). The modifications to the PGSQL plugin=20
would be minimal and will consists of little more than adding the above=
=20
parameters and then passing their values as connection options to PGcon=
n.

As far as hardening the access to the system tables goes, the way I see=
=20
it there are 2 possible options:

1. Change the meaning of the "table" plugin parameter to point to a=20
user-defined table, which contains a single row where all column names=20
of the main ulogd table are stored. This option *will* brake backward=20
compatibility!

2. Keep the existing "table" option and add a separate parameter=20
(probably called "columns" or "table_columns" or something like that),=20
which will contain a single row with the description of all usable=20
columns in the "table" table where the main ulogd logging will take pla=
ce.

I think option 2 is better, though at the expense of adding an extra=20
configuration parameter, in addition to the 5 new ones for SSL support =
I=20
listed above.

A few other observations and a query: Currently, there isn't a=20
"user-friendly" NCFT view implemented in the PGSQL plugin, similar to=20
the one designed for NFLOG (the one implemented for NFLOG is called=20
ulog, I think) where the various numeric and raw values are "deciphered=
"=20
for the end user and presented in a nice format to be understood more=20
easily.

All NFCT logs are currently dumped, quite literally, in the ulogd2_ct=20
table. Such a view would be very easy to create - I could do it and=20
submit it together with the above changes if there is interest.

One last question - is there a way where I could get *all* possible=20
values which a given filter plugin interprets, like source/destination=20
IP address/subnet, interface names etc?

The reason I am asking this is because if I could use or implement a=20
command line parameter (similar to "ulogd -i"), which asks every filter=
=20
plugin to list the names of the parameters it processes from the input=20
plugin, then I could build a reliable set of parameters which are then=20
used to build a complete database script to be used in the creating the=
=20
database schema which is then used by ulogd2.

Currently, I am only guessing what each plugin processes - it is like a=
=20
black box, which isn't good-enough for me.


[1] - PostgreSQL v9.0 Programmer's Manual -=20
http://www.network-theory.co.uk/docs/postgresql9/vol2/DatabaseConnectio=
nControlFunctions.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
