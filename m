From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xtables: remove white spaces from iptables-xml manpages
Date: Mon, 10 Mar 2008 19:20:38 +0100
Message-ID: <47D57BF6.3040205@trash.net>
References: <47CF2900.2080903@yahoo.it> <Pine.LNX.4.64.0803071348140.26142@fbirervta.pbzchgretzou.qr> <47D191C2.4070102@netfilter.org> <47D5657F.9070007@trash.net> <47D56B92.9010206@yahoo.it> <47D572AB.10808@trash.net> <Pine.LNX.4.64.0803101841370.21961@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Filippo Zangheri <filippo.zangheri@yahoo.it>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep11-int.chello.at ([62.179.121.31]:63316 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYCJSUk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:20:40 -0400
In-Reply-To: <Pine.LNX.4.64.0803101841370.21961@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Mar 10 2008 18:40, Patrick McHardy wrote:
>>> Just out of curiosity, may I ask you what's your opinion on using
>>> Git as a version control system for Netfilter stuff? And what's your
>>> opinion on switching to it?
>> I would prefer that over SVN very much, however before we switch
>> we need to set up git on the netfilter servers, install gitweb
>> etc. I currently don't have time to take care of this.
> 
> You previously raised the idea of putting the repository on
> git.kernel.org; not that I really care where it is at, but if you
> need help setting it plus gitweb up, that is actually fairly easy.


Moving to kernel.org would require to get an account there for
all netfilter developers. Its probably easier to keep it on
netfilter.org.

I know that gitweb is pretty easy to set up, I'm a bit afraid
to touch the netfilter servers though (at least while Harald is
on vacation) since they contain a pretty f*cked up genfoo
installation with debian running in a chroot.

> 
> All I needed for this host was enabling git-daemon in xinetd and
> making Apache run gitweb.cgi. 'Was kinda puzzled how long it took
> me to get mod_dav/authnz_svn working in comparison.
> 
> Call me if you need help ;)

I'll get back to you if I do :)


