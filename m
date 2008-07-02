From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-2.3.2
Date: Wed, 2 Jul 2008 15:52:24 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807021551080.20393@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0807021449020.32444@blackhole.kfki.hu> <Pine.LNX.4.64.0807021536140.4958@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807021536140.4958@bizon.gios.gov.pl>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Wednesday 2008-07-02 15:37, Krzysztof Oledzki wrote:
> On Wed, 2 Jul 2008, Jozsef Kadlecsik wrote:
>
>> I'm happy to announce ipset-2.3.2. Besides cosmetic changes and cleanups,
>> this release includes the sources of both the userspace tool and the
>> kernel modules: you can install ipset wihtout patch-o-matic-ng.
>
> Is statically linking still supported?

Theoretically yes (with xtables-addons), but it is not automated as
of v1.5.4.1, so it is a hand-job modifying two kernel files (Makefile
and Kconfig) to include an .. include line to enter our directory.
