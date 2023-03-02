Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FBCAC6FA8E
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Mar 2023 11:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCBLpg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Mar 2023 06:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbjCBLpb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Mar 2023 06:45:31 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA90422023;
        Thu,  2 Mar 2023 03:45:29 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id d41-20020a05600c4c2900b003e9e066550fso1316337wmp.4;
        Thu, 02 Mar 2023 03:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677757528;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZa8ib9oZBcmfzaA/9jyEPPJTMlfkjfCoe4UWuD3H6I=;
        b=A3+aXIS9keMT8cUHsSLSmGxrZbD8WATWodsbCdjk79liTjxM+qTImqBave95nRKKiM
         Z0D+V+h7SzqToeYIQUCbMIGMIq+wecrcFAY9A8KlqZsV5Ay87zAG9DLam81PLfgWn+Lv
         55dQYz5tWn2Fom/OySxB2AKQNklKvHRlpU/ij85KPp8LBXX0dUsiyI35w+R6ghRb1soo
         fMOXNythn0i8QRXU3VEwhErTwwlO2SXeuyrAmnlogHPCfQPhpin9qE7C2rWaCiylHdPJ
         iZRNSnn7NYqNPu1biYzph3bbeMoYOBfsnuNFQxO5Hx8gcqjw//qWXlTxXZH3cGRugEh5
         YDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677757528;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fZa8ib9oZBcmfzaA/9jyEPPJTMlfkjfCoe4UWuD3H6I=;
        b=Es9P9Qxbz7YX3A/M1p8ZJghGcizUviPB5lE3U4rSGLxdNU8+SxQUbwnl7OKN6iqrcr
         rQmQ5cj3Z4F5P+rvcynAPybudIWzscqxkg3bayl2OcwYfExJBwwKyZZzWNBCKUm/TyU2
         3lhBircG6MK8CcpJ5SxTC6cLBalBcGXDYThCWk07opn2vBjRmy4KWwETEe5bvrjXoTdN
         Jgs+mdZPYauAPTlkI646HZq0x+CiwV532cJXTv6A1tEG4TNbBBpIPRYGUvNq8D1rqK/g
         6hYcmpKQQPmO/9W66a2xrC1FrfmAMDGB+eAfIJ2ydomRoTHyp7+aES9ry5Ajvb2iuk8o
         ZmYQ==
X-Gm-Message-State: AO0yUKX5jhQSygaqO+igzBQ1lcoXxoO2pawq34J0LBYcPocBeafUgYyS
        XMFIK1+4rBMKwls+Rj8c/0M=
X-Google-Smtp-Source: AK7set+xE/7scVsCXtKBGwSAaWXI47n7Aef395x0BfLIIRcrUMsNwn7mjSzjchrAOLYlJ5p4C3ldvg==
X-Received: by 2002:a05:600c:4d97:b0:3e2:589:2512 with SMTP id v23-20020a05600c4d9700b003e205892512mr7542316wmp.21.1677757528091;
        Thu, 02 Mar 2023 03:45:28 -0800 (PST)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id q14-20020a05600c46ce00b003daffc2ecdesm2867892wmo.13.2023.03.02.03.45.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Mar 2023 03:45:27 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.14\))
Subject: Re: Bug report DNAT destination not work
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20230302104337.GA23204@breakpoint.cc>
Date:   Thu, 2 Mar 2023 13:45:26 +0200
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <ABA514EB-3C64-4A16-8D07-1318FB9AB63F@gmail.com>
References: <CALidq=VJF36a6DWf8=PNahwHLJd5FKspXVJfmzK3NFCxb6zKbg@mail.gmail.com>
 <20230302104337.GA23204@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.14)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian


i recheck and libxt_DNAT.so is symlink to libxt_NAT.so


and i try :=20

iptables v1.8.9 (nf_tables)

Usage: iptables -[ACD] chain rule-specification [options]
       iptables -I chain [rulenum] rule-specification [options]
       iptables -R chain rulenum rule-specification [options]
       iptables -D chain rulenum [options]
       iptables -[LS] [chain [rulenum]] [options]
       iptables -[FZ] [chain] [options]
       iptables -[NX] chain
       iptables -E old-chain-name new-chain-name
       iptables -P chain target [options]
       iptables -h (print this help information)

Commands:
Either long or short options are allowed.
  --append  -A chain		Append to chain
  --check   -C chain		Check for the existence of a rule
  --delete  -D chain		Delete matching rule from chain
  --delete  -D chain rulenum
				Delete rule rulenum (1 =3D first) from =
chain
  --insert  -I chain [rulenum]
				Insert in chain as rulenum (default =
1=3Dfirst)
  --replace -R chain rulenum
				Replace rule rulenum (1 =3D first) in =
chain
  --list    -L [chain [rulenum]]
				List the rules in a chain or all chains
  --list-rules -S [chain [rulenum]]
				Print the rules in a chain or all chains
  --flush   -F [chain]		Delete all rules in  chain or all chains
  --zero    -Z [chain [rulenum]]
				Zero counters in chain or all chains
  --new     -N chain		Create a new user-defined chain
  --delete-chain
            -X [chain]		Delete a user-defined chain
  --policy  -P chain target
				Change policy on chain to target
  --rename-chain
            -E old-chain new-chain
				Change chain name, (moving any =
references)

Options:
    --ipv4	-4		Nothing (line is ignored by =
ip6tables-restore)
    --ipv6	-6		Error (line is ignored by =
iptables-restore)
[!] --protocol	-p proto	protocol: by number or name, eg. `tcp'
[!] --source	-s address[/mask][...]
				source specification
[!] --destination -d address[/mask][...]
				destination specification
[!] --in-interface -i input name[+]
				network interface name ([+] for =
wildcard)
 --jump	-j target
				target for rule (may load target =
extension)
  --goto      -g chain
			       jump to chain with no return
  --match	-m match
				extended match (may load extension)
  --numeric	-n		numeric output of addresses and ports
[!] --out-interface -o output name[+]
				network interface name ([+] for =
wildcard)
  --table	-t table	table to manipulate (default: `filter')
  --verbose	-v		verbose mode
  --wait	-w [seconds]	maximum wait to acquire xtables lock =
before give up
  --line-numbers		print line numbers when listing
  --exact	-x		expand numbers (display exact values)
[!] --fragment	-f		match second or further fragments only
  --modprobe=3D<command>		try to insert modules using this =
command
  --set-counters -c PKTS BYTES	set the counter during insert/append
[!] --version	-V		print package version.




and show help .

same here i test with both : iptables-nft and iptables-legacy


restore to version 1.8.8 and all is fine.

 i will try to rebuild and recheck if same is happen will update you.


m.

> On 2 Mar 2023, at 12:43, Florian Westphal <fw@strlen.de> wrote:
>=20
> Martin Zaharinov <micron10@gmail.com> wrote:
>> iptables -t nat -A PREROUTING -d 100.91.1.238/32 -i bond0 -p tcp =
--dport
>> 7878 -j DNAT --to-destination 10.240.241.99:7878
>> iptables v1.8.9 (legacy): unknown option "--to-destination"
>> Try `iptables -h' or 'iptables --help' for more information.
>=20
> Looks like a problem with your iptables installation which can't find
> libxt_DNAT.so?  In v1.8.9 this should be a symlink to libxt_NAT.so.
>=20
> If you run 'iptables -j DNAT --help' and it doesn't say
>=20
> "DNAT target options:" at the end then it very much looks like a
> problem with your iptables installation and not the kernel.
>=20
>> try with kernel 6.1.11 6.1.12 6.1.13
>=20
> Tested iptables-nft and iptables-legacy on 1.8.9 with kernel 6.1.14, =
no problems.
>=20
> There were no significant kernel changes in this area that I know of =
in
> 6.1 either.

