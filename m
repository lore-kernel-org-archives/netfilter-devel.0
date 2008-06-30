From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: POM Xtables???
Date: Mon, 30 Jun 2008 23:47:48 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806302335430.30639@fbirervta.pbzchgretzou.qr>
References: <935fab200806271054oa7c340evbf465b7a9984498b@mail.gmail.com>  <alpine.LNX.1.10.0806272003170.12725@fbirervta.pbzchgretzou.qr>  <4866F152.7030109@riverviewtech.net> <935fab200806300904rc7dc7b2kf58ab7893c3ef20a@mail.gmail.com> <486907EA.60105@trash.net>
 <Pine.LNX.4.64.0806302236070.29802@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, Dave <finalglide@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0806302236070.29802@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Monday 2008-06-30 23:11, Jozsef Kadlecsik wrote:
>
>In order to make life easier, as I apply the patches sent by Swen, 
>there'll be a new, "standalone" version of ipset, i.e. it'll be possible 
>to use it without patch-o-matic-ng.

I have been tracking ipset a bit lately, it already seems
standing alone. Would you be willing to make it available
through Xtables-addons?
A test head for inspection can be found at
	git://dev.medozas.de/xtables-addons ipset
