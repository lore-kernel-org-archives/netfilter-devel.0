From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 5/9] netfilter: xt_recent: allow changing ip_list_[ug]id
 at runtime
Date: Tue, 23 Mar 2010 15:23:38 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003231521460.21129@obet.zrqbmnf.qr>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de> <1269285486-22653-6-git-send-email-jengelh@medozas.de> <4BA8CDB9.1010304@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47043 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab0CWOXj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:23:39 -0400
In-Reply-To: <4BA8CDB9.1010304@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-03-23 15:18, Patrick McHardy wrote:
>>  module_param(ip_list_perms, uint, 0400);
>> -module_param(ip_list_uid, uint, 0400);
>> -module_param(ip_list_gid, uint, 0400);
>> +module_param(ip_list_uid, uint, S_IRUGO | S_IWUSR);
>> +module_param(ip_list_gid, uint, S_IRUGO | S_IWUSR);
>>  MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
>>  MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP address to remember (max. 255)");
>>  MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
>>  MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/xt_recent/* files");
>> -MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/xt_recent/* files");
>> -MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/xt_recent/* files");
>> +MODULE_PARM_DESC(ip_list_uid, "default owner of /proc/net/xt_recent/* files");
>> +MODULE_PARM_DESC(ip_list_gid, "default owning group of /proc/net/xt_recent/* files");
>
>So what will be updating the permissions of the existing proc files?

The administrator with the use of chmod/chown/chgrp.
