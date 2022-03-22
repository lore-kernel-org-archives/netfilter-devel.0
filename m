Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F76BC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Mar 2022 07:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbiCVHPv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Mar 2022 03:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237356AbiCVHPu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Mar 2022 03:15:50 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E5254BDE;
        Tue, 22 Mar 2022 00:14:21 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id b24so20498195edu.10;
        Tue, 22 Mar 2022 00:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=JJWCnTlxZp8qDZdKbx3LGy3mNzv5tFfTcaw0BpNfjho=;
        b=S4w9oNF+EvjY9E8ieXKohhVy3yM6p8sqZU08kaha3lSdG9c4wt5XXIa2Lv72fiMBWn
         zE4kp+uMRXPT2Gab7gqL15UIeKFVlwdjYUhtU9u07qjOIm/LL7Ij2RGIGFn3TgKTiLdO
         JnZUnu67N08l97MQkxuij3/gDkhKZuJyY1XnsQxUsT0RJqS4J+TlqX4iZFKV4qbXyH4Q
         kwZ+hBn0R/+1Kk/7uYhPiFfNYIulYKCKZSZ8Ps0xsYQdF8/CKK6XqCfSVYB6b0cbeuBE
         YIAwjEktq95a8mLCK5yJB/ZJG61lzSYr9DhOw+wAOn98DucIP9mD71Q1TnOy9WoUp/8Z
         yyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=JJWCnTlxZp8qDZdKbx3LGy3mNzv5tFfTcaw0BpNfjho=;
        b=5JIYvXXaS73n+eH2n9GdCy1m+SZlmSngc4WqJl7GZpfSBZVtvqXWSMyW/Q7K179RFb
         YDHfVS8l/4wqEGu/rzhje/8rmEsBr+WODDUHWn85WYsLzj2VrU9xv7BVWEkYSi9toiEi
         +6NlqF9g/LLoyVhjpCJiTW1oPL8ewDieWP5BXtqmvhcv9IWda1nSBkvQlmViqjre92wB
         0qI3qG67QVQzgQ+Cr/yVZaVi21zpkT5Ibhd5ouuRed8fTahqw4YgNmW+VtB6PzNr/anC
         NPku5bGAPoqSmXLeIFAJRYrMh7Th1gratF1YizfckSEqvJ1NcqPX/lax6A5L/U7z9Wxb
         Tn/A==
X-Gm-Message-State: AOAM533acb0fXi06wyvOuUDlmiFBqtUcDytlYHaTDEJBnka2vF2hVvHu
        aiZyZVsacSj5gGZdlq8GZ7wGGCYXbKk=
X-Google-Smtp-Source: ABdhPJw2gBf3dfx71C6Za8lM0bY6gsqyl95Gh1ylN9QG0OAj0jEhkopjfiH/qTunxLmXvUMQ1eCMEw==
X-Received: by 2002:a50:ec16:0:b0:40f:28a0:d0d6 with SMTP id g22-20020a50ec16000000b0040f28a0d0d6mr20881199edr.368.1647933260115;
        Tue, 22 Mar 2022 00:14:20 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id s4-20020a170906a18400b006db0a78bde8sm7922239ejy.87.2022.03.22.00.14.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Mar 2022 00:14:19 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: bug report and future request 
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20220321212750.GB24574@breakpoint.cc>
Date:   Tue, 22 Mar 2022 09:14:18 +0200
Cc:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4B0C8933-C7D8-49BA-B7F2-29625B0865C1@gmail.com>
References: <AE6DAC96-EC3E-43C9-A95A-B230842DD7B1@gmail.com>
 <20220321212750.GB24574@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian

Look good this config but not work after set user not limit by speed.


table inet nft-qos-static {
        set limit_ul {
                typeof ip saddr
                flags dynamic
                elements =3D { 10.0.0.1 limit rate over 5 mbytes/second =
burst 6000 kbytes, 10.0.0.254 limit rate over 12 mbytes/second burst =
6000 kbytes }
        }
		set limit_dl {
                typeof ip saddr
                flags dynamic
                elements =3D { 10.0.0.1 limit rate over 5 mbytes/second =
burst 6000 kbytes, 10.0.0.254 limit rate over 12 mbytes/second burst =
6000 kbytes }
       }

        chain upload {
			type filter hook postrouting priority filter; =
policy accept;
			ip saddr @limit_ul drop
        }
		chain download {
			type filter hook prerouting priority filter; =
policy accept;
			ip saddr @limit_dl drop
		}
}


With this config user with ip 10.0.0.1 not limited to 5 mbytes ,=20


When back to this config :

table inet nft-qos-static {
	chain upload {
		type filter hook postrouting priority filter; policy =
accept;
		ip saddr 10.0.0.1 limit rate over 5 mbytes/second burst =
6000 kbytes drop
	}

	chain download {
		type filter hook prerouting priority filter; policy =
accept;
		ip daddr 10.0.0.1 limit rate over 5 mbytes/second burst =
6000 kbytes drop
	}
}


User is limited  perfect.

may be i miss something?


Martin

> On 21 Mar 2022, at 23:27, Florian Westphal <fw@strlen.de> wrote:
>=20
> Martin Zaharinov <micron10@gmail.com> wrote:
>> if have 1k rule
>>=20
>> table inet nft-qos-static {
>>        chain upload {
>>                type filter hook postrouting priority filter; policy =
accept;
>>                ip saddr 10.0.0.9 limit rate over 12 mbytes/second =
burst 50000 kbytes drop
>> .........
>> ip saddr 10.0.0.254 limit rate over 12 mbytes/second burst 50000 =
kbytes drop
>>        }
>=20
> 1k rules? Thats insane.  Don't do that.
> There is no need for that many rules, its also super slow.
>=20
> Use a static/immutable ruleset with a named set and then add/remove =
elements from the set.
>=20
> table inet nft-qos-static {
> 	set limit_ul {
> 		typeof ip saddr
> 		flags dynamic
> 		elements =3D { 10.0.0.9 limit rate over 12 mbytes/second =
burst 50000 kbytes, 10.0.0.254 limit rate over 12 mbytes/second burst =
50000 kbytes }
> 	}
>=20
> 	chain upload {
> 		type filter hook postrouting priority filter; policy =
accept;
> 		ip saddr @limit_ul drop
> 	}
> }
>=20
> static ruleset: no need to add/delete a rule:
>=20
> nft add element inet nft-qos-static limit_ul "{ 10.1.2.4 limit rate =
over 1 mbytes/second burst 1234 kbytes  }"
> nft delete element inet nft-qos-static limit_ul "{ 10.1.2.4 limit rate =
over 1 mbytes/second burst 1234 kbytes }"
>=20
> You can add/delete multiple elements in { }, sepearate by ",".
>=20

