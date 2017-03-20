From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: linux-next: build warning after merge of the netfilter-next tree
Date: Mon, 20 Mar 2017 07:00:13 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C5B0DC@IRSMSX102.ger.corp.intel.com>
References: <20170320111236.77c5a05a@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hans Liljestrand" <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        David Windsor <dwindsor@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:24830 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751153AbdCTHPM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Mar 2017 03:15:12 -0400
In-Reply-To: <20170320111236.77c5a05a@canb.auug.org.au>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Hi all,
>=20
> After merging the netfilter-next tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
>=20
> net/netfilter/nfnetlink_acct.c: In function 'nfnl_acct_try_del':
> net/netfilter/nfnetlink_acct.c:329:15: warning: unused variable 'refcount=
' [-
> Wunused-variable]
>   unsigned int refcount;
>                ^
>=20
> Introduced by commit

Ups, sorry about this, slipped through. Should I submit a fix or how do you=
 want to handle this?

Best Regards,
Elena.

>=20
>   b54ab92b84b6 ("netfilter: refcounter conversions")
>=20
> --
> Cheers,
> Stephen Rothwell
