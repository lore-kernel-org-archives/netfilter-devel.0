Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8611CC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Mar 2022 20:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347939AbiCUUpv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239397AbiCUUpu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Mar 2022 16:45:50 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014B21EC4E;
        Mon, 21 Mar 2022 13:44:23 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id yy13so32320652ejb.2;
        Mon, 21 Mar 2022 13:44:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=sCcxXQ3JXyyUY+QKQmyB4kqCuQx/Wl1tefqbMGnUfP4=;
        b=jrdmQ3vRDmw38RvQzgh1WAbGn7EPwhZpg3JALGChC/a9Sfp0cGAcZEC/JyoBq6RGdO
         sty92u8hLeox7ILLT7axeeSLHKgNj1YD0BQl0Fnk49pOPtkw0+iWPkSparthzkPAXJFg
         ByLkvULbFAOCEBwnR6O3qRw/N39FNLgFTIcH7IjGsjgIvsfNKdrakEsDjIRFCuPTnMyf
         8IDTJkz5GiZbmjYvUfg2++gi5eSMR4dZFc+x+b8B3UsEmhuApmEYWea48W+sAvUX6RXx
         5TeuYhyhOX+4SWbqBv8IJjTualHE4Zz79//m75h25MRm5St2VeUG/eKYJbsHtfISqcBf
         0b/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=sCcxXQ3JXyyUY+QKQmyB4kqCuQx/Wl1tefqbMGnUfP4=;
        b=ZaJvqWcxAj4AOcLxhs8TjvNbC7AjQZFjRDI3cK/mEUBFYJKo/3zEQpAkAKqbVS7Ehk
         wtNAO1sdPIOKhcSgUXGfdaJu+bdNsLbA9ipEMV8XQ0ivLQ15foRMuG9ryjv9k4XV+3Xf
         GWs/O6Qa7xpTT7BJIXJ0hn2Bhycs++BnAEPyJS2WHtQxvQrH4YjfYUWrQ6xTo5rupd81
         87PqV5bnAOhBkgNdyxsO0PP5JFx35uGPSuw6o0qAelzLWVvKApE+jt7svielyXF1B7KG
         ePwiJrHiS7vBOOn7WAIpaeMkMuYawDdqogf3XeqVSwEgm52arCGTz0fG6YEvehRHuo7M
         V1pQ==
X-Gm-Message-State: AOAM533uXzRkkaEWTKOeEEo1/YfbvtVrBK/zyN5njv7qY8stw7rTm34V
        7xQ1CDWbTf358GSdF/0lOo0sPxQPrk8=
X-Google-Smtp-Source: ABdhPJyws7PD0D8ujHITjFlmj2ViCE8tQfK6gcK9iIVGT0GgxgPdDn0Ls+jg278z9weZAoc3etS1Tw==
X-Received: by 2002:a17:907:2ce3:b0:6df:b0ad:1f1a with SMTP id hz3-20020a1709072ce300b006dfb0ad1f1amr17242769ejc.392.1647895462410;
        Mon, 21 Mar 2022 13:44:22 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id i30-20020a1709067a5e00b006df6f0d3966sm7234092ejo.189.2022.03.21.13.44.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Mar 2022 13:44:22 -0700 (PDT)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: bug report and future request 
Message-Id: <AE6DAC96-EC3E-43C9-A95A-B230842DD7B1@gmail.com>
Date:   Mon, 21 Mar 2022 22:44:20 +0200
To:     Florian Westphal <fw@strlen.de>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Netfilter team

first is it posible to fix this:=20

You can delete the rule whose handle is 5 with the following command:
% nft delete rule filter output handle 5
Note: There are plans to support rule deletion by passing:
% nft delete rule filter output ip saddr 192.168.1.1 counter

but this is not yet implemented. So you'll have to use the handle to =
delete rules until that feature is implemented

This is from Docs:

=
https://wiki.nftables.org/wiki-nftables/index.php/Simple_rule_management#R=
emoving_rules


if have 1k rule

table inet nft-qos-static {
        chain upload {
                type filter hook postrouting priority filter; policy =
accept;
                ip saddr 10.0.0.9 limit rate over 12 mbytes/second burst =
50000 kbytes drop
.........
ip saddr 10.0.0.254 limit rate over 12 mbytes/second burst 50000 kbytes =
drop
        }


        chain download {
                type filter hook prerouting priority filter; policy =
accept;
                ip daddr 10.0.0.9 limit rate over 12 mbytes/second burst =
50000 kbytes drop
........
ip saddr 10.0.0.254 limit rate over 12 mbytes/second burst 50000 kbytes =
drop
        }
}

and problem is not easy to delete rule for ip 10.0.0.100 or othere in =
list .
if use handle and list all rule  for example 4k and parse handle on =
every 10-15 sec will load cpu with this.


and second:

is it posible in this rule ppp*

table inet filter {
        flowtable fastnat {
                hook ingress priority 0; devices =3D { eth0, ppp* };
        }

        chain forward {
                type filter hook forward priority 0; policy accept;
                ip protocol { tcp , udp } flow offload @fastnat;
        }
}


or vlan* , the problem is on system dynamic up vlan or ppp is auto up =
when user is connect


If there options to fix and add this options will be great,

thanks in advance

Martin.=
