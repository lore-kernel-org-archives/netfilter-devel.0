From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH 2/3] nft: Generalize nft_rule_list()
 against current family
Date: Wed, 07 Aug 2013 12:02:25 +0300
Message-ID: <52020D21.3080504@linux.intel.com>
References: <1375864297-9347-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1375864297-9347-3-git-send-email-tomasz.bursztyka@linux.intel.com> <20130807090054.GB6935@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:34134 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757248Ab3HGJC3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Aug 2013 05:02:29 -0400
In-Reply-To: <20130807090054.GB6935@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

>> +const char *nft_parse_target(struct nft_rule *r, const void **targi=
nfo,
>> >+			     size_t *target_len)
>> >+{
>> >+	struct nft_rule_expr_iter *iter;
>> >+	struct nft_rule_expr *expr;
>> >+	const char *targname;
> Need targname =3D NULL, otherwise:
>
> nft-shared.c: In function =E2=80=98nft_parse_target=E2=80=99:
> nft-shared.c:289:14: warning: =E2=80=98targname=E2=80=99 may be used =
uninitialized in
> this function [-Wmaybe-uninitialized

Missed this warning, thanks for finding it.

Tomasz
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
