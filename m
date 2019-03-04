Return-Path: <SRS0=Cmqr=RH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D4EFC43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 19:01:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FECF20663
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Mar 2019 19:01:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rA18Kgms"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfCDTBY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Mar 2019 14:01:24 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:44892 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfCDTBX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Mar 2019 14:01:23 -0500
Received: by mail-pg1-f180.google.com with SMTP id j3so3714705pgm.11
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Mar 2019 11:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=reply-to:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=OCMtExmucLMe/Eh14uwYQObzNR9ONnFBndg1W+7sqW8=;
        b=rA18KgmsrfdlPoGj27hIKxMZTdqcv8aGcUE6o5TZfgPqx3ruoAIFbU6W/aMgLQRHvU
         GHyLe2WIHGIa0XJjm+KbppT0lKnQu4BkHWkR+/Z50C9J6WQ7yztHU8wwCpQ03wnnaKUb
         dTZ8VUBYKOLcYMB8U6VPWDMmotWQwEi+umLT26nd2a0+PoHwaFkvjELAY0Pn21SWRP9M
         1TNB2/B+IikD6HfPtvUD4S9+CyTo57ho5veEiTDvrYLJV+YXRbcq8m3rwPEWgLMI//uH
         E34BZdmQ7Azr9IxvPhfOS/TkLolwRLdmJpC92zZU28RNrBAh6/Sb9BvTrF3KgBY+Lzvc
         PpSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=OCMtExmucLMe/Eh14uwYQObzNR9ONnFBndg1W+7sqW8=;
        b=DHOf5KUY7bMkMpiVW1BYjZm36tOuPA2gy3WVpGdNSWlQYnLtmJlp/7LoxErhnujciK
         gDRJhZmTpv4KcepcMdoHlU2jEcMaJNWyos4ckh3RKpCLspg5ghyeR8sFgLv7IrY9O/hb
         3SGESjlUAC8vc0Lgpyf4Y5t9gQatN/FqHjxYkqu5c/rrfWHLO/HCWsSFlhCPfPGcTdv7
         k0ZaKOwBEH/7zuFV3iYr2G3RmbjzPftklJ0RHQY6y54/iYYc2HB42U2ngIbk6OKAHhHw
         X6IsEikwYRtE3N3168TxHJf4jk8E4B/CqlUzKWAvwcOMKIcbp/RA9FUHF5us+/sojZo9
         WIhg==
X-Gm-Message-State: AHQUAubO4tpSZawZ/4/2ypZXvPrYeroPpAew9hAz6eJWY3IGYcmFb/jQ
        +V/ta444z+77De3VBKUAIi5l8Ryf
X-Google-Smtp-Source: AHgI3IbmOR74+zAE/ZuCA59RfTUCoqj6ilPl76vqCvfb/7Nv/bV0kWg0Wr1MwD++taJBB+4sIU2dig==
X-Received: by 2002:a62:8384:: with SMTP id h126mr21106661pfe.243.1551726082255;
        Mon, 04 Mar 2019 11:01:22 -0800 (PST)
Received: from mua.localhost (99-7-172-215.lightspeed.snmtca.sbcglobal.net. [99.7.172.215])
        by smtp.gmail.com with ESMTPSA id i193sm12011397pgc.63.2019.03.04.11.01.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Mar 2019 11:01:21 -0800 (PST)
Reply-To: pgnet.dev@gmail.com
To:     netfilter-devel@vger.kernel.org
From:   PGNet Dev <pgnet.dev@gmail.com>
Subject: xtables-addons build fail with linux 5.0: "error: implicit
 declaration of function 'do_gettimeofday'; did you mean 'do_settimeofday64'?"
Message-ID: <c4382224-6bfa-3604-28c4-4ab1ea61e943@gmail.com>
Date:   Mon, 4 Mar 2019 11:01:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: base64
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

QnVpbGRpbmcgJ3h0YWJsZS1hZGRvbnMnIHYzLjIgZm9yIGp1c3QtcmVsZWFzZWQgTGludXgg
NS4wLA0KDQoJaHR0cHM6Ly9idWlsZC5vcGVuc3VzZS5vcmcvcGFja2FnZS9zaG93L2hvbWU6
cGduZDpLZXJuZWw6c3RhYmxlL3h0YWJsZXMtYWRkb25zDQoNCmZhaWxzIGF0DQoNCglodHRw
czovL2J1aWxkLm9wZW5zdXNlLm9yZy9wdWJsaWMvYnVpbGQvaG9tZTpwZ25kOktlcm5lbDpz
dGFibGUvb3BlblNVU0VfTGVhcF8xNS4wL3g4Nl82NC94dGFibGVzLWFkZG9ucy9fbG9nDQoN
CgkuLi4NCglbNTNzXWdjYyAtV3AsIC1NRCwgL2hvbWUvYWJ1aWxkL3JwbWJ1aWxkL0JVSUxE
L3h0YWJsZXMtYWRkb25zLWRlZmF1bHQtMy4yL2V4dGVuc2lvbnMvLnh0X2NvbmRpdGlvbi5v
LmQgIC1ub3N0ZGluYyAtaXN5c3RlbSAvdXNyL2xpYjY0L2djYy94ODZfNjQtc3VzZS1saW51
eC84L2luY2x1ZGUgLUkvdXNyL3NyYy9saW51eC01LjAuMC1scDE1MC40Lmc2YmM2NDc3L2Fy
Y2gveDg2L2luY2x1ZGUgLUkuL2FyY2gveDg2L2luY2x1ZGUvZ2VuZXJhdGVkICAtSS91c3Iv
c3JjL2xpbnV4LTUuMC4wLWxwMTUwLjQuZzZiYzY0NzcvaW5jbHVkZSAtSS4vaW5jbHVkZSAt
SS91c3Ivc3JjL2xpbnV4LTUuMC4wLWxwMTUwLjQuZzZiYzY0NzcvYXJjaC94ODYvaW5jbHVk
ZS91YXBpIC1JLi9hcmNoL3g4Ni9pbmNsdWRlL2dlbmVyYXRlZC91YXBpIC1JL3Vzci9zcmMv
bGludXgtNS4wLjAtbHAxNTAuNC5nNmJjNjQ3Ny9pbmNsdWRlL3VhcGkgLUkuL2luY2x1ZGUv
Z2VuZXJhdGVkL3VhcGkgLWluY2x1ZGUgL3Vzci9zcmMvbGludXgtNS4wLjAtbHAxNTAuNC5n
NmJjNjQ3Ny9pbmNsdWRlL2xpbnV4L2tjb25maWcuaCAtaW5jbHVkZSAvdXNyL3NyYy9saW51
eC01LjAuMC1scDE1MC40Lmc2YmM2NDc3L2luY2x1ZGUvbGludXgvY29tcGlsZXJfdHlwZXMu
aCAgLUkvaG9tZS9hYnVpbGQvcnBtYnVpbGQvQlVJTEQveHRhYmxlcy1hZGRvbnMtZGVmYXVs
dC0zLjIvZXh0ZW5zaW9ucyAtSS9ob21lL2FidWlsZC9ycG1idWlsZC9CVUlMRC94dGFibGVz
LWFkZG9ucy1kZWZhdWx0LTMuMi9leHRlbnNpb25zIC1EX19LRVJORUxfXyAtV2FsbCAtV3Vu
ZGVmIC1XZXJyb3I9c3RyaWN0LXByb3RvdHlwZXMgLVduby10cmlncmFwaHMgLWZuby1zdHJp
Y3QtYWxpYXNpbmcgLWZuby1jb21tb24gLWZzaG9ydC13Y2hhciAtZm5vLVBJRSAtV2Vycm9y
LWltcGxpY2l0LWZ1bmN0aW9uLWRlY2xhcmF0aW9uIC1XZXJyb3I9aW1wbGljaXQtaW50IC1X
bm8tZm9ybWF0LXNlY3VyaXR5IC1zdGQ9Z251ODktbW5vLXNzZSAtbW5vLW1teCAtbW5vLXNz
ZTItbW5vLTNkbm93IC1tbm8tYXZ4IC1tNjQtZmFsaWduLWp1bXBzPTEtZmFsaWduLWxvb3Bz
PTEtbW5vLTgwMzg3LW1uby1mcC1yZXQtaW4tMzg3LW1wcmVmZXJyZWQtc3RhY2stYm91bmRh
cnk9My1tc2tpcC1yYXgtc2V0dXAgLW10dW5lPWdlbmVyaWMgLW1uby1yZWQtem9uZSAtbWNt
b2RlbD1rZXJuZWwgLURDT05GSUdfWDg2X1gzMl9BQkkgLURDT05GSUdfQVNfQ0ZJPTEtRENP
TkZJR19BU19DRklfU0lHTkFMX0ZSQU1FPTEtRENPTkZJR19BU19DRklfU0VDVElPTlM9MS1E
Q09ORklHX0FTX0ZYU0FWRVE9MS1EQ09ORklHX0FTX1NTU0UzPTEtRENPTkZJR19BU19BVlg9
MS1EQ09ORklHX0FTX0FWWDI9MS1EQ09ORklHX0FTX0FWWDUxMj0xLURDT05GSUdfQVNfU0hB
MV9OST0xLURDT05GSUdfQVNfU0hBMjU2X05JPTEtV25vLXNpZ24tY29tcGFyZSAtZm5vLWFz
eW5jaHJvbm91cy11bndpbmQtdGFibGVzIC1taW5kaXJlY3QtYnJhbmNoPXRodW5rLWV4dGVy
biAtbWluZGlyZWN0LWJyYW5jaC1yZWdpc3RlciAtZm5vLWRlbGV0ZS1udWxsLXBvaW50ZXIt
Y2hlY2tzIC1Xbm8tZnJhbWUtYWRkcmVzcyAtV25vLWZvcm1hdC10cnVuY2F0aW9uIC1Xbm8t
Zm9ybWF0LW92ZXJmbG93IC1Xbm8taW50LWluLWJvb2wtY29udGV4dCAtTzItLXBhcmFtPWFs
bG93LXN0b3JlLWRhdGEtcmFjZXM9MC1XZnJhbWUtbGFyZ2VyLXRoYW49MjA0OC1mc3RhY2st
cHJvdGVjdG9yIC1Xbm8tdW51c2VkLWJ1dC1zZXQtdmFyaWFibGUgLVduby11bnVzZWQtY29u
c3QtdmFyaWFibGUgLWZuby12YXItdHJhY2tpbmctYXNzaWdubWVudHMgLXBnIC1tcmVjb3Jk
LW1jb3VudCAtbWZlbnRyeSAtRENDX1VTSU5HX0ZFTlRSWSAtZm5vLWlubGluZS1mdW5jdGlv
bnMtY2FsbGVkLW9uY2UgLVdkZWNsYXJhdGlvbi1hZnRlci1zdGF0ZW1lbnQgLVd2bGEgLVdu
by1wb2ludGVyLXNpZ24gLVduby1zdHJpbmdvcC10cnVuY2F0aW9uIC1mbm8tc3RyaWN0LW92
ZXJmbG93IC1mbm8tbWVyZ2UtYWxsLWNvbnN0YW50cyAtZm1lcmdlLWNvbnN0YW50cyAtZm5v
LXN0YWNrLWNoZWNrIC1mY29uc2VydmUtc3RhY2sgLVdlcnJvcj1kYXRlLXRpbWUgLVdlcnJv
cj1pbmNvbXBhdGlibGUtcG9pbnRlci10eXBlcyAtV2Vycm9yPWRlc2lnbmF0ZWQtaW5pdCAt
Zm1hY3JvLXByZWZpeC1tYXA9L3Vzci9zcmMvbGludXgtNS4wLjAtbHAxNTAuNC5nNmJjNjQ3
Ny89IC1Xbm8tcGFja2VkLW5vdC1hbGlnbmVkICAtRE1PRFVMRSAgLURLQlVJTERfQkFTRU5B
TUU9JyJ4dF9jb25kaXRpb24iJyAtREtCVUlMRF9NT0ROQU1FPScieHRfY29uZGl0aW9uIicg
LWMgLW8gL2hvbWUvYWJ1aWxkL3JwbWJ1aWxkL0JVSUxEL3h0YWJsZXMtYWRkb25zLWRlZmF1
bHQtMy4yL2V4dGVuc2lvbnMveHRfY29uZGl0aW9uLm8gL2hvbWUvYWJ1aWxkL3JwbWJ1aWxk
L0JVSUxEL3h0YWJsZXMtYWRkb25zLWRlZmF1bHQtMy4yL2V4dGVuc2lvbnMveHRfY29uZGl0
aW9uLmMNCglbNTNzXS9ob21lL2FidWlsZC9ycG1idWlsZC9CVUlMRC94dGFibGVzLWFkZG9u
cy1kZWZhdWx0LTMuMi9leHRlbnNpb25zL3h0X1NZU1JRLmM6IEluIGZ1bmN0aW9uICdzeXNy
cV9jcnlwdG9faW5pdCc6DQoJWzUzc10vaG9tZS9hYnVpbGQvcnBtYnVpbGQvQlVJTEQveHRh
Ymxlcy1hZGRvbnMtZGVmYXVsdC0zLjIvZXh0ZW5zaW9ucy94dF9TWVNSUS5jOjM0MjoyOiBl
cnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rpb24gJ2RvX2dldHRpbWVvZmRh
eSc7IGRpZCB5b3UgbWVhbiAnZG9fc2V0dGltZW9mZGF5NjQnPyBbDQoJLVdlcnJvcj1pbXBs
aWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbg0KCV0NCglbNTNzXWRvX2dldHRpbWVvZmRheSgm
bm93KTsNCglbNTNzXV5+fn5+fn5+fn5+fn5+fg0KCVs1M3NdZG9fc2V0dGltZW9mZGF5NjQN
CglbNTNzXWNjMTogc29tZSB3YXJuaW5ncyBiZWluZyB0cmVhdGVkIGFzIGVycm9ycw0KCS4u
Lg0KDQpEb2luZyBzb21lIGxpbWl0ZWQgZGlnZ2luZywgSSBkbyBmaW5kDQoNCglodHRwczov
L2J1Z3MubGF1bmNocGFkLm5ldC91YnVudHUvK3NvdXJjZS9saW51eC8rYnVnLzE4MTE3MjEv
Y29tbWVudHMvNg0KDQp3aGljaCwgYWx0aG91Z2ggcmU6IE5WSURJQSBidWlsZCwgKmRvZXMq
IHBvaW50IG91dA0KDQoJLi4uDQoJY2hhbmdlIGluIGtlcm5lbCBmdW5jdGlvbiBkb19nZXR0
aW1lb2ZkYXkgdG8gZWZpX2dldHRpbWVvZmRheQ0KCS4uLg0KDQpJIGhhdmVuJ3QgeWV0IGZv
dW5kIHRoZSBkb2N1bWVudGF0aW9uIG9mIHRoYXQgY2hhbmdlIG9uIGtlcm5lbC5vcmcgZm9y
IHY1LjAgLi4uDQoNCkNhbiBhbnlvbmUgY29uZmlybSB0aGF0IGtlcm5lbCBjaGFuZ2UsIGFu
ZCBpZiB0aGVyZSdzIGEgZml4L3RocmVhZCBhbHJlYWR5IHVuZGVyd2F5IGZvciB4dGFibGVz
LWFkZG9ucz8NCg==
