From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFNETLINK answers: No such file or directory
Date: Thu, 19 Jun 2008 13:09:53 +0200
Message-ID: <485A3E81.5070100@netfilter.org>
References: <7b0a40830806181538s40efbd70s66aec17d5c04933@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Adelson O. Junior" <jroliv@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from delay-bv.club-internet.fr ([194.158.96.171]:48744 "EHLO
	delay-bv.club-internet.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbYFSLaT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:30:19 -0400
Received: from relay-cv.club-internet.fr (relay-cv.cs.clubint.net [172.16.1.59])
	by delay-bv.club-internet.fr (Postfix) with ESMTP id 8C6EF65FB89
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Jun 2008 13:12:55 +0200 (CEST)
In-Reply-To: <7b0a40830806181538s40efbd70s66aec17d5c04933@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adelson O. Junior wrote:
> Hi netfiltel mail list,
> it's my first time here.
> 
> My question is:
> I'm trying to delete a entry in the conntrack and an Error is shown:
> 
> "NFNETLINK answers: No such file or directory"
> 
> I did a "small" search on the Internet, mail list and I saw that this
> is a bug and is already fixed.
> Can you tell if this is true, and if is, what the version of
> libnfnetlink, libnetfilter_conntrack or
> conntrack packets (and witch of them have a problem) that the bug is fixed?

Which version of the tools are you using? It seems to me that you're
using a pretty old one. Please see:

http://www.netfilter.org/news.html#2008-05-31

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
