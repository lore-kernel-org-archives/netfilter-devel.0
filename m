From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 2/3] Make NFLOG and NFCT build conditionnal
Date: Fri, 12 Sep 2008 13:02:15 +0200
Message-ID: <48CA4C37.5000306@netfilter.org>
References: <1221166085-23435-3-git-send-email-eric@inl.fr> <48C99429.2020406@netfilter.org> <20080911221504.GC20985@ice-age> <48C99D1E.3010506@netfilter.org> <20080912065322.GD20985@ice-age>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51901 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752083AbYILLhU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Sep 2008 07:37:20 -0400
In-Reply-To: <20080912065322.GD20985@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> But, my point was not really intendend to address legacy systems. I just
> want to have something clean for people who for example want only to use NFLOG.
> That will be stupid for them to compile and install libnetfilter_conntrack
> on their system and not to use it.

Think about iptables. It has tons of matches/targets but most people 
uses very few of them. And most users use generic distro-based packaged 
versions.

Well, I'll be fine with adding an option like "--without-thing" to skip 
the compilation of NFCT, but I will not rely upon suppositions like "you 
did not installed this library, therefore I will not compile this"

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
