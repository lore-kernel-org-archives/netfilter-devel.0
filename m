From: Thomas Woerner <twoerner@redhat.com>
Subject: Re: Chain name length inconsistent
Date: Tue, 16 Mar 2010 17:28:08 +0100
Message-ID: <4B9FB198.3000408@redhat.com>
References: <4B9FA541.7080408@redhat.com> <alpine.LSU.2.01.1003161647570.10927@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab0CPQ2O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Mar 2010 12:28:14 -0400
In-Reply-To: <alpine.LSU.2.01.1003161647570.10927@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

1) Newer glibc versions are checking for overflows in targets of string functions. Therefore 
you should use memcpy instead of strcpy. The target is 29 chars while the source is up to 30 
chars.

2) If the name is 30 chars +1 for '\0' and +1 for revision to make 32, why is 
xt_entry_match.user.name 29 chars in size then? revision will contain the last byte then if 
the memory alignment is 1 byte, right? For 4 byte alignments this will be not the case. See 
ia64 and others.

On 03/16/2010 04:51 PM, Jan Engelhardt wrote:
>
> On Tuesday 2010-03-16 16:35, Thomas Woerner wrote:
>>
>> the size of a chain name is not consistent:
>>
>> 1) Adding a new chain name is checking for max length 30:
>
> This is correct. Given a long enough name, you already get:
>
> iptables-restore v1.4.7: error creating chain
> 'xxxabcdefghijklmnopqrstuvwxyz123':Invalid argument
>
>
>> iptables.c:464 (parse_target):
>>         if (strlen(targetname)+1>  sizeof(ipt_chainlabel))
>
> Well, this isn't  :3
>
>> Therefore all the checks should be for max length 29, right?
>
> Nope; 30 chars for the name, +1 for '\0' and +1 for revision to make 32.
>
>
> I thus have this patch in
>
> 	git://dev.medozas.de/iptables master
>
> which now fends off illegal target names
>
> iptables-restore v1.4.7: Invalid target name `xxxabcdefghijklmnopqrstuvwxyz123'
> (31 chars max)
>
>
> parent 89b6c32f88be47e83c3f6e7f8fee812088cb8c22 (v1.4.7-3-g89b6c32)
> commit 565a1b6371b856df15970dbc4fcdabcb935e50ce
> Author: Jan Engelhardt<jengelh@medozas.de>
> Date:   Tue Mar 16 16:49:21 2010 +0100
>
> iptables: correctly check for too-long target name
>
> "-j foooo" was not being checked for the proper length (did 32
> instead of 30.)
>
> References: http://bugzilla.netfilter.org/show_bug.cgi?id=641
> Signed-off-by: Jan Engelhardt<jengelh@medozas.de>
> ---
>   ip6tables.c |    2 +-
>   iptables.c  |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ip6tables.c b/ip6tables.c
> index e2359df..4200cf3 100644
> --- a/ip6tables.c
> +++ b/ip6tables.c
> @@ -456,7 +456,7 @@ parse_target(const char *targetname)
>   		xtables_error(PARAMETER_PROBLEM,
>   			   "Invalid target name (too short)");
>
> -	if (strlen(targetname)+1>  sizeof(ip6t_chainlabel))
> +	if (strlen(targetname)>  XT_FUNCTION_MAXNAMELEN)
>   		xtables_error(PARAMETER_PROBLEM,
>   			   "Invalid target name `%s' (%u chars max)",
>   			   targetname, (unsigned int)sizeof(ip6t_chainlabel)-1);
> diff --git a/iptables.c b/iptables.c
> index 08eb134..5fab7d2 100644
> --- a/iptables.c
> +++ b/iptables.c
> @@ -460,7 +460,7 @@ parse_target(const char *targetname)
>   		xtables_error(PARAMETER_PROBLEM,
>   			   "Invalid target name (too short)");
>
> -	if (strlen(targetname)+1>  sizeof(ipt_chainlabel))
> +	if (strlen(targetname)>  XT_FUNCTION_MAXNAMELEN)
>   		xtables_error(PARAMETER_PROBLEM,
>   			   "Invalid target name `%s' (%u chars max)",
>   			   targetname, (unsigned int)sizeof(ipt_chainlabel)-1);


-- 
Thomas Woerner
Software Engineer            Phone: +49-711-96437-310
Red Hat GmbH                 Fax  : +49-711-96437-111
Hauptstaetterstr. 58         Email: Thomas Woerner <twoerner@redhat.com>
D-70178 Stuttgart            Web  : http://www.redhat.de/
