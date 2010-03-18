From: Thomas Woerner <twoerner@redhat.com>
Subject: Re: Chain name length inconsistent
Date: Thu, 18 Mar 2010 17:13:16 +0100
Message-ID: <4BA2511C.8010800@redhat.com>
References: <4B9FA541.7080408@redhat.com> <alpine.LSU.2.01.1003161647570.10927@obet.zrqbmnf.qr> <4B9FB198.3000408@redhat.com> <alpine.LSU.2.01.1003161742280.25891@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab0CRRCG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:02:06 -0400
In-Reply-To: <alpine.LSU.2.01.1003161742280.25891@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Jan,

there are still two problems:

1) You could create a chain with length 30:

diff --git a/ip6tables.c b/ip6tables.c
index 6ee4281..80af032 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1840,7 +1840,7 @@ int do_command6(int argc, char *argv[], char 
**table, stru

         generic_opt_check(command, options);

-       if (chain && strlen(chain) > IP6T_FUNCTION_MAXNAMELEN)
+       if (chain && strlen(chain) > IP6T_FUNCTION_MAXNAMELEN - 1)
                 xtables_error(PARAMETER_PROBLEM,
                            "chain name `%s' too long (must be under %i 
chars)",
                            chain, IP6T_FUNCTION_MAXNAMELEN);
diff --git a/iptables.c b/iptables.c
index 25bc8cc..2139b98 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1878,7 +1878,7 @@ int do_command(int argc, char *argv[], char 
**table, struc

         generic_opt_check(command, options);

-       if (chain && strlen(chain) > IPT_FUNCTION_MAXNAMELEN)
+       if (chain && strlen(chain) > IPT_FUNCTION_MAXNAMELEN - 1)
                 xtables_error(PARAMETER_PROBLEM,
                            "chain name `%s' too long (must be under %i 
chars)",
                            chain, IPT_FUNCTION_MAXNAMELEN);


On 03/16/2010 05:55 PM, Jan Engelhardt wrote:
> On Tuesday 2010-03-16 17:28, Thomas Woerner wrote:
>
>> 1) Newer glibc versions are checking for overflows in targets of string
>> functions. Therefore you should use memcpy instead of strcpy. The
>> target is 29 chars while the source is up to 30 chars.
>
> So if it checks for *string* functions (I think it only does that when
> -D_FORTIFY_SOURCE is set), why should I use a *memory* function over
> the string function that's already in?
>
2) _FORTIFY_SOURCE is enabled on all newer Fedora and Red Hat 
distributions, therefore this could lead into an abort

strcpy will copy the string (29 chars max) and the '\0' which makes up 
to 30 into a field of length 29. Therefore this is an overflow. Either 
you have to reduce the max length to 28 or you have to use another 
function to copy the string (memcpy or strncpy with max length 29). BTW: 
Is it needed that xt_entry_match.u.name is null terminated?

>> 2) If the name is 30 chars +1 for '\0' and +1 for revision to make 32,
>> why is xt_entry_match.user.name 29 chars in size then?
>
> Oh, for match_size/target_size. So it's 29 +1 +1 +2. I shall revise the
> patch immediately.
>
>> revision will contain the last byte then if the memory alignment is 1
>> byte, right? For 4 byte alignments this will be not the case. See ia64
>> and others.
>
> __u8 won't be aligned on a 4-byte boundary (ignoring the weird ARM
> ABI).
>
>
> parent 89b6c32f88be47e83c3f6e7f8fee812088cb8c22 (v1.4.7-3-g89b6c32)
> commit 21d1283750d9c4df7ca80165d2b9dc0b9bd214eb
> Author: Jan Engelhardt<jengelh@medozas.de>
> Date:   Tue Mar 16 16:49:21 2010 +0100
>
> iptables: correctly check for too-long chain/target/match names
>
> * iptables-restore was not checking for chain name length
> * iptables was not checking for match name length
> * target length was checked against 32, not 29.
>
> References: http://bugzilla.netfilter.org/show_bug.cgi?id=641
> Signed-off-by: Jan Engelhardt<jengelh@medozas.de>
> ---
>   ip6tables-restore.c |    6 ++++++
>   ip6tables.c         |    4 ++--
>   iptables-restore.c  |    6 ++++++
>   iptables.c          |    4 ++--
>   xtables.c           |    5 +++++
>   5 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/ip6tables-restore.c b/ip6tables-restore.c
> index d0efbee..f0725d1 100644
> --- a/ip6tables-restore.c
> +++ b/ip6tables-restore.c
> @@ -253,6 +253,12 @@ int main(int argc, char *argv[])
>   				exit(1);
>   			}
>
> +			if (strlen(chain)>  XT_FUNCTION_MAXNAMELEN - 1)
> +				xtables_error(PARAMETER_PROBLEM,
> +					   "Invalid chain name `%s' "
> +					   "(%u chars max)",
> +					   chain, XT_FUNCTION_MAXNAMELEN - 1);
> +
>   			if (ip6tc_builtin(chain, handle)<= 0) {
>   				if (noflush&&  ip6tc_is_chain(chain, handle)) {
>   					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
> diff --git a/ip6tables.c b/ip6tables.c
> index e2359df..6ee4281 100644
> --- a/ip6tables.c
> +++ b/ip6tables.c
> @@ -456,10 +456,10 @@ parse_target(const char *targetname)
>   		xtables_error(PARAMETER_PROBLEM,
>   			   "Invalid target name (too short)");
>
> -	if (strlen(targetname)+1>  sizeof(ip6t_chainlabel))
> +	if (strlen(targetname)>  XT_FUNCTION_MAXNAMELEN - 1)
>   		xtables_error(PARAMETER_PROBLEM,
>   			   "Invalid target name `%s' (%u chars max)",
> -			   targetname, (unsigned int)sizeof(ip6t_chainlabel)-1);
> +			   targetname, XT_FUNCTION_MAXNAMELEN - 1);
>
>   	for (ptr = targetname; *ptr; ptr++)
>   		if (isspace(*ptr))
> diff --git a/iptables-restore.c b/iptables-restore.c
> index 86d63e2..4a74485 100644
> --- a/iptables-restore.c
> +++ b/iptables-restore.c
> @@ -259,6 +259,12 @@ main(int argc, char *argv[])
>   				exit(1);
>   			}
>
> +			if (strlen(chain)>  XT_FUNCTION_MAXNAMELEN - 1)
> +				xtables_error(PARAMETER_PROBLEM,
> +					   "Invalid chain name `%s' "
> +					   "(%u chars max)",
> +					   chain, XT_FUNCTION_MAXNAMELEN - 1);
> +
>   			if (iptc_builtin(chain, handle)<= 0) {
>   				if (noflush&&  iptc_is_chain(chain, handle)) {
>   					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
> diff --git a/iptables.c b/iptables.c
> index 08eb134..25bc8cc 100644
> --- a/iptables.c
> +++ b/iptables.c
> @@ -460,10 +460,10 @@ parse_target(const char *targetname)
>   		xtables_error(PARAMETER_PROBLEM,
>   			   "Invalid target name (too short)");
>
> -	if (strlen(targetname)+1>  sizeof(ipt_chainlabel))
> +	if (strlen(targetname)>  XT_FUNCTION_MAXNAMELEN - 1)
>   		xtables_error(PARAMETER_PROBLEM,
>   			   "Invalid target name `%s' (%u chars max)",
> -			   targetname, (unsigned int)sizeof(ipt_chainlabel)-1);
> +			   targetname, XT_FUNCTION_MAXNAMELEN - 1);
>
>   	for (ptr = targetname; *ptr; ptr++)
>   		if (isspace(*ptr))
> diff --git a/xtables.c b/xtables.c
> index f3baf84..7340c87 100644
> --- a/xtables.c
> +++ b/xtables.c
> @@ -545,6 +545,11 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
>   	struct xtables_match *ptr;
>   	const char *icmp6 = "icmp6";
>
> +	if (strlen(name)>  XT_FUNCTION_MAXNAMELEN - 1)
> +		xtables_error(PARAMETER_PROBLEM,
> +			   "Invalid match name \"%s\" (%u chars max)",
> +			   name, XT_FUNCTION_MAXNAMELEN - 1);
> +
>   	/* This is ugly as hell. Nonetheless, there is no way of changing
>   	 * this without hurting backwards compatibility */
>   	if ( (strcmp(name,"icmpv6") == 0) ||

Thanks,
Thomas
