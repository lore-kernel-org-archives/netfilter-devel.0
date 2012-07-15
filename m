From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: pgsql-ulogd2
Date: Sun, 15 Jul 2012 13:33:09 +0100
Message-ID: <5002B885.4090909@googlemail.com>
References: <50002CEF.508@googlemail.com>	 <1342194935.11019.12.camel@tiger.regit.org>	 <50016D84.5080207@googlemail.com> <1342300959.6098.8.camel@tiger.regit.org> <5002B688.4070907@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42758 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2GOMdT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jul 2012 08:33:19 -0400
Received: by wgbfm10 with SMTP id fm10so1720269wgb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jul 2012 05:33:18 -0700 (PDT)
In-Reply-To: <5002B688.4070907@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Yep, the pgsql plugin makes extensive use of pg_namespace, pg_class 
> and pg_attribute which are system tables. These contain definitions of 
> every single object registered on that database server and is a major 
> security risk (as I pointed out, if that ulogd connection to the 
> database server is hijacked, then the attacker could find out what is 
> on that database without any problems, which is not good).
>
> I had in mind exactly what you've suggested above - use a separate, 
> manually-registered table containing the table columns and their 
> mapping to ulogd2 parameters - much less risk and everything is 
> configurable, though the downside is that the two tables need to be 
> synchronised if the structure of the main ulogd table changes (columns 
> renamed or added).
One other thing which I forgot to ask: currently, the pgsql plugin uses 
an unencrypted connection to the database server. I haven't studied the 
underlying source code which handles pgsql-specific functions, but in 
principle it is possible to use encrypted (SSL) connections to the 
server by using client/server certificates. Has this been attempted and 
considered to be included as an option to that particular plugin?

If not, would there be any objections if such feature is implemented 
(obviously, there will be a need to add additional parameters to that 
plugin to configure the type of connection, client/server/ca 
certificates etc)?
