From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: POM Xtables???
Date: Tue, 1 Jul 2008 13:19:05 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807011243350.12878@fbirervta.pbzchgretzou.qr>
References: <935fab200806271054oa7c340evbf465b7a9984498b@mail.gmail.com>  <alpine.LNX.1.10.0806272003170.12725@fbirervta.pbzchgretzou.qr>  <4866F152.7030109@riverviewtech.net> <935fab200806300904rc7dc7b2kf58ab7893c3ef20a@mail.gmail.com> <486907EA.60105@trash.net>
 <Pine.LNX.4.64.0806302236070.29802@blackhole.kfki.hu> <alpine.LNX.1.10.0806302335430.30639@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0807011143570.30394@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, Dave <finalglide@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37281 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYGALTI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:19:08 -0400
In-Reply-To: <Pine.LNX.4.64.0807011143570.30394@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-07-01 12:00, Jozsef Kadlecsik wrote:
>On Mon, 30 Jun 2008, Jan Engelhardt wrote:
>> On Monday 2008-06-30 23:11, Jozsef Kadlecsik wrote:
>> >
>> >In order to make life easier, as I apply the patches sent by Swen, 
>> >there'll be a new, "standalone" version of ipset, i.e. it'll be possible 
>> >to use it without patch-o-matic-ng.
>> 
>> I have been tracking ipset a bit lately, it already seems
>> standing alone. Would you be willing to make it available
>> through Xtables-addons?
>> A test head for inspection can be found at
>> 	git://dev.medozas.de/xtables-addons ipset
>
>The iptables match and target for ipset are in the iptables source tree, 

Well that won't impact is positively nor negatively. It has always
been that way, and whether people get libipt_{SET,set} through
iptables or the ipset tarball - it would not matter.

>so that part is totally independent from pom-ng and supported by iptables, 
>out of the box. As ipset is IPv4-only, there's no way to create an xtables
>variant of the match and the target :-).

Just because something is limited to IPv4 does not mean it is
not 'x' ('x' as in xtables). It is all just names, and getting it
under one unified hut is a good thing. In fact, onnnnnnnnce (;-)
I get around to submit the next patchsets, we will have xt modules
that have neither IPv4 nor IPv6 components.

>The source of the 'ipset' binary, which is totally independent from 
>iptables or xtables, is currently in svn, but we can move it to git 
>anytime. I don't really see what would be the benefit in adding ipset to 
>xtables-addons, sorry. But thank you the offer!

Benefits?
- removing 73% of all #ifdef kludges from *.c (the kernel files)
- less tarballs for users to build
- autoconf for the binary :-P
