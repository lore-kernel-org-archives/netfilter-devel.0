From: Patrick PIGNOL <patrick.pignol@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: report error if stateful obj's
 name is truncated
Date: Sat, 21 Jan 2017 12:47:51 +0100
Message-ID: <8b710e4c-38f1-d59c-8988-9891fba62bbb@gmail.com>
References: <1484834420-55121-1-git-send-email-zlpnobody@163.com>
 <20170119140914.GA11241@salvia>
 <CAML_gOc=0wpF9ERvvC5Vp3ncMdijrt9hOkSci1tc4tMUoR2uQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32992 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750905AbdAULry (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Jan 2017 06:47:54 -0500
Received: by mail-wm0-f67.google.com with SMTP id r144so13129518wme.0
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jan 2017 03:47:53 -0800 (PST)
In-Reply-To: <CAML_gOc=0wpF9ERvvC5Vp3ncMdijrt9hOkSci1tc4tMUoR2uQg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Le 19/01/2017 à 15:41, Liping Zhang a écrit :
> The nft table name's size is limited at this place:
> static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
>          [NFTA_TABLE_NAME] = { .type = NLA_STRING,
>                                                     .len =
> NFT_TABLE_MAXNAMELEN - 1 },
>
> If NFTA_CHAIN_TABLE's size exceeded 31, nf_tables_table_lookup will
> fail eventually.
>
Why ? :


typedef unsigned short __u16; // minimum MaxValue = 65535

  /*
*  <------- NLA_HDRLEN ------> <-- NLA_ALIGN(payload)-->
* +---------------------+- - -+- - - - - - - - - -+- - -+
* |        Header       | Pad |     Payload     | Pad |
* |   (struct nlattr)   | ing |                        | ing |
* +---------------------+- - -+- - - - - - - - - -+- - -+
*  <-------------- nlattr->nla_len --------------> // Payload minimum 
MaxValue = 65535 - (at least)32 = 65503
*/

struct nlattr {
         __u16           nla_len;
         __u16           nla_type;
};

#define NFT_SET_MAXNAMELEN      32  // <- Why 32 ? Why not 65535 or 65503
