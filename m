Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817E3C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Mar 2022 07:52:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiCXHyL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Mar 2022 03:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348748AbiCXHyJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Mar 2022 03:54:09 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBD699686;
        Thu, 24 Mar 2022 00:52:37 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id dr20so7439057ejc.6;
        Thu, 24 Mar 2022 00:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KLLeo4LszK5mKM9gvwQ86fwffJ82iNHFXheNCrZ6MPg=;
        b=Sel29aJsin6ZEl/540tmDB3k1Byhb+vLDP1FQ1yHxDmY4x0JKE34Kp8a35oNkCnDKe
         MrM705EirsIJGb6Odikxl2znuQ9y9ZK0Df4BaIpj+fGiKPrRXm+pls/CmVCqXtdSVM1H
         sw1upCwo/6burE1iFsf1RYSwy+LevH7IDZkNM99dGHn3I7jSl2/z71ITZ3dQ4/Y2g/ta
         +tIz3jvGED5FudInLIpKq8hoB0FDQN5gWqlWJg2lFya2skDLqguVGA+moTdvAKFXdoor
         NNlYODkDIHQI0wqWmfESr6qJcDuNZoO9U/eML4Du84eRvYufIfbBvWPsb57tVrNfIyXN
         yLnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=KLLeo4LszK5mKM9gvwQ86fwffJ82iNHFXheNCrZ6MPg=;
        b=nT1jdasWhrDHjlgSh63yjrX/ED8SSIj+IUQDDbbQjalLLf1ax2t6IJOwa0ZOoPOzmQ
         fkdfim2SwDFr2eFgnVU/EpAkRmoqgqCOGfclYHMoRc0Fi6Rug8N1bhC+04qb2JqIQ/hc
         wvAoxpz6CABRmXm1x3n8Ol9X7/wMhK8wZuKSEVpKxnMhAPL/YRSKvI4bfFs5DIwBaDm7
         HkRm1ksZ6xCTzwiX4+PwQ4kgJ9LRjIJDx/wCSjDog1YzhTmQH8AQqfe4euVjIyzvEdtM
         Le35EoNwJZUTXldbPbYPooO7OJ2mV4UocPxVzSdBNe82Ia1jxgsjGESgTQ1zv1wJy7Hq
         Ru6g==
X-Gm-Message-State: AOAM531j3RSro9DmfrcWPXQ3yX2rrUJJRG7KIIJG+5w/8TW3UtQhDyTa
        e55vPHU5ayt3iz1dW6CZjUbduOCQDJE=
X-Google-Smtp-Source: ABdhPJwZsrmJE7Cle7eIPigFkCOJqSSUsWccm/nJLtJXtVTFLDn9LSGvul4FFQNZZuIpPiwY7gY7Hw==
X-Received: by 2002:a17:906:7945:b0:6e0:19:5f7c with SMTP id l5-20020a170906794500b006e000195f7cmr4476264ejo.458.1648108355425;
        Thu, 24 Mar 2022 00:52:35 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id m19-20020a1709062ad300b006d1289becc7sm793033eje.167.2022.03.24.00.52.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Mar 2022 00:52:34 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: bug report and future request 
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <04C4931B-553E-4FEA-85D4-B3E186520EE5@gmail.com>
Date:   Thu, 24 Mar 2022 09:52:33 +0200
Cc:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FE0EEED5-48C9-412F-81BA-0028818C2EE8@gmail.com>
References: <AE6DAC96-EC3E-43C9-A95A-B230842DD7B1@gmail.com>
 <20220321212750.GB24574@breakpoint.cc>
 <4B0C8933-C7D8-49BA-B7F2-29625B0865C1@gmail.com>
 <20220322103203.GD24574@breakpoint.cc>
 <04C4931B-553E-4FEA-85D4-B3E186520EE5@gmail.com>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

HI all

One more after switch to all rule and use only nft (remove qdisc from =
kernel config, and remove all iptables tables) in perf top see =
nft_do_chain is up to 3-4% on all core and if isolate with perf top -C X =
i see on one core is up to 10-15% :

  31.26%  [pppoe]                  [k] pppoe_rcv
     3.19%  [nf_tables]              [k] nft_do_chain
     2.46%  [kernel]                 [k] =
__netif_receive_skb_core.constprop.0
     2.18%  [kernel]                 [k] fib_table_lookup
     2.07%  [i40e]                   [k] i40e_clean_rx_irq
     1.51%  [kernel]                 [k] __dev_queue_xmit
     1.23%  [kernel]                 [k] dev_queue_xmit_nit
     1.23%  [nf_conntrack]           [k] __nf_conntrack_find_get.isra.0
     1.20%  [kernel]                 [k] __copy_skb_header
     1.19%  [kernel]                 [k] kmem_cache_free
     1.17%  [kernel]                 [k] skb_release_data
     1.06%  [nf_tables]              [k] nft_rhash_lookup=20


Is have options to optimize work of nft rule set.

and for second question is it posible to make work this limiter in flow =
table rule set :=20

#table inet filter {
#        flowtable fastnat {
#                hook ingress priority 0; devices =3D { eth0, eth1 };
#        }
#
#        chain forward {
#                type filter hook forward priority 0; policy accept;
#                ip protocol { tcp , udp } flow offload @fastnat;
#        }
#}

Like this and if have options to make devices list dynamic to add device =
automatic or to add device with *=20
If limiter work in flow table will make offload traffic and reduce cpu =
load

Martin

> On 23 Mar 2022, at 0:55, Martin Zaharinov <micron10@gmail.com> wrote:
>=20
> Hi Florian
>=20
> yes now work perfect
> i will test with 1-4k ips to see performance vs qdisc or iptables.
>=20
> for second offload question:
>=20
> is it possible to make limiter work in offload mode and ia it posible =
to add dynamic interface like ppp* or vlan* or other type.
>=20
>=20
>=20
> P.S.
>=20
> thanks for fast reply for first part!
>=20
> P.S.2=20
>=20
> resend mail to netfilter group
>=20
> Martin
>=20
>> On 22 Mar 2022, at 12:32, Florian Westphal <fw@strlen.de> wrote:
>>=20
>> Martin Zaharinov <micron10@gmail.com> wrote:
>>> Hi Florian
>>>=20
>>> Look good this config but not work after set user not limit by =
speed.
>>=20
>> Works for me.  Before:
>> [ ID] Interval           Transfer     Bitrate         Retr
>> [  5]   0.00-10.00  sec  5.09 GBytes  4.37 Gbits/sec    0 sender
>> [  5]   0.00-10.00  sec  5.08 GBytes  4.36 Gbits/sec receiver
>>=20
>> After:
>> [  5]   0.00-10.00  sec  62.9 MBytes  52.7 Mbits/sec    0 sender
>> [  5]   0.00-10.00  sec  59.8 MBytes  50.1 Mbits/sec receiver
>>=20
>>> table inet nft-qos-static {
>>>       set limit_ul {
>>>               typeof ip saddr
>>>               flags dynamic
>>>               elements =3D { 10.0.0.1 limit rate over 5 =
mbytes/second burst 6000 kbytes, 10.0.0.254 limit rate over 12 =
mbytes/second burst 6000 kbytes }
>>>       }
>>> 		set limit_dl {
>>>               typeof ip saddr
>>>               flags dynamic
>>>               elements =3D { 10.0.0.1 limit rate over 5 =
mbytes/second burst 6000 kbytes, 10.0.0.254 limit rate over 12 =
mbytes/second burst 6000 kbytes }
>>>      }
>>>=20
>>>       chain upload {
>>> 			type filter hook postrouting priority filter; =
policy accept;
>>> 			ip saddr @limit_ul drop
>>>       }
>>> 		chain download {
>>> 			type filter hook prerouting priority filter; =
policy accept;
>>> 			ip saddr @limit_dl drop
>>> 		}
>>=20
>> daddr?
>>=20
>>> With this config user with ip 10.0.0.1 not limited to 5 mbytes ,=20
>>=20
>>> When back to this config :
>>>=20
>>> table inet nft-qos-static {
>>> 	chain upload {
>>> 		type filter hook postrouting priority filter; policy =
accept;
>>> 		ip saddr 10.0.0.1 limit rate over 5 mbytes/second burst =
6000 kbytes drop
>>> 	}
>>>=20
>>> 	chain download {
>>> 		type filter hook prerouting priority filter; policy =
accept;
>>> 		ip daddr 10.0.0.1 limit rate over 5 mbytes/second burst =
6000 kbytes drop
>> 	           ~~~~~
>=20

