From: Eric B Munson <emunson@akamai.com>
Subject: Re: [PATCH RESEND] Add element count to bitmap and hash headers
Date: Wed, 18 Feb 2015 09:59:40 -0500
Message-ID: <54E4A8DC.7030200@akamai.com>
References: <1424187335-5968-1-git-send-email-emunson@akamai.com> <20150217155331.GA3341@salvia> <alpine.DEB.2.10.1502172223580.16817@blackhole.kfki.hu> <20150218035416.GA4945@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"Hunt, Joshua" <johunt@akamai.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:30874 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbbBRO7l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 09:59:41 -0500
In-Reply-To: <20150218035416.GA4945@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/17/2015 10:54 PM, Pablo Neira Ayuso wrote:
> On Tue, Feb 17, 2015 at 10:35:40PM +0100, Jozsef Kadlecsik wrote:
>> On Tue, 17 Feb 2015, Pablo Neira Ayuso wrote:
>> 
>>> On Tue, Feb 17, 2015 at 10:35:35AM -0500, Eric B Munson wrote:
>>>> It would be useful for userspace to query the size of an
>>>> ipset.  This data is held for both the bitmask and hash
>>>> types, however, it is not exposed to userspace.  This patch
>>>> uses the otherwise unused attribute IPSET_ATTR_ELEMENTS to
>>>> indicate the size in the the header that is exported to
>>>> userspace.
>>> 
>>> Thanks for your patch.
>>> 
>>> I think Jozsef will need the userspace bits for his library
>>> and utility.
>> 
>> Yes, that's missing from the patch. Also, I don't like any change
>> which affects the userspace but not expressed in new set type
>> revision. Later on the new revision makes much simpler to
>> identify why the "Elements: is missing from the listing of a
>> set.
> 
> Please address Jozsef's feedback and resubmit. Thanks.
> 

Let me look into it.  It has been a while but I am pretty sure no user
space changes were required.  This field exists in the base structure
returned to user space, it is just not used prior to this patch in the
hash sets.  If that is the case (and I don't remember off the top of
my head as it has been >2 months since I looked) that is the reason I
did not create a new set type revision.

Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJU5KjcAAoJELbVsDOpoOa95ggP+QGnlc4yW3Jz45NuwgZGgHpo
rVognvjAG9Xs8WwANKnr1gi1LYfuAQJC2APu6IeYA3Fh7zKqKHgSG4o1LNghtcDv
pCwRiOnqqAJZoYD9JBDoUNx/0Cnc3F7hJnag4G9LXXe5zUcuVaUzUYw49Fk7V6sI
4kNMiPcsXnd21+SQEJqFJXj60NRSgEke5e2sXSxfwqhq+lzTdJiL7sNV8aR8R9DH
Ak10hbIv3iAmWtANvNuD9T+T1YSIlh2Y/PrWnDGUk/b4mohj8ZVELnESO6aiUjZK
OT0Gy3LrI7VxIGdzxkA42WZhFNIhbpyDCNnVTiNsxXl8y6djbYieZv/ecM/d9GR0
FcrZtx3iGSLn5B6LHHzWufd0+KBaCgL8HupNWYrX/JOyohipEL7YKQzqj3jXn44g
0yyHRZA3Cys8fZHvXMI2LqB1iSsjwqxTSyS60C2mNuAGuVm0zIQOWHRhsfsLVsMq
n7yNa1hhGMlj0CdaZXRoqU7+/JwbXWap1eMT+Hb2wu8i482xZwgmV9SiCpTP+hrZ
8s2YavuV7Tl2zqMp+mui9PGOdtMwiWdB8Ccn9/x0GzRY2fV3PXcmmOFqfo/9nlhy
2tvDpja7bpWGS9WPECY6zElTkCOUtO7JZspHuWMhCcIvzYTD82HFjjkCL/0j06BA
rPzd7QIx4wzeuqAvT+Sa
=Z+5d
-----END PGP SIGNATURE-----
