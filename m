From: Eric B Munson <emunson@akamai.com>
Subject: Re: [PATCH RESEND] Add element count to hash headers
Date: Mon, 09 Mar 2015 15:05:09 -0400
Message-ID: <54FDEEE5.4020101@akamai.com>
References: <1424289208-6164-1-git-send-email-emunson@akamai.com> <54F67D2E.5050003@akamai.com> <alpine.DEB.2.10.1503062148590.29108@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Josh Hunt <johunt@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:57282 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbbCITFL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Mar 2015 15:05:11 -0400
In-Reply-To: <alpine.DEB.2.10.1503062148590.29108@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/06/2015 04:45 PM, Jozsef Kadlecsik wrote:
> Hi Josh,
> 
> On Tue, 3 Mar 2015, Josh Hunt wrote:
> 
>> On 02/18/2015 01:53 PM, Eric B Munson wrote:
>>> It would be useful for userspace to query the size of an ipset
>>> hash, however, this data is not exposed to userspace outside of
>>> counting the number of member entries.  This patch uses the
>>> attribute IPSET_ATTR_ELEMENTS to indicate the size in the the
>>> header that is exported to userspace.  This field is then
>>> printed by the userspace tool for hashes.
>>> 
>>> Because it is only meaningful for hashes to report their size,
>>> the output is conditional on the set type.  To do this checking
>>> the MATCH_TYPENAME macro was moved to utils.h.
>>> 
>>> Signed-off-by: Eric B Munson <emunson@akamai.com> Cc: Jozsef
>>> Kadlecsik <kadlec@blackhole.kfki.hu> Cc: Pablo Neira Ayuso
>>> <pablo@netfilter.org> Cc: Josh Hunt <johunt@akamai.com> --- 
>>> include/libipset/utils.h                     |  3 +++ 
>>> kernel/net/netfilter/ipset/ip_set_hash_gen.h |  3 ++- 
>>> lib/errcode.c                                |  2 -- 
>>> lib/session.c                                | 14
>>> ++++++++++++-- 4 files changed, 17 insertions(+), 5
>>> deletions(-)
>>> 
>>> diff --git a/include/libipset/utils.h
>>> b/include/libipset/utils.h index 3cd29da..ceedd45 100644 ---
>>> a/include/libipset/utils.h +++ b/include/libipset/utils.h @@
>>> -19,6 +19,9 @@ #define STRCASEQ(a, b)		(strcasecmp(a, b) == 0) 
>>> #define STRNCASEQ(a, b, n)	(strncasecmp(a, b, n) == 0)
>>> 
>>> +/* Match set type names */ +#define MATCH_TYPENAME(a, b)
>>> STRNEQ(a, b, strlen(b)) + /* Stringify tokens */ #define
>>> _STR(c)			#c #define STR(c)			_STR(c) diff --git
>>> a/kernel/net/netfilter/ipset/ip_set_hash_gen.h 
>>> b/kernel/net/netfilter/ipset/ip_set_hash_gen.h index
>>> 885105b..2000a20 100644 ---
>>> a/kernel/net/netfilter/ipset/ip_set_hash_gen.h +++
>>> b/kernel/net/netfilter/ipset/ip_set_hash_gen.h @@ -1040,7
>>> +1040,8 @@ mtype_head(struct ip_set *set, struct sk_buff *skb) 
>>> goto nla_put_failure; #endif if (nla_put_net32(skb,
>>> IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) || -
>>> nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize))) +
>>> nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) || +
>>> nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(h->elements))) 
>>> goto nla_put_failure; if (unlikely(ip_set_put_flags(skb,
>>> set))) goto nla_put_failure; diff --git a/lib/errcode.c
>>> b/lib/errcode.c index 8eb275b..3881121 100644 ---
>>> a/lib/errcode.c +++ b/lib/errcode.c @@ -148,8 +148,6 @@ static
>>> const struct ipset_errcode_table list_errcode_table[] = { { }, 
>>> };
>>> 
>>> -#define MATCH_TYPENAME(a, b)	STRNEQ(a, b, strlen(b)) - /** *
>>> ipset_errcode - interpret a kernel error code * @session:
>>> session structure diff --git a/lib/session.c b/lib/session.c 
>>> index 013d9d8..07f3396 100644 --- a/lib/session.c +++
>>> b/lib/session.c @@ -931,6 +931,10 @@ list_create(struct
>>> ipset_session *session, struct nlattr *nla[]) 
>>> safe_dprintf(session, ipset_print_number, IPSET_OPT_MEMSIZE); 
>>> safe_snprintf(session, "\nReferences: "); safe_dprintf(session,
>>> ipset_print_number, IPSET_OPT_REFERENCES); +		if
>>> (MATCH_TYPENAME(type->name , "hash:")) { +
>>> safe_snprintf(session, "\nNum Entries: ");
> 
> It's just a minor thing, but please do not abbreviate.

Will fix for V2

> 
>>> +			safe_dprintf(session, ipset_print_number, 
>>> IPSET_OPT_ELEMENTS); +		} safe_snprintf(session, 
>>> session->envopts & IPSET_ENV_LIST_HEADER ? "\n" :
>>> "\nMembers:\n"); @@ -940,10 +944,16 @@ list_create(struct
>>> ipset_session *session, struct nlattr *nla[]) 
>>> safe_dprintf(session, ipset_print_number, IPSET_OPT_MEMSIZE); 
>>> safe_snprintf(session, "</memsize>\n<references>"); 
>>> safe_dprintf(session, ipset_print_number, 
>>> IPSET_OPT_REFERENCES); +		safe_snprintf(session,
>>> "</references>\n"); +		if (MATCH_TYPENAME(type->name ,
>>> "hash:")) { +			safe_snprintf(session, "<numentries>"); +
>>> safe_dprintf(session, ipset_print_number, IPSET_OPT_ELEMENTS); 
>>> +			safe_snprintf(session, "</numentries>\n"); +		} 
>>> safe_snprintf(session, session->envopts & IPSET_ENV_LIST_HEADER
>>> ? -			"</references>\n</header>\n" : -
>>> "</references>\n</header>\n<members>\n"); +			"</header>\n" : +
>>> "</header>\n<members>\n"); break; default: break;
>>> 
>> 
>> Can you clarify what you're looking for when you mentioned (in a
>>  previous mail) "I don't like any change which affects the
>> userspace but not expressed in new set type revision."? Are we
>> breaking ABI here by adding a new field to print out the # of
>> elements in a hash? Would it be better to default this to off and
>> only print it if a new flag were presented?

Thanks for taking a look at the patch.

> 
> Technically speaking there's nothing wrong with the patch. But I
> have a couple of small issues, actually all non-critical, still...
> 
> The new revision for the set types may be an exaggregation. My
> concern was to make easier to "solve" reports like "Number of
> elements not listed, why?". If the new feature is expressed in a
> revision number (both in the kernel module of the set types and the
> userspace parts), then it's simple to say "check and compare the
> output of 'modinfo modulename' and 'ipset help'". Otherwise it's
> hard to figure out which part is missing the new feature: kernel,
> userspace or both. But it may be too much fussing on my part :-)
> 
> The new line in the output "breaks" any script which parses the
> listing and not prepared that such change may occur (actually, the
> testsuite itself must be fixed therefore too). At the same time I
> don't really like the idea of a new flag to turn on the printing of
> the info - just print it.

I will make sure that V2 includes any necessary changes to the test suite.

> 
> The listing becomes non-uniform and type-dependent, because it's 
> restricted to the hash types. But therefore should we add the
> listing of the number of elements to the bitmap and list types too?
> For the hash types, the data comes free - for the other types is
> must be calculated at every listing.

This is the reason I only added it for the hash type.  I don't have
any objection to adding it to the bitmap and list types as well but I
didn't have a consumer for that information in mind to justify the
extra calculations at run time.  Plus, the libipset consumer could
count entries in output just as well as the library itself.

> 
> Also, the number of the elements may easily be wrong for sets with
>  timeout: the counter does not take into account the just timed out
> entries but the listing of the elements does. Even if we check the
> timed out entries for the counter, entries may time out by the time
> it's they turn to be listed. At least it should be documented in
> the manpage.

I will add a note in the manpage about this possible disconnect
between the reported number of entries and the actual number in the
result.

> 
>> I guess I don't see why we should rev all of the hash types for
>> this change when we're not really adding any functionality to
>> them. We can rev the ver of the library to signify a change here.
>> Would that help?
> 
> The revision counter is the best we have to express new features.
> It's not elegant at all.
> 
>> If we do need to add a new revision I think we may want to step
>> back and make sure there's no other information we want to expose
>> first and if there is do it all in one shot to minimize the # of
>> revisions.
> 
> What kind of additional information do you have in mind?
> 
> Best regards, Jozsef - E-mail  : kadlec@blackhole.kfki.hu,
> kadlecsik.jozsef@wigner.mta.hu PGP key :
> http://www.kfki.hu/~kadlec/pgp_public_key.txt Address : Wigner
> Research Centre for Physics, Hungarian Academy of Sciences H-1525
> Budapest 114, POB. 49, Hungary
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJU/e7jAAoJELbVsDOpoOa9IKIP/0+ULjC3VWtMJC75L5DODskZ
MeOIusxIE64I3o9GhALOqJk86OWfAPOL5IaSnYk7EM/z+1IGQUsicWz6VYSICTg/
so4xnpPFlmQo8A+iSPjXqVBuElVqvbA3nz2QHqiqZDoW1rNgvyV6Xmp2elI/XUuv
xvbUyAi21Ld0rhHvg9+APTiIDBPe0bfnH7GS9uoKPaoEPrmOysKLLX8bFvS0Xhr+
keN1VNbDsS8k57dD38BS1I5d4ZXGDPYTYLnctoUeDg2CfcEdHKYL0VtTzEgorbgv
VQYLKre4T59yWA4aPoGvjWCg0K9J18VduZp5FDxIt5o2sdtmJ37NQ9hjEyt+xuAS
30SoGc295jLLJwc7yePtSxSFymZB0t+uTTp7n0dYfjteClQg8/FLtqRvCiz3ISDa
dFYURfawg18UC+OuCmtdfbMu7RuebDF2R/w7xx40OBNNYntrdYz7bU+tjctDZLf/
J2+VdIuUsH4AsYZtLgYK3Bj1a6KeP4yEbzdieD8UuzJmosRdx0L8Lm8fpOmQG7Cs
2i/MHZQbjkVeHRL5oaBdhGyqhCBMHknrXttMKz7stHbV8uPbnsy/cVo0vT8EXS1a
uxLmSil0r9wvMXAxOkh4lfsM68wnWevsuJHKm+8hgoB5ROHmRBoaxQca0sN8i8IW
3i7ieVyOAySL81PHB6V/
=kxFv
-----END PGP SIGNATURE-----
