From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/9] netfilter: xt_recent: allow changing ip_list_[ug]id
 at runtime
Date: Tue, 23 Mar 2010 16:10:15 +0100
Message-ID: <4BA8D9D7.1080800@trash.net>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de> <1269285486-22653-6-git-send-email-jengelh@medozas.de> <4BA8CDB9.1010304@trash.net> <alpine.LSU.2.01.1003231521460.21129@obet.zrqbmnf.qr> <4BA8D65B.5060700@trash.net> <alpine.LSU.2.01.1003231601250.21464@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59865 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab0CWPKQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:10:16 -0400
In-Reply-To: <alpine.LSU.2.01.1003231601250.21464@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2010-03-23 15:55, Patrick McHardy wrote:
>
>   
>>>>> -MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/xt_recent/* files");
>>>>> -MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/xt_recent/* files");
>>>>> +MODULE_PARM_DESC(ip_list_uid, "default owner of /proc/net/xt_recent/* files");
>>>>> +MODULE_PARM_DESC(ip_list_gid, "default owning group of /proc/net/xt_recent/* files");
>>>>>       
>>>>>           
>>>> So what will be updating the permissions of the existing proc files?
>>>>         
>>> The administrator with the use of chmod/chown/chgrp.
>>>       
>> I'm not sure whether this will have the desired effect. I vaguely
>> recall that proc used to forget about permission changes. That might
>> have been fixed, but I was unable to find something in the
>> changelogs.
>>     
>
> I believe that the procfs alzheimer only applies to
> entries that are dynamically created during dentry lookup,
> e.g. all the things in /proc/1234. You will note that
> the inode numbers of these entries changes over time.
>
> This is not the case however for anything created with
> proc_create_data AFAICT.
>
> 16:04 linux:~ # ls -il /proc/1/stat
> 13294 -r--r--r-- 1 root root 0 Mar 23 16:04 /proc/1/stat
> 16:04 linux:~ # ls -il /proc/net/xt_recent/foo
> 4026532102 -rw-r--r-- 1 bin root 0 Mar 23 16:04
> /proc/net/xt_recent/foo
>
> # Drive out cached stuff
> 16:04 linux:~ # find / -xdev -type f -print0 | xargs -0 cat >/dev/null
> 16:04 linux:~ # echo 3 >/proc/sys/vm/drop_caches
>
> 16:04 linux:~ # ls -il /proc/1/stat
> 13399 -r--r--r-- 1 root root 0 Mar 23 16:04 /proc/1/stat
> 16:04 linux:~ # ls -il /proc/net/xt_recent/foo
> 4026532102 -rw-r--r-- 1 bin root 0 Mar 23 16:04 /proc/net/xt_recent/foo
>
> As you can see, /proc/X was reinstantiated, while xt_recent's data
> remained.
>   

Sounds good. In any case its not directly related to your patch, so this
seems fine.

