From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] xtables: remove white spaces from iptables-xml manpages
Date: Mon, 10 Mar 2008 18:46:01 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803101841370.21961@fbirervta.pbzchgretzou.qr>
References: <47CF2900.2080903@yahoo.it> <Pine.LNX.4.64.0803071348140.26142@fbirervta.pbzchgretzou.qr>
 <47D191C2.4070102@netfilter.org> <47D5657F.9070007@trash.net>
 <47D56B92.9010206@yahoo.it> <47D572AB.10808@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Filippo Zangheri <filippo.zangheri@yahoo.it>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33417 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbYCJRqD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:46:03 -0400
In-Reply-To: <47D572AB.10808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 10 2008 18:40, Patrick McHardy wrote:
>
>> Just out of curiosity, may I ask you what's your opinion on using
>> Git as a version control system for Netfilter stuff? And what's your
>> opinion on switching to it?
>
> I would prefer that over SVN very much, however before we switch
> we need to set up git on the netfilter servers, install gitweb
> etc. I currently don't have time to take care of this.

You previously raised the idea of putting the repository on
git.kernel.org; not that I really care where it is at, but if you
need help setting it plus gitweb up, that is actually fairly easy.

All I needed for this host was enabling git-daemon in xinetd and
making Apache run gitweb.cgi. 'Was kinda puzzled how long it took
me to get mod_dav/authnz_svn working in comparison.

Call me if you need help ;)
