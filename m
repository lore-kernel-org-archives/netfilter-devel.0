From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Chain name length inconsistent
Date: Mon, 22 Mar 2010 19:18:07 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003221912140.4603@obet.zrqbmnf.qr>
References: <4B9FA541.7080408@redhat.com> <alpine.LSU.2.01.1003161647570.10927@obet.zrqbmnf.qr> <4B9FB198.3000408@redhat.com> <alpine.LSU.2.01.1003161742280.25891@obet.zrqbmnf.qr> <4BA2511C.8010800@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Thomas Woerner <twoerner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58647 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681Ab0CVSSI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:18:08 -0400
In-Reply-To: <4BA2511C.8010800@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-03-18 17:13, Thomas Woerner wrote:

> 1) You could create a chain with length 30:
>
> diff --git a/ip6tables.c b/ip6tables.c
> index 6ee4281..80af032 100644
> --- a/ip6tables.c
> +++ b/ip6tables.c
> @@ -1840,7 +1840,7 @@ int do_command6(int argc, char *argv[], char **table,
> stru
>
>        generic_opt_check(command, options);
>
> -       if (chain && strlen(chain) > IP6T_FUNCTION_MAXNAMELEN)
> +       if (chain && strlen(chain) > IP6T_FUNCTION_MAXNAMELEN - 1)
>                xtables_error(PARAMETER_PROBLEM,
>                           "chain name `%s' too long (must be under %i chars)",
>                           chain, IP6T_FUNCTION_MAXNAMELEN);

I'll take care of it.


>>> 1) Newer glibc versions are checking for overflows in targets of string
>>> functions. Therefore you should use memcpy instead of strcpy. The
>>> target is 29 chars while the source is up to 30 chars.
>>
>> So if it checks for *string* functions (I think it only does that when
>> -D_FORTIFY_SOURCE is set), why should I use a *memory* function over
>> the string function that's already in?
>>
> 2) _FORTIFY_SOURCE is enabled on all newer Fedora and Red Hat distributions,
> therefore this could lead into an abort

You have to think outside of your preferred distro sometimes. :)

> strcpy will copy the string (29 chars max) and the '\0' which makes up to 30
> into a field of length 29. Therefore this is an overflow. Either you have to
> reduce the max length to 28 or you have to use another function to copy the
> string (memcpy or strncpy with max length 29). BTW: Is it needed that
> xt_entry_match.u.name is null terminated?

Yes, the kernel's x_tables.c will use plain strcmp when looking
for ".name" in struct xt_{match,target}.
