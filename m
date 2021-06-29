Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22999C11F67
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 14:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0668C61DD1
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 14:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhF2OzP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 10:55:15 -0400
Received: from sonic314-16.consmr.mail.bf2.yahoo.com ([74.6.132.126]:36583
        "EHLO sonic314-16.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232521AbhF2OzN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 10:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1624978365; bh=fM0ULaGl+s3YojY3ebyzOzwdNZn1oaz9yFi4V2pJ0J8=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=VoRyR/D4/udqRMx1pT9k4TEZEwxJYvT0jb7YiG22EyAd7KwTSm+GLN2ZxDJnNQd1NotnQMoti5cFXRrSaqhFPRJRoqwmk13P9Up6JWiK9YKKI+JPFBX2UTXEs/WZQI1zAxsmEpRFvEW6DRK6WuY0RvJwS0hwXafSlkkE800ONS8=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1624978365; bh=ykySldB97JyQeqmmExUuevCNrA5AD0eKcdBTsUhiwbm=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=uXuuxs+fuWFxiwydSqJejP8p1oLsEvPowPdzstuG/+Llc4gEjAXvWErRCFzZ5xy7aexIB8DMHmrYJHe2s3DgSZYk+XDn2XboJqadd97QvwaNJAh6OayuzwPXhrwZJYUYLUsDSSxB5CRn4kCGjpDxfobQ00khspfogayeT27IQvAZ+VUCE8jTndq2MjlPMpZTO3tkZvoDA9JI1cbeSCjwauRgD8zjnjVCfwEZuY77mV2ON1vJgDYQvE6Oy+MV0QROSFsWxulPpdRhMh1vVhlQrwGiMdjc8j2rB8jKAPxTBRXQCSOp3TnwqRwoXhDIjVexI7VWSnb4hPsehqHnM0959Q==
X-YMail-OSG: 3oIS9sgVM1nbYClRYtepLaPYrOz.eqrizGnewiQ..DTjVi2Ed2mOCN6EmLVZdkc
 _k68o9n2EiSFTbHil5jVGfOF0g3Pv53oCv3YIuJPPvT.147qOuZfS.O63KlLZJueJebTU0PvtFHC
 CdHdyLIplJIKGBI4JaKAM3RCUv8RyG85lLa5ywA789g7_UxlzFdYUVhz2XESTMOvfHAcCladCixb
 1QNRiM8Gcm41Lr2qamlAgoUVJMvi2ZTfP9vnS5ARUoDAHoJzmfdu6PbtZq3aqmzPgAgQO8gpi84X
 Vo._u1M8fm8kCGP2Jp98w5wsVqyVo3y8qlOMJ9ll5I9itrrdx9F4fYDPGrxeKBfRRSfERWfpO_x_
 DC4YkQrt9upoUECO_5iJF7v_DF.NSVxvXi848IihwjmWpdCHKYslWXdXRfcqO726QpCdz7DdGs4F
 v992XHKABfwxRAnnrwPVlGjhoN5fgaJj64Jo9CXXgNuCyXAwg.aYqkARdh5H9RSe8UbLfnrsG8Zi
 ouVdaOGfDlp4WsEszpNIqd5iRTo1DRHN22jn7oUgbjN8bC7pUpy8OAt5x6bOjq2lo8lWu3NL2_La
 80rLyRxCxuDadj4yjpP5LC1lhHuVJCR4nAH61mVTNY_hgEK4FNJRjMnD9lKkqCGo2nQpdPPx3dnf
 E04IaA4ejezQcJjwppG2rlfR7EZ4QYzh3LFkyLajd8mpoF13gO31BgZ_rnNy06a3W3rxA_poJB0_
 jEKVAd8qqw9.mqzxzsippiO1F6GXOKO.8NEiKjgTkmpV4DICIoJq8GBZb91rkFA_tAJQLfOZN4aT
 CxPcvyBx_E5Nf0opyQgMARij0SkhZ7bXDdY.mCCX2bedkoJSnzBqcyliUwFrvU8t9svL3Qq_LDCJ
 tKStBvqMMmdeGKVsU6N8977qSio6SfnDATswg9USGC0DhAjRGLlCCktt68eYw7JYZ_fLC2mB572L
 A.rjwEQesN8FmLxdwTTsWR4AijltoHXsuiZIjbkY5TC9vpuih9ZIcg9CLoNeYH50yWEycKZeg7pR
 Ne1p0lzTXvBjXa5ji.5BhlWPZFbqIteBulAIpw2JJEUuKuULQuijijSpopwfIdIOvk1rZpG6h2hf
 DbP2n8t_wZ0Rjp5cYNnQR2RaaaqmGh1hd.t0ERy.L_3SIespUaM3NU.yIXVpVPZgHAIe.4jvP9iE
 tvGhPGNvK78WI541YIXR24EEjYC0BIXsqNyOL9oupw8hge7_UiNxozHlcSqGoN6flDMif2Ww9MyM
 qfv9aXJwxHA5C5Dm10wSWsa1SSnNr4OvRmsn.HSUrI4JFlQ1d.VhEdMp38E3XJrK5Mk5W.ahDhu3
 Ecnmy73kKfuicrkF80ZDa7OhVN3MAjGvCRlygffpdae791CgYH0kgDlv6o5QaRZ2kaAAJo_N02ZK
 EwdtAcV2DCvEVw3nsbKvB35j2asKvK3xKaHxnOXwjdKFKC7XjUIXmQtHdE.DcpUd0nvrnuFi73bA
 e1eyuyJD13EeCTsrffKD6AUOTtcfjnjJngpLPbc37.LE_T6Mm9yWT_JWogRP12YOwKyN9bes8x5B
 T4EVsOGB41Z6x3O3tvwRJElgPwzKcbPH0KtL4sig9dnkgyt3fW.6FTG.LciVZ5rnrVKblMjK0sNV
 tJnWXSM2Fozeik7dWXM_alrEz7xSvarc9JR9ozCkUD0tQRPx76Q8D1hEtMGGVVDI9HHOe9HiEuqP
 AZ4b0QPQHVZl3Nma62Z7FbS2BFnCftWCRotruR8kklcyfceC__p.TP1AeF0.Jt3vEVRMIkW8.0qS
 k8Psyf02k8w9NEHhYc99bFrFrre2W4yK.dv1Muntw.mD3lLxIGSqO.fxQSnANqXb5KpSsqRpJqI4
 ennmNGbbeH1aCoRmF_hILGkNcAaxRq9KBXfgooFeGF_59GLqOobj79oB.1Xk_97uxOgxL1vyjdje
 haxB9LjpJAYs31lQrV_bu68.SmP3bufeP9JY.59T0MAZK6YsTAOBszLYndhugQH_thqgxaQp5tJP
 MtdQfodt_lJqI.Ir.i3JtD_5NYldCvKt2wwsFlTQCBC2FEtzpbNa92ChvSpFE3jEG_EgFCzfCLDC
 YMQg03mcTuY_Pni9oMEL0sCyvojbembSshAHBaL6mXo8J_EcnKTMxCA.srAQbsb4EHoZ6MO2KeT_
 gKTq6IjKz2OX8AdnzX2b6Kofs0wCoGjB7DCNdEw2EmdbHyBz1mKZrGl3SwFbP5MIT90SsvUv0o4s
 hg9JlBIZXF.phWQ3c66HeXY0TGSM85IkrtLRz.xie96i0eSGBL_AF.WOvYmnICwRZJcEyMnroeIh
 XPjTGluG1dItClJb8yiaTgNnfo7VbRQEa3XUhbbNA7YgPDpHzRRpPGHxjp1npncVvtzTjlseFLHg
 hbbViQRgG58Kbe_bQGbH3By4EtG1Tok.169HEcb9r8u1cPzNcZSMu9jJVVzR6hrDX92ycxVyiuGq
 xVh_zJTeku9rieKbXe17jMMEydLQU7A--
X-Sonic-MF: <slow_speed@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Tue, 29 Jun 2021 14:52:45 +0000
Received: by kubenode509.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 87b6d56f351e7f22036d88ab423306b4;
          Tue, 29 Jun 2021 14:52:41 +0000 (UTC)
Subject: Re: Reload IPtables
To:     "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Cc:     netfilter-devel@vger.kernel.org
References: <08f069e3-914f-204a-dfd6-a56271ec1e55.ref@att.net>
 <08f069e3-914f-204a-dfd6-a56271ec1e55@att.net>
 <4ac5ff0d-4c6f-c963-f2c5-29154e0df24b@hajes.org>
 <6430a511-9cb0-183d-ed25-553b5835fa6a@att.net>
 <877683bf-6ea4-ca61-ba41-5347877d3216@thelounge.net>
 <d2156e5b-2be9-c0cf-7f5b-aaf8b81769f8@att.net>
 <f5314629-8a08-3b5f-cfad-53bf13483ec3@hajes.org>
 <adc28927-724f-2cdb-ca6a-ff39be8de3ba@thelounge.net>
 <96559e16-e3a6-cefd-6183-1b47f31b9345@hajes.org>
 <16b55f10-5171-590f-f9d2-209cfaa7555d@thelounge.net>
 <54e70d0a-0398-16e4-a79e-ec96a8203b22@tana.it>
 <f0daea91-4d12-1605-e6df-e7f95ba18cac@thelounge.net>
 <8395d083-022b-f6f7-b2d3-e2a83b48c48a@tana.it>
 <20210628104310.61bd287ff147a59b12e23533@plushkava.net>
 <20210628220241.64f9af54@playground>
From:   slow_speed@att.net
Message-ID: <c78c189b-efad-0d20-fa9e-989c828d7067@att.net>
Date:   Tue, 29 Jun 2021 10:52:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210628220241.64f9af54@playground>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.18469 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 6/28/21 10:02 PM, Neal P. Murphy wrote:
> On Mon, 28 Jun 2021 10:43:10 +0100
> Kerin Millar <kfm@plushkava.net> wrote:
> 
>> Now you benefit from atomicity (the rules will either be committed at once, in full, or not at all) and proper error handling (the exit status value of iptables-restore is meaningful and acted upon). Further, should you prefer to indent the body of the heredoc, you may write <<-EOF, though only leading tab characters will be stripped out.
>>
> 
> [minor digression]
> 
> Is iptables-restore truly atomic in *all* cases? Some years ago, I found through experimentation that some rules were 'lost' when restoring more than 25 000 rules. If I placed a COMMIT every 20 000 rules or so, then all rules would be properly loaded. I think COMMITs break atomicity. I tested with 100k to 1M rules. I was comparing the efficiency of iptables-restore with another tool that read from STDIN; the other tool was about 5% more efficient.
> 

Please explain why you might have so many rules.  My server is pushing 
it at a dozen.
