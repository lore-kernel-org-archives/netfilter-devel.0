From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [libnftnl PATCH 1/8] chain: Break the line properly when printing
 out the chain
Date: Tue, 11 Feb 2014 13:29:32 +0200
Message-ID: <52FA099C.8020805@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com> <1392115608-6733-2-git-send-email-tomasz.bursztyka@linux.intel.com> <20140211105843.GA4299@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:4101 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaBKL3j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 06:29:39 -0500
In-Reply-To: <20140211105843.GA4299@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 11/02/2014 12:58, Pablo Neira Ayuso a =E9crit :
>> As when a rule is printed etc... It fixes a bug in iptables when
>> >printing out the chain in debug mode.
> All the example in libnftnl rely on that missing \n, including nft.
> Better fix this in iptables-compat?

I followed what have been done in src/rule.c

Actually a fix has to be done there as well:

removing the '\n' in "%s %s %s %"PRIu64" %"PRIu64"\n"

and changing the expression printing loop so:
it does "\n  [ %s " and "]" instead of "]\n".

And fixing iptables-compat so it add the relevant '\n' at the end.

Tomasz
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
