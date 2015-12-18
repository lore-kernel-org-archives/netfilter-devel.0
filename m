From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_mark: Add translation to nft
Date: Fri, 18 Dec 2015 22:40:13 +0100
Message-ID: <20151218214013.GA26438@salvia>
References: <20151206033214.GA5939@gmail.com>
 <20151209132600.GA29450@salvia>
 <CAKHNQQF3XFhMJaoi8gBLOeGTLJjxncPQ-s9Tke3nC0FNoGVJjg@mail.gmail.com>
 <CAKHNQQEtTZ0Hg57VcgrOTaFZww-3T8nc8+P1WFq5Ms4Ap2qmbg@mail.gmail.com>
 <CAKHNQQGSbN8QQru8PB9GntbGGBKLT7v3VRYnjhEObshs7qKPcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36267 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965197AbbLRVrB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Dec 2015 16:47:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 02C9317F1A9
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 22:46:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AF0ABDA811
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 22:46:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5B15ED1DB4
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Dec 2015 22:46:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQGSbN8QQru8PB9GntbGGBKLT7v3VRYnjhEObshs7qKPcg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 18, 2015 at 09:39:49AM +0530, Shivani Bhardwaj wrote:
> Hi,
>=20
> So far, I've been able to figure out that the problem is arising
> because of wrong return value by the function xlate of
> xtables-translate. This return value is further dependent on a
> function cb() which I am not able to understand. Could you please hel=
p
> me with this?

I'm getting this here:

libxt_mark.c:116:1: warning: =E2=80=98mark_mt_xlate_print=E2=80=99 defi=
ned but not
used [-Wunused-function]
 mark_mt_xlate_print(const struct xt_entry_match *match,
 ^
libxt_mark.c:140:1: warning: =E2=80=98mark_xlate_print=E2=80=99 defined=
 but not used
[-Wunused-function]
 mark_xlate_print(const struct xt_entry_match *match,
 ^

These two functions are unused, so there is some problem there.

But, anyway after applying you patch I can see:

# iptables-translate -I INPUT -m mark --mark 10
nft insert rule ip filter INPUT ct mark  & xa counter=20

So this kind of work already.

Be careful about shared libraries for extensions (here I have them at
/usr/lib/xtables/*.so or maybe you have it at /usr/local/lib/xtables)

The thing is that probably you have an older iptables installation, so
you iptables-translate binary refers to the old .so file which has no
translation.

So make sure you don't have several .so in your setup, probably that's
the problem.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
