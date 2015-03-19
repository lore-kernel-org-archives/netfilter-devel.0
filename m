From: Eric B Munson <emunson@akamai.com>
Subject: Re: [PATCH RESEND] Add element count to hash headers
Date: Thu, 19 Mar 2015 13:38:42 -0400
Message-ID: <550B09A2.9070505@akamai.com>
References: <1424289208-6164-1-git-send-email-emunson@akamai.com> <54F67D2E.5050003@akamai.com> <alpine.DEB.2.10.1503062148590.29108@blackhole.kfki.hu> <54FDEEE5.4020101@akamai.com> <alpine.DEB.2.10.1503112012020.12147@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Josh Hunt <johunt@akamai.com>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:61261 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751577AbbCSRin (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2015 13:38:43 -0400
In-Reply-To: <alpine.DEB.2.10.1503112012020.12147@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/11/2015 03:20 PM, Jozsef Kadlecsik wrote:
> On Mon, 9 Mar 2015, Eric B Munson wrote:
> 
>>> The new line in the output "breaks" any script which parses the
>>> listing and not prepared that such change may occur (actually,
>>> the testsuite itself must be fixed therefore too). At the same
>>> time I don't really like the idea of a new flag to turn on the
>>> printing of the info - just print it.
>> 
>> I will make sure that V2 includes any necessary changes to the 
>> test suite.
> 
> Thanks in advance.
> 
>>> The listing becomes non-uniform and type-dependent, because 
>>> it's restricted to the hash types. But therefore should we add 
>>> the listing of the number of elements to the bitmap and list 
>>> types too? For the hash types, the data comes free - for the 
>>> other types is must be calculated at every listing.
>> 
>> This is the reason I only added it for the hash type.  I don't 
>> have any objection to adding it to the bitmap and list types as 
>> well but I didn't have a consumer for that information in mind
>> to justify the extra calculations at run time.  Plus, the
>> libipset consumer could count entries in output just as well as
>> the library itself.
> 
> That would be a little complicated (I mean to count the entries 
> from libipset): the library should cache all the entries to count 
> them, finish printing the header by the element count and then 
> print the elements.
> 
> But "ipset" supports the terse list mode when just the header is 
> listed, without the elements. So I believe it's just better to 
> calculate the element count in the kernel header function for the 
> bitmap and list types as well. It can be a lazy counting, without 
> taking into account the possible timed out entries: that way the 
> element counter is at least consistent.
> 
> Let's skip bumping the revision numbers for the set types.
> 

I finally have V2 for the hash type ready to go.  I ran into a number
of snags with the test suite, so I am not sure that the new patch will
cover all of it.  These problems exist when I test master as well so I
am at least sure that I did not introduce them.

I am going to look into the test suite failures and add the element
count to the bitmaps in separate patches.

Eric

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJVCwmcAAoJELbVsDOpoOa97sUP/1blr7j5aqrqHRyTNe4DkwoG
jucfToO8KmSRUGTYNMqcHh1L8eZa3xfHVIDU1CeTtHkOKGjuVjcdx6pby91gPQwr
PcWH+CKAldXhtOywJZf3P6L/gKgkIk/ssBImyIdAD+2eLISdscVH8dhupcYAoORz
h+ye00tZASXiAKiVg/96DIi7n33BjGV4WpHVoGCMKlldsSzEX+2rdosNa7CNyHH/
Hl56jQSTQEX+GC0ilCy++IVz3J/etY+JFf1oJe3jk4XY+znlYalAWREc4bhrV2t9
/OANr+cy7cuxkdFESppB7vWke3OObdVwi1xIo/eAYvTyfMSjGBZ/GEFuOpAVwY+2
4U0VWBtBY8j9UNQA+emYBICQQj0Oh0uYjPS+OJgAeb1pFC4IdGYYzmY3eZ/vmHpZ
g65F0xkXwGsf0elZJoeYBV6GRZTDiQaJ2MBEVpBOEjDVpxvNgRT53xlZ/FHYBL9f
KAGKa01VcgHnbAw8PCD9lietPnubC7fLtxKqdldnlJBX0yORzEwcyNLpR34yhZR0
1P+QV4geAQbvmovyRF9rPzYVhRzBC0VYdV5Y/6hoZURTKlh0klSmsLvbxnMrl5DQ
H2G72shyhJWn7qIivRSnngjPTnFWsBfol0uVzkxI/6xhAx/29ffR124DbuYCSCHL
xxGLHvQb8/EsXPo4C9d+
=af5L
-----END PGP SIGNATURE-----
