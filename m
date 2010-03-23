From: Thomas Woerner <twoerner@redhat.com>
Subject: Re: Chain name length inconsistent
Date: Tue, 23 Mar 2010 12:42:51 +0100
Message-ID: <4BA8A93B.1080400@redhat.com>
References: <4B9FA541.7080408@redhat.com> <alpine.LSU.2.01.1003161647570.10927@obet.zrqbmnf.qr> <4B9FB198.3000408@redhat.com> <alpine.LSU.2.01.1003161742280.25891@obet.zrqbmnf.qr> <4BA2511C.8010800@redhat.com> <alpine.LSU.2.01.1003221912140.4603@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab0CWLjz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:39:55 -0400
In-Reply-To: <alpine.LSU.2.01.1003221912140.4603@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/22/2010 07:18 PM, Jan Engelhardt wrote:
>
> On Thursday 2010-03-18 17:13, Thomas Woerner wrote:
>
>> 1) You could create a chain with length 30:
>>
>> diff --git a/ip6tables.c b/ip6tables.c
>> index 6ee4281..80af032 100644
>> --- a/ip6tables.c
>> +++ b/ip6tables.c
>> @@ -1840,7 +1840,7 @@ int do_command6(int argc, char *argv[], char **table,
>> stru
>>
>>         generic_opt_check(command, options);
>>
>> -       if (chain&&  strlen(chain)>  IP6T_FUNCTION_MAXNAMELEN)
>> +       if (chain&&  strlen(chain)>  IP6T_FUNCTION_MAXNAMELEN - 1)
>>                 xtables_error(PARAMETER_PROBLEM,
>>                            "chain name `%s' too long (must be under %i chars)",
>>                            chain, IP6T_FUNCTION_MAXNAMELEN);
>
> I'll take care of it.
>
>
>>>> 1) Newer glibc versions are checking for overflows in targets of string
>>>> functions. Therefore you should use memcpy instead of strcpy. The
>>>> target is 29 chars while the source is up to 30 chars.
>>>
>>> So if it checks for *string* functions (I think it only does that when
>>> -D_FORTIFY_SOURCE is set), why should I use a *memory* function over
>>> the string function that's already in?
>>>
>> 2) _FORTIFY_SOURCE is enabled on all newer Fedora and Red Hat distributions,
>> therefore this could lead into an abort
>
> You have to think outside of your preferred distro sometimes. :)


>
>> strcpy will copy the string (29 chars max) and the '\0' which makes up to 30
>> into a field of length 29. Therefore this is an overflow. Either you have to
>> reduce the max length to 28 or you have to use another function to copy the
>> string (memcpy or strncpy with max length 29). BTW: Is it needed that
>> xt_entry_match.u.name is null terminated?
>
> Yes, the kernel's x_tables.c will use plain strcmp when looking
> for ".name" in struct xt_{match,target}.

1) If your chain name is 29 chars in length, you are copying the chain 
name plus '\0' into xt_entry_match.u.name, but xt_entry_match.u.name is 
only 29 chars long. Is it intended that '\0' will be placed into 
revision in this case if there is no destination size check?

2) If there are these chains:

chain1: "123456789012345678901234567"
chain2: "1234567890123456789012345678"
chain3: "12345678901234567890123456789"

What will be the value of xt_entry_match.u.user.name after the call

iptables.c:1576:, ip6tables.c:1561: (do_command jump case)
	xtables_set_revision(target->t->u.user.name, target->revision);
and
iptables.c:1635: , ip6tables.c:1614: (do_command match case)
	xtables_set_revision(m->m->u.user.name, m->revision);

target->revision defaults to '\0', right?

   void xtables_set_revision(char *name, u_int8_t revision)
   {
         /* Old kernel sources don't have ".revision" field,
         *            but we stole a byte from name. */
         name[XT_FUNCTION_MAXNAMELEN - 2] = '\0';
         name[XT_FUNCTION_MAXNAMELEN - 1] = revision;
   }

I would say it will be the same for all these chains.

Therefore it would be good to check for max chain name length < 28.

Otherwise this could end up in using the wrong chain, right?


Thomas

-- 
Thomas Woerner
Software Engineer            Phone: +49-711-96437-310
Red Hat GmbH                 Fax  : +49-711-96437-111
Hauptstaetterstr. 58         Email: Thomas Woerner <twoerner@redhat.com>
D-70178 Stuttgart            Web  : http://www.redhat.de/
