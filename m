From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH] pgsql: add SSL connection implementation to PGSQL plugin
Date: Sun, 02 Sep 2012 17:24:50 +0100
Message-ID: <50438852.2070305@googlemail.com>
References: <1346503911-3781-1-git-send-email-mr.dash.four@googlemail.com> <1346600994.5194.27.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:39624 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab2IBQYy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Sep 2012 12:24:54 -0400
Received: by wgbdr13 with SMTP id dr13so3961025wgb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Sep 2012 09:24:52 -0700 (PDT)
In-Reply-To: <1346600994.5194.27.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,


>> 	    It is asked every time an attempt for a connection is made.
> 
> Entering key for each new connection, you've find a new business for low
> profile admin ;)
Hehe, that's why I use SSL engines instead - at least the password there is cached by the engine once entered (I have USB token which I use).

>> 'sslroot' - This parameter specifies the name of a file containing SSL
>> 	    certificate authority (CA) certificate(s). If the file exists,
>> 	    the server's certificate will be verified to be signed by one of
>> 	    these authorities.
>>  'sslcrl' - This parameter specifies the file name of the SSL certificate
>> 	    revocation list (CRL). Certificates listed in this file, if it
>> 	    exists, will be rejected while attempting to authenticate the
>> 	    server's certificate.
> 
> I don't see here the 'sslca' parameter: how ulogd does to verify
> database certificate if it does not know which CA certs to use ?
It is verified in two ways - via "verify-ca" and "verify-full". 

The sslroot contains the CA certificate chain. When ulogd attempts to connect, the server presents its certificate which is then verified whether it is signed by the CA present in sslroot. The whole CA chain is also then verified in that step. If verification fails, ulogd disconnects with an error. If not, and "sslmode=verify-ca" is specified, then the process stops there. If "sslmode=verify-full", then the process continues and host/IP address verification also takes place, which is then matched against the subject value (or alt subject if that value is present in the certificate).

>> @@ -70,8 +70,32 @@ static struct config_keyset pgsql_kset = {
>>  			.key = "schema", 
>>  			.type = CONFIG_TYPE_STRING,
>>  			.options = CONFIG_OPT_NONE,
>> -			.u.string = "public",
> 
> I don't see why this default value has been removed. Is this linked with
> current feature ?
No, it relates to two things - the NULL pointer reference bug I found out, as well as the fact that the "public" schema is assumed by default as far as PostgreSQL server is concerned. In other words, if I specify a blank (""), that would be the equivalent to "public". In other words, "SELECT * FROM public.some_table" is the equivalent of "SELECT * FROM some_table" - there is no difference.

> 
>>  		},
>> +		{  // sslmode=disable|allow|prefer|require|requiressl|verify-ca|verify-full
>> +			.key = "sslmode", 
>> +			.type = CONFIG_TYPE_STRING,
>> +			.options = CONFIG_OPT_NONE,
>> +		},
> 
> No default value here. From code below, I understand that we will not
> pass any SSL-related parameter in PGSQL connection chain if there is no
> value.
The "default" as far as PostgreSQL server is concerned (in other words if no sslmode is specified, i.e. "sslmode=" or nothing) is "prefer" - i.e. to attempt SSL connection first (with rudimentary SSL checks) and if that fails, downgrade the connection to non-SSL. See the description for "prefer" in my patch.

So, if nothing is specified here for sslmode (i.e. "" or "sslmode="), then PostgreSQL server assumes a "prefer" mode. "", "sslmode=" and "sslmode=prefer" are therefore equivalents.

> What is the difference with using "disable" as default ?
"disable" explicitly asks for NO SSL connection to be attempted regardless and is not the default for PostgreSQL server - it has to be specified explicitly.

>>  	/* 80 is more than what we need for the fixed parts below */
>>  	len = 80 + strlen(user) + strlen(db);
>>  
>> -	/* hostname and  and password are the only optionals */
>> +	/* hostname and password are not the only optional parameters */
>>  	if (server)
>>  		len += strlen(server);
>>  	if (pass)
>>  		len += strlen(pass);
>>  	if (port)
>>  		len += 20;
>> +	if (sslmode)
>> +		len += strlen(sslmode);
>> +	if (sslcert)
>> +		len += strlen(sslcert);
>> +	if (sslkey)
>> +		len += strlen(sslkey);
>> +	if (sslroot)
>> +		len += strlen(sslroot);
>> +	if (sslcrl)
>> +		len += strlen(sslcrl);
> 
> OK, we need to increase the length of the connection string and thus
> this code is needed.
> But, I don't see the length for the prefix use in the connection string.
> For example we have below:
> 	strcat(connstr, " sslmode=");
> 	strcat(connstr, sslmode);
> Am I missing something ?
The length of the connection string is initially allocated to be 80 characters, excluding the user name and the database name (there is further increase of 20 characters if "port" is specified). That is more than enough to hold "sslmode=XXX" which is, at most, 20 characters (" sslmode=verify-full"). So, for this value no additional increase is required as the existing string length is more than enough to hold it.

For the other parameters though, as these (potentially) specify file paths, increase is required.

