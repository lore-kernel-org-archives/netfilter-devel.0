Return-Path: <SRS0=n9X8=WO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1036BC3A589
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Aug 2019 14:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D93E820851
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Aug 2019 14:33:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfHROd0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Aug 2019 10:33:26 -0400
Received: from mail-lf1-f47.google.com ([209.85.167.47]:38464 "EHLO
        mail-lf1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfHROd0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Aug 2019 10:33:26 -0400
Received: by mail-lf1-f47.google.com with SMTP id h28so7127993lfj.5
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Aug 2019 07:33:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aUhDlUgSGKb4Cvo5Kx8LCqZ+As59v7MrcgKLx6EMrNA=;
        b=Oaw/1Be6a5WvCMwejl+6WHZDl8FFdPIDYBBUhDmX0Wy4O6+kECWNgYkH0Rp3zmbSUY
         3BHdUuBOb/4RIkx0hM4M5Qy/qyTURbr3/6zeIbiGmFgI3cCqJgeq746UkBmlFHPlv/Ht
         xpeBZNr7Vy6rkI5uOCFjjEj7NC/MtVCPPBRTl3+KhhcnThDJ/0N0i4pOyt4jC2bSe02H
         kJ2gQbHf24e4Co7SHet/LKWgFM3Aw4DtRCfeJGQ3lBJu7Qd9Ve8N1scQqjT3wigDk1Yg
         xvcT2LSJ1uoHB6De59UqFpe6nijsFnUWGnDj8gS58cQqZMpJd/Zn+yWle+HiQw7hGEnp
         khzw==
X-Gm-Message-State: APjAAAUlGrqw71K/TqeRPGeFrIwTBOLpGMSd+TKLBllFrmP8b9nFOwxh
        6qei4b0e7Oxmi4s/eOTrkVTCLTv9EldmUQ==
X-Google-Smtp-Source: APXvYqy1BkoUtvY9BboitD8CPutmCu8X+nro+sYbeIg5LsHYjqDmLV4wzkWE+L05gb0QoCEREEWd8g==
X-Received: by 2002:ac2:5c42:: with SMTP id s2mr10214802lfp.61.1566138803569;
        Sun, 18 Aug 2019 07:33:23 -0700 (PDT)
Received: from ?IPv6:2001:6b0:5:1959:c67f:99bf:8dbf:6b9c? ([2001:6b0:5:1959:c67f:99bf:8dbf:6b9c])
        by smtp.gmail.com with ESMTPSA id r21sm1889106lfi.32.2019.08.18.07.33.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Aug 2019 07:33:22 -0700 (PDT)
Subject: Re: [PATCH nftables 0/8] add typeof keyword
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190816144241.11469-1-fw@strlen.de>
 <20190817102351.x2s2vj5hgvsi5vak@salvia>
 <20190817205554.iq7rfmvwzcugfmzc@breakpoint.cc>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Openpgp: preference=signencrypt
Autocrypt: addr=arturo@netfilter.org; keydata=
 mQINBFD+Z5kBEADBJXuDQP41sQ/ANmzCCR/joRBgunGhAMnXgS1IlJe7NdX5yZ7+dOM8Lhe3
 UmZF6wYT/+ZA/NQ0XeXTlzyiuCJF0Fms/01huYfzNydx4StSO+/bpRvbrN0MNU1xQYKES9Ap
 v/ZjIO8F7Y4VIi/RoeJYFOVDpnOUAB9h9TSRNFR1KRL7OBFiGfd3YuIwPG1bymGt5CIRzi07
 GYV3Vpp8aiuoAyl6cGxahnxtO1nvOj6Nv+2j+kWnOsRxoXx5s5Gnh5zhdiN0MooztXpVQOS/
 zdTzJhnPpvhc7qac+0D0GdV1EL8ydaqbyFbm6xG/TlJp96w0ql2SEeW5zIrAa+Nu6pEMqK+q
 tT7sttRvecfr48wKVcbP57hsE7Cffmd4Sr4gNf5sE+1N09eHCZKPQaHyN3JRgJBbX1YZ0KPa
 FfUvGfehxA5BfDnJuVqhJ/aK6at6wWOdFMit2DH5rklpapBoux8CJ9HYKFHbwj60C4s1umU3
 FdpRfgI3KDzKYic6h2xGNrCfu7eO3x93ONAVQ9amGSDDY07SgO/ubx/t3jSvo3LDYrfAGmR0
 E2OlS94jOUoZWAoTRHOCyFJukFvliGu1OX6NBtDn4q3w42flBjFSGyPPfDUybXNvpmu3jUAe
 DwTVgDsrFIhsrQK83o/L4JjHzQDSzr32lVC0DyW7Bs2/it7qEwARAQABtC5BcnR1cm8gQm9y
 cmVybyBHb256YWxleiA8YXJ0dXJvQG5ldGZpbHRlci5vcmc+iQJOBBMBCgA4FiEE3ZhhqyPc
 MzOJLgepaOcTmB0VFfgFAlnbf4oCGwMFCwkIBwMFFQoJCAsFFgIDAQACHgECF4AACgkQaOcT
 mB0VFfi+xQ//b4TByucfsJn9rF6Y5gSpk3g3ztxT6y4LNRHR5zQR86n5GW6OXTrF1FzWcPgb
 g9h81onxrLYCCHEvXcwWG6jGBPanW/Kq8qotZ78joXjSObdnJ3JW3VRdtpwP5Y4d9UrB7eSc
 dnobVD3pNNSJItNHsJY555lcmuiJE+M8nmiEkvmfb5aqrDgCdstAUCrp/lBwl8Hb6UvT4IX8
 VPZE/b5OJHH1aV46RbInSp9X/UzaME4v+Yu9YBDrHDupl2gqnKBXYuMW0va5WTe9VoLRLUVq
 QYoXWXTZTbL7syybn/uaPjj8zTZPhkfWapkvF540pfNuuY+dQuwQKFIThreDKpVBAhxRf1Hg
 XbP4xP5vX6eRTS4j+F+98m3oYb3DJ5vHJlKrxf55rLG0z3/eJVEgYmTy4bDKqEYSX0djZ5eL
 8aRr5Uc9t3wySNr/mMBg8uYFirvtaiHwKRT8/kKcfyocQHMsXn3vlaLfaBpPu9YDko96PhEL
 5jmraNV21qQRguCCU2sbw3Tf5rCbHZZWGyvivvB9SL9dOnSXurPfvIydiGyXThmdPK6iW5Xp
 v9Gig5mvP944K4BSQJE1epeygJTFexhb3jOtuHPLFF0ajKyY+qm84Xz2AOq+HfzTmfXzSiTx
 /5GoegzZJV3zh1pMH5wlZQ2+eZUpEC5R9uMOGrpCdSyHsBC5Ag0EUP5nmQEQAKGi1l6t/HTn
 r0Et+EFNxVinDgS/RFgZIoUElFERhCFLspLAeYSbiA7LJzWk+ba/0LXQSPWSmRfu2egP6R+z
 4EV0TZE/HNp/rJi6k2PcuBb0WDwKaEQWIhfbmdM0cvURr9QWFBMy+Ehxq/4TrSXqBN2xmgk4
 aZVro+czobalGjpuSF+JRI/FQgHgpyOweuXMAW5O0QrC9BUq/yU/zKpVMeXdO3Jc0pk82Rx/
 Qy0bbxQzEp6jRWqVsJmG3x06PRxeX9YLa9/nRMsRiRbT1sgR9mmqV8FQg2op09rc7nF9B36T
 jZNu6KRhsCcHhykMPAz+ZJMMSgi4p9dumhyYSRX/vBU7wAxq40IegTZiDGnoEKMf4grOR0Vt
 NBBNQmWUneRzm22P5mwL5bt1PNPZG7Fyo0lKgbkgX5CMgVcLfCxyTeCOvIKy73oJ/Nf2o5S1
 GcHfQaWxPbHO0Vrk4ZhR0FoewC2vwKAv+ytwskMmROIRoJIK6DmK0Ljqid/q0IE8UX4sZY90
 wK1YgxK2ie+VamOWUt6FUg91aMPOq2KKt8h4PJ7evPgB1z8jdFwd9K7QJDAJ6W0L5QFof+FK
 EgMtppumttzC95d13x15DTUSg1ScHcnMTnznsud3a+OX9XnaU6E9W4dzZRvujvVTann2rKoA
 qaRD/3F7MOkkTnGJGMGAI1YPABEBAAGJAh8EGAECAAkFAlD+Z5kCGwwACgkQaOcTmB0VFfhl
 zg/+IDM1i4QG5oZeyBPAJhcCkkrF/GjU/ZiwtPy4VdgnQ0aselKY51b5x5v7s9aKRYl0UruV
 d52JpYgNLpICsi8ASwYaAnKaPSIkQP0S7ISAH1JQy/to3k7dsCVpob591dlvxbwpuPzub+oG
 KIngqDdG/kfvUMpSGDaIZrROb/3BiN/HAqJNkzSCKMg6M7EBbvg35mMIRFL6wo8iV7qK62sE
 /W6MjpV2qJaBAFL0ToExL26KUkcGZGmgPo1somT9tn7Jt1uVsKWpwgS4A/DeOnsBEuUBNNbW
 HWHRxk/aO98Yuu5sXv2ucBcOeRW9WIdUbPiWFs+Zfa0vHZFV9AshaN3NrWCvVLPb0P9Oiq2p
 MhUHa4T0UiAbzQoUWxcVm7EpA402HZMCiKtNYetum61UI/h2o9PDDpahyyPZ27fqb9CId4X0
 pMwJFsrgrpeJeyxdmazIweEHtQ6/VdRUXcpX26Ra98anHjtRMCsDRsi8Tk1tf7p5XDCG+66W
 /rJNIF3K5uGoI9ikF00swEWL0yTWvv3rvD0OiVOuptrUNHPbxACHzlw4UGVqvAxSvFIoXUOd
 BzQBnObBvPcu14uTb5C19hUP4xwOsds5BlYlUdV4IJjufE71Xz56DDV8h8pV4d6UY5MlLcfk
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
Message-ID: <8d3401fd-8855-2b2a-6d02-b3331984acbb@netfilter.org>
Date:   Sun, 18 Aug 2019 16:33:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190817205554.iq7rfmvwzcugfmzc@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 8/17/19 10:55 PM, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> I know I sent a RFC using typeof(), I wonder if you could just use the
>> selector instead, it's a bit of a lot of type typeof() . typeof()
>> probably.
>>
>> So this is left as this:
>>
>>         type osf name
>>
>> in concatenations, like this:
>>
>>         nft add set ip filter allowed "{ type ip daddr . tcp dport; }"
>>
>> Probably I would ask my sysadmin friends what they think.
> 
> Yes, please do, it would be good to get a non-developer perspective.
> 
> I'm very used to things like sizeof(), so typeof() felt natural to me.
> 
> Might be very un-intuitive for non-developers though, so it would be
> good to get outside perspective.
> 

From my point of view, this is a rather advanced operation. As long as it is
properly documented, I don't see any problem with `typeof()`.

Also, just `typeof` would work of course. Up to you.

Thanks for working on this!
