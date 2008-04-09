From: "Eric Leblond" <eric@inl.fr>
Subject: Re: [ULOGD PATCH 1/4] Fix SQL field naming.
Date: Wed, 9 Apr 2008 15:39:42 +0200 (CEST)
Message-ID: <46021.62.160.220.138.1207748382.squirrel@mail.inl.fr>
References: <1207004990315-git-send-email-eric@inl.fr>
    <12070049902421-git-send-email-eric@inl.fr>
    <47FCC46F.8030406@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Eric Leblond" <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:43679 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733AbYDINjq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:39:46 -0400
In-Reply-To: <47FCC46F.8030406@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

> Eric Leblond wrote:
>> diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
>> index 304173b..6368dc7 100644
>> --- a/doc/mysql-ulogd2.sql
>> +++ b/doc/mysql-ulogd2.sql
>> @@ -297,8 +297,8 @@ DROP VIEW IF EXISTS `conntrack`;
>>  CREATE SQL SECURITY INVOKER VIEW `conntrack` AS
>>  	SELECT _ct_id,
>>  	       oob_family,
>> -	       orig_ip_saddr AS orig_ip_saddr_raw,
>> -	       orig_ip_daddr AS orig_ip_daddr_raw,
>> +	       orig_ip_saddr AS orig_ip_saddr_bin,
>> +	       orig_ip_daddr AS orig_ip_daddr_bin,
>>  	       orig_ip_protocol,
>>  	       orig_l4_sport,
>>  	       orig_l4_dport,
>
> What do we gain with this renaming?

This fix an inconsistency of field naming among the different tables and
accross the stack NFCT IP2BIN MYSQL.In fact IP2BIN out .bin suffixed
fields.

BR,
--
Eric Leblond
INL : http://www.inl.fr
NuFW, Now User Filtering Works (http://www.nufw.org)

