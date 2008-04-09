From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 1/4] Fix SQL field naming.
Date: Wed, 09 Apr 2008 15:46:32 +0200
Message-ID: <47FCC8B8.1010104@netfilter.org>
References: <1207004990315-git-send-email-eric@inl.fr>    <12070049902421-git-send-email-eric@inl.fr>    <47FCC46F.8030406@netfilter.org> <46021.62.160.220.138.1207748382.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39512 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751973AbYDINqo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:46:44 -0400
In-Reply-To: <46021.62.160.220.138.1207748382.squirrel@mail.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
> 
>> Eric Leblond wrote:
>>> diff --git a/doc/mysql-ulogd2.sql b/doc/mysql-ulogd2.sql
>>> index 304173b..6368dc7 100644
>>> --- a/doc/mysql-ulogd2.sql
>>> +++ b/doc/mysql-ulogd2.sql
>>> @@ -297,8 +297,8 @@ DROP VIEW IF EXISTS `conntrack`;
>>>  CREATE SQL SECURITY INVOKER VIEW `conntrack` AS
>>>  	SELECT _ct_id,
>>>  	       oob_family,
>>> -	       orig_ip_saddr AS orig_ip_saddr_raw,
>>> -	       orig_ip_daddr AS orig_ip_daddr_raw,
>>> +	       orig_ip_saddr AS orig_ip_saddr_bin,
>>> +	       orig_ip_daddr AS orig_ip_daddr_bin,
>>>  	       orig_ip_protocol,
>>>  	       orig_l4_sport,
>>>  	       orig_l4_dport,
>> What do we gain with this renaming?
> 
> This fix an inconsistency of field naming among the different tables and
> accross the stack NFCT IP2BIN MYSQL.In fact IP2BIN out .bin suffixed
> fields.

Makes sense. Applied. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
