From: Sven Anders <anders@anduras.de>
Subject: Re: Negating limit
Date: Thu, 08 Jun 2006 11:12:50 +0200
Message-ID: <4487EA12.6020609@anduras.de>
References: <44848BE1.1070503@anduras.de> <4487D36C.5060708@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080704030601010307020309"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4487D36C.5060708@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080704030601010307020309
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Patrick wrote:

>> Here is a patch to allow a negated "limit", so we can match above and below the
>> limit.
>>
>> It adds a new "flags" variable after the burst. I'm not sure, if I can add it
>> after the "*master" variable, so I added it here.
>> Does this preserve compatibility, because anything after is only used by the kernel?
> 
> No, unfortunately there is no way to add a new variable to that struct
> without breaking compatibility. You could add a new revision, but I
> would like to think about Massimiliano Hofer's patch before that,
> if we do something like that we can get rid of the "master" pointer
> with the new revision.

What do you mean with "new revision"? A new match named "limit2"?

Which of Massimiliano's patches do you mean? The "support for entry data" patch?

To understand correctly:

 Is it not possible under any circumstances to add new variables to a match info
 struct or is the problem the "master" variable?

 If so what is the "master" variable for?

 As far as I understand the size of the "match info struct" passed from the
 userspace must exactly match the size of the kernels "match info struct".
 Right?

Regards
 Sven Anders

- --
 Sven Anders <anders@anduras.de>                 () Ascii Ribbon Campaign
                                                 /\ Support plain text e-mail
 ANDURAS service solutions AG
 Innstraﬂe 71 - 94036 Passau - Germany
 Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFEh+oQ5lKZ7Feg4EcRAvHeAJ9JD1tBGvLhZwETVaEpgj/KPZe3KACfcUhG
2/TN39WZ3JjJjwye4xW84i8=
=GIIo
-----END PGP SIGNATURE-----

--------------080704030601010307020309--
