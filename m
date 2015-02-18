From: Eric B Munson <emunson@akamai.com>
Subject: Re: [PATCH RESEND] Add element count to bitmap and hash headers
Date: Wed, 18 Feb 2015 14:53:39 -0500
Message-ID: <54E4EDC3.6080104@akamai.com>
References: <1424187335-5968-1-git-send-email-emunson@akamai.com> <20150217155331.GA3341@salvia> <alpine.DEB.2.10.1502172223580.16817@blackhole.kfki.hu> <20150218035416.GA4945@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"Hunt, Joshua" <johunt@akamai.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:48833 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbbBRTxk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 14:53:40 -0500
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

The missing user space was my mistake, I sent an early version of the
patch.  The correct version is in flight.

Eric
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJU5O3DAAoJELbVsDOpoOa9hF4QALAGxVYC6Tvt3TNH8TQZk9aK
dS9rwP/6GL+pj5eUzpDlPRzvfuTqWcg2OVOGsOSYsrlzVfBwveSg++EsXq6fm5CU
RmtgnbrBRK9exIDmpD89loDBgWANvMajGfIGVdWlC7gblOoPzZrMJByeUfOrw1WB
sJm6lodWnqfQJFGDdXGl0ZFX0C71Hvt5y7NF9vBQhXF0U9smooyvNT+tng1Y8faU
9jLbscOxwKtlLRYtpRMpQ+kg4YmWbu3mdR3UqGvlCb3KYK3C79XfJPTdYur9zc5s
RNyrIXkXye31LCOgmZ7YYxcALUb2MRdsHU05dbPuq1/0RRFGaSjNNKJkBX798aTk
snzHYmqo7ldySB5uvLqdcr6MtQi0KkTGmdhPZAbWFm26SFx3e3tywdDzFUweT95R
/39t9uee++vAfB8wa9W+tGZ2zddkK90GYTKFb4flF0bTS7Bv4POVYKW2c9siX4eG
HKQuWx66L1SSRfih1u3MMle5yv+C/2uud255rz5PcqbqXbZ3d71o2+tRmf9TqZW1
yHu6rbJbIHu/e+bLSM6yjVdiRAC4zjokT2LzvCsWRasdIb2Rw3raND/2M6L81ZpH
u+Iz5hLXKZJ7nC0M8iTqIWAOpas+9IDjV/AwM4LW1erNgJ5qXX35bwWHIhMdViDt
ModRCpWkBlLTq+stLZpQ
=6nGr
-----END PGP SIGNATURE-----
