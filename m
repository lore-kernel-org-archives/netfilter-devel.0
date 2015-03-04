From: Eric B Munson <emunson@akamai.com>
Subject: Re: [PATCH RESEND] Add element count to hash headers
Date: Wed, 04 Mar 2015 09:39:48 -0500
Message-ID: <54F71934.6000303@akamai.com>
References: <1424289208-6164-1-git-send-email-emunson@akamai.com> <54F67D2E.5050003@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Josh Hunt <johunt@akamai.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:59857 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758720AbbCDOjt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Mar 2015 09:39:49 -0500
In-Reply-To: <54F67D2E.5050003@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/03/2015 10:34 PM, Josh Hunt wrote:
> On 02/18/2015 01:53 PM, Eric B Munson wrote:
>> snip
>> 
> 
> Jozsef
> 
> Can you clarify what you're looking for when you mentioned (in a 
> previous mail) "I don't like any change which affects the userspace
> but not expressed in new set type revision."? Are we breaking ABI
> here by adding a new field to print out the # of elements in a
> hash? Would it be better to default this to off and only print it
> if a new flag were presented?

To be clear, we aren't adding a new field.  This field exists already
and is not in use for hash sets.

> 
> I guess I don't see why we should rev all of the hash types for
> this change when we're not really adding any functionality to them.
> We can rev the ver of the library to signify a change here. Would
> that help?
> 
> If we do need to add a new revision I think we may want to step
> back and make sure there's no other information we want to expose
> first and if there is do it all in one shot to minimize the # of
> revisions.
> 
> Thanks for your help. Josh
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJU9xkuAAoJELbVsDOpoOa9eFgP/1FEhgQw/zrHxVhsPTi1uYRz
h1ftmpOgkgqJWEBsGoydOr+hbYATIgoU6O829jH84OKFQdoPCl00uqO7XXLB601C
ii1OPxb57iHL9/FnbTAHuSKqBhzQPwUSWuICISLulgAMD25an5eckbnRR/i8h0SW
kEbDitCBFRqyKRJZXSSS36oQuryd9j/pH2UYxE5vtQ9oiTW+MXxK7HvzDE6RTssz
rpVW3lbPXnLucMt4te1V4iX7t7r0f7UVcQuQGSOSEm1jB+94+AIowaoUzJDNkC6E
JMMERSOS9RI7LerlG+5iy13nFQgOcTwxX/Xfhy5CNl7v7w6biVzzS18Kf2qwdFmt
yOM/InBpwecE8VoTM2tlP6WLqpsNEE/aaiA7vLiqKU+U7xSYBN6o+8w0FdpKtasx
+TNqr7wfKBx/oyvZQSb13YQ89ci/gDeVczO51peoNhQn9zy+XY41DSLrdCPfa9HZ
x1lkiazFP/x07WpHPKs+g4AuMNkQ0vTkowVkH3orcBRnqUxinngAsnkefXC1TZ96
L38bJXLkOC//YfE+i/RtzzuX5KN6rbiw//h5nM3m0bg6Ri7royZuAtgt2ZoYDM0m
SmxD1bX7lqi46G4FvPMDCzD/NlelMNJkNWAlvsWFx1K5TC4jXQhDMIjDv9Mpz2PT
vI1LkbGQ2JYLUGBNmTzz
=pny3
-----END PGP SIGNATURE-----
