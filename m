From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NFCT_Q_UPDATE and IPv6
Date: Mon, 15 Oct 2007 17:18:48 +0200
Message-ID: <471384D8.9070205@netfilter.org>
References: <OF38CFDD8B.3B74F76F-ONC125736B.0053E9D0-C125736B.0055898A@mindspeed.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: laurent.brando@mindspeed.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42406 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764453AbXJOPQU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Oct 2007 11:16:20 -0400
In-Reply-To: <OF38CFDD8B.3B74F76F-ONC125736B.0053E9D0-C125736B.0055898A@mindspeed.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

laurent.brando@mindspeed.com wrote:
> I'm facing some issues trying to update UDP/TCP timeout attribut of an 
> existing Ipv6 conntrack. 
> 
> It looks like call to nfct_query(ct_handler, NFCT_Q_UPDATE, ct) never 
> returns and my application thread
> gets killed.
> 
> I'm about to put some debug after the call to nfct_query , but I would 
> like to know if any of you is aware of such
> problem or  similar issue. 
> 
> Also, any proposal to narrow down the issue in an efficient way would be 
> appreciated.
> 
> I'm using linux 2.6.21 + libnfnetlink 0.0.30 + libnetfilter_conntrack 
> 0.0.81.

Any update on this report?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
