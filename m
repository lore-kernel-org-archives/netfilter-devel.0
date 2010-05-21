From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: Any Performance benchmark on a Million conntracks
Date: Fri, 21 May 2010 11:06:36 +0800
Message-ID: <AANLkTilq025-870v_6hmTC82C_Ob2JA7tMSUDFfGgH1O@mail.gmail.com>
References: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com>
	<1274360664.4046.36.camel@edumazet-laptop> <4BF5414B.4090609@trash.net>
	<AANLkTikp7NU1cdAQHJkK9L14DsyRceaypO3ao_93raUu@mail.gmail.com>
	<1274377493.2508.4.camel@edumazet-laptop> <AANLkTimp3nxDMgetLIB-aLhxAYrsLAT00enaBy0Fe4k-@mail.gmail.com>
	<1274409281.4977.3.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anand Raj Manickam <anandrm@gmail.com>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44626 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab0EUDPI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 23:15:08 -0400
Received: by pvg3 with SMTP id 3so224410pvg.19
        for <netfilter-devel@vger.kernel.org>; Thu, 20 May 2010 20:15:07 -0700 (PDT)
In-Reply-To: <1274409281.4977.3.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 21, 2010 at 10:34 AM, Eric Dumazet <eric.dumazet@gmail.com>=
 wrote:
> Le vendredi 21 mai 2010 =C3=A0 07:43 +0800, Changli Gao a =C3=A9crit =
:
>>
>> and we have to do insertion and deletion in serial with rbtree, so
>> rbtree doesn't scales as well as hash tables for parallel processing=
,
>> if there are many insertions and deletions operations.
>>
>>
>
> Before saying such things, you should read the source code Changli,
> because you only propagate wrong information.
>
> conntrack uses a single lock, so inserts and deletes _are_ serialized=
,
> _even_ with hash table.
>

Sorry. I should add "Off Topic", as I said that for common cases, not
for conntracking.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
