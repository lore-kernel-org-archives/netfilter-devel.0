From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH] Fix IPv6 packet parsing.
Date: Mon, 02 Jun 2008 15:50:44 +0200
Message-ID: <4843FAB4.2050109@netfilter.org>
References: <1211574847-14768-1-git-send-email-eric@inl.fr> <484338FE.8070507@netfilter.org> <20080602123253.GD30308@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45112 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751837AbYFBOuw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2008 10:50:52 -0400
In-Reply-To: <20080602123253.GD30308@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
>> I'll test this a bit along this week, any help appreciated. We can
>> prepare the first release of 2.0.0-rc series soon. If my mind serves
>> well, configuration file reload is still pending.
> 
> Yes, reload is still missing.
> 
> By the way, a new libnetfilter_conntrack release will be needed before
> ulogd2 rc. Latest libnetfilter_conntrack git is needed to have ulogd2
> compile.

I think that you have missed the release that I have done two days ago
[1] ? :-)

http://marc.info/?l=netfilter-devel&m=121225147116142&w=2

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
