Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCBAC77B7A
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 May 2023 06:49:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbjEaGtj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 May 2023 02:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjEaGti (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2023 02:49:38 -0400
X-Greylist: delayed 411 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 May 2023 23:49:33 PDT
Received: from mail.valdk.tel (mail.valdk.tel [185.177.150.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93655125
        for <netfilter-devel@vger.kernel.org>; Tue, 30 May 2023 23:49:33 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id DAC92B3892C
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2023 09:42:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=valdikss.org.ru;
        s=msrv; t=1685515354; h=from:subject:date:message-id:to:mime-version:content-type:
         content-language; bh=SgQ/JEp538oFTpKf6E04GxMo/vg3xsqKHP3J61KCaAA=;
        b=OILXVzrUezQ+Ki4F+DHV6MHh2RONAbD9zQYZ48ChkT8t4Hir0QpUnJ/BRls9Ktg9d/w9UE
        BedLhnRAKulJeu0/nkJ/YuQ7ld3MWl71BoDIN/nBcwTZgjHXIE9wjLowdn+8iNraKUxPyV
        5T7KfBfrxn5ZygDo7I+pnq5L1X+UWa0LYQW5+FsXrutiDZ+BoUyJkJGAJksCaMcbPGU8Y6
        EMM7aWJjWY2iSDKL/oQiczMHeGGoRC151/S6jjOCu5ItUmeZXS1kYsb7GpptBlkZKFDS5d
        0MKYOjCJlgNgzKxQQgGf613l8j771RzfAcdjM0xHODNUCnDbCOdzoD2RXOfdMw==
Message-ID: <2b05bb89-08bf-b3b1-c2d7-9b391953f303@valdikss.org.ru>
Date:   Wed, 31 May 2023 09:42:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.5.0) Gecko/20100101,
 Thunderbird/78.5.0
Content-Language: en-US, ru-RU
To:     netfilter-devel@vger.kernel.org
From:   ValdikSS <iam@valdikss.org.ru>
Subject: xtables-addons: ipp2p does not block TCP traffic with nonlinear skb
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------5JCEpA00mkNPRE0RNRDcBMFX"
X-Last-TLS-Session-Version: TLSv1.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------5JCEpA00mkNPRE0RNRDcBMFX
Content-Type: multipart/mixed; boundary="------------uVaja00j0AxbiOqZIEmYNiBt";
 protected-headers="v1"
From: ValdikSS <iam@valdikss.org.ru>
To: netfilter-devel@vger.kernel.org
Message-ID: <2b05bb89-08bf-b3b1-c2d7-9b391953f303@valdikss.org.ru>
Subject: xtables-addons: ipp2p does not block TCP traffic with nonlinear skb

--------------uVaja00j0AxbiOqZIEmYNiBt
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGVsbG8gbGlzdCwNCg0KSSdtIHRyeWluZyB0byBibG9jayBCaXRUb3JyZW50IHByb3RvY29s
IG9uIG15IGxvY2FsIG1hY2hpbmUgd2l0aCBpcHAycCANCm1vZHVsZSB1c2luZyB4dGFibGVz
LWFkZG9ucyAzLjI0IG9uIEZlZG9yYSAzNyAoa2VybmVsIDYuMi4xNSkgYnkgYWRkaW5nIA0K
dGhlIGZvbGxvd2luZyBydWxlczoNCg0KIyBpcHRhYmxlcyAtSSBPVVRQVVQgLW0gaXBwMnAg
LS1iaXQgLS1kZWJ1ZyAtaiBEUk9QDQojIGlwdGFibGVzIC1JIElOUFVUIC1tIGlwcDJwIC0t
Yml0IC0tZGVidWcgLWogRFJPUA0KDQpIb3dldmVyIHRoZSBwcm90b2NvbCBpcyBub3QgYmxv
Y2tlZCBjb21wbGV0ZWx5OiB0aGUgYW5ub3VuY2UgaXMgc3RpbGwgDQpzdWNjZXNzZnVsbHkg
dHJhbnNtaXR0ZWQgdG8gdGhlIEhUVFAgYW5ub3VuY2VyLCBhcHBhcmVudGx5IGR1ZSB0byAN
Cm5vbmxpbmVhciBza2IgY2hlY2sgaW4gaXBwMnAuDQoNClRoZXJlJ3MgYSBjb2RlIHRvIGJs
b2NrIHRoaXMgY2FzZToNCg0KPiAvKiBTZWFyY2ggZm9yIEJpdFRvcnJlbnQgY29tbWFuZHMg
Ki8NCj4gc3RhdGljIHVuc2lnbmVkIGludA0KPiBzZWFyY2hfYml0dG9ycmVudChjb25zdCB1
bnNpZ25lZCBjaGFyICpwYXlsb2FkLCBjb25zdCB1bnNpZ25lZCBpbnQgcGxlbikNCj4gLi4u
DQo+IAkJaWYgKG1lbWNtcChwYXlsb2FkLCAiR0VUIC8iLCA1KSA9PSAwKSB7DQo+IAkJCWlm
IChIWF9tZW1tZW0ocGF5bG9hZCwgcGxlbiwgImluZm9faGFzaD0iLCAxMCkgIT0gTlVMTCkN
Cj4gCQkJCXJldHVybiBJUFAyUF9CSVQgKiAxMDAgKyAxOw0KDQoNCkhvd2V2ZXIsIGl0J3Mg
bm90IGdldHRpbmcgcHJvY2Vzc2VkIGR1ZSB0byBub25saW5lYXIgc2tiOg0KDQo+IHN0YXRp
YyBib29sDQo+IGlwcDJwX210KGNvbnN0IHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCB4
dF9hY3Rpb25fcGFyYW0gKnBhcikNCj4gCS8qIG1ha2Ugc3VyZSB0aGF0IHNrYiBpcyBsaW5l
YXIgKi8NCj4gCWlmIChza2JfaXNfbm9ubGluZWFyKHNrYikpIHsNCj4gCQlpZiAoaW5mby0+
ZGVidWcpDQo+IAkJCXByaW50aygiSVBQMlAubWF0Y2g6IG5vbmxpbmVhciBza2IgZm91bmRc
biIpOw0KPiAJCXJldHVybiAwOw0KPiAJfQ0KDQpBbGwgSSBzZWUgaW4gZG1lc2cgKHJ1bGUg
d2l0aCAtLWRlYnVnKSBpczoNCklQUDJQLm1hdGNoOiBub25saW5lYXIgc2tiIGZvdW5kDQoN
ClRoaXMgY291bGQgYmUgY2hlY2tlZCB3aXRoIGEgc2ltcGxlIGN1cmwgY29tbWFuZCwgd2hp
Y2ggc2hvdWxkIGJlIA0KYmxvY2tlZCBpZiBpcHAycCAtLWJpdCBpcyBhY3RpdmU6DQoNCiQg
Y3VybCAnaHR0cDovL2J0MS5hcmNoaXZlLm9yZzo2OTY5L2Fubm91bmNlP2luZm9faGFzaD1z
b21ldGhpbmcnDQoNCkkgY2FuIHNlZSB0aGUgcmVzcG9uc2Ugd2hlbiBleGVjdXRpbmcgdGhp
cyBjb21tYW5kLCBob3dldmVyIGl0IHNob3VsZCBiZSANCmJsb2NrZWQuDQo=

--------------uVaja00j0AxbiOqZIEmYNiBt--

--------------5JCEpA00mkNPRE0RNRDcBMFX
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEMiogvXcpmS32v71gXNcgLu+I93IFAmR27FcFAwAAAAAACgkQXNcgLu+I93II
pg//RxWNgVOhOnG5Mhjg9Z7kfH7g/H/DBEnjcbfktvuy6I3VvucdxnqIvt33bCuYaH8DT8ihx7YR
G4CpSsyZ3OImdCqFSl99h8rEU3uGx+W8D2gcHRn/Nx84gjA4YE3WNTtyq7LEUgd5bdqpkPptP3/R
lNLE0Q+WWj6fFaHIaFcJ5bm3Gh+6wQDLorvPbK9xWtYoGdEeoSpCZ7PoolSo6zSmoR1q6NiICaXf
VnnvGVJeYULAa2i2EgEOs7Th6oTkxNr5ZPZ+Q7r1mKnATPajYNLmO0M9AVtTGNVLGXgNbuZrfz1a
5uHt2l56EZsKzgMkGoN9e6msPWF2+AwnFaSFvqZ3Z/7MnL69gDYJgTte5pYYHqU7MlxXyR4y4KKT
po2IgkHpQXYqv9JBT1FHei7adE4ugp6/K3h8zuG4dgvJYzNYKwhwYAeWkRphMepclWUWX8Uu4Jdu
fmHmKtgLCYTTNX4r2I7XGhsbcRH9L7m4IsbeAJ6OY1dReFfZaKrRe967r9hvsLMMsm5tS17zkWZ0
NovBS45+mIhEmZx47/xuYBauYbN0kfJOjy91jsQbRCUWbtC6wrkHcf5mZgpbmvQTryKsNZbeoCEK
YQWMmQ5xCk4nxuZ2KMvc7170SNgTgrCeEqPIwU1H3gfQa9xL3BBkpF9zZ8n7lTvpLCnvfNPaegzm
gHU=
=sfP7
-----END PGP SIGNATURE-----

--------------5JCEpA00mkNPRE0RNRDcBMFX--
