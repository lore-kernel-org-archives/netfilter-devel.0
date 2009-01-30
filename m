From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: libxtables: prefix names and order it #1
Date: Fri, 30 Jan 2009 05:52:44 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901300550390.23947@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901271500200.13940@fbirervta.pbzchgretzou.qr>  <1233065970.13279.74.camel@dogo.mojatatu.com> <1233066572.13279.76.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52883 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbZA3Ewq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2009 23:52:46 -0500
In-Reply-To: <1233066572.13279.76.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-01-27 15:29, jamal wrote:
>On Tue, 2009-01-27 at 09:19 -0500, jamal wrote:
>
>> Ok, no problem - let me know when you are done.
>
>BTW, it would be nice if you commit those patches to the git tree and i
>pull them.

The proposed changes are at

	git://dev.medozas.de/iptables master

	92 files changed, 1063 insertions(+), 1135 deletions(-)

They are pretty broad, but repetitive.

There are a few functions left. Like exit_error, which still has ties
to the origin program (iptables, ip6tables), to do option freeing for
example. Have not yet thought of how to resolve that. Ideas welcome.
