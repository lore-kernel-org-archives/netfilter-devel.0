From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [NETFILTER][PATCH] Re: Question about the hashlimit network mask patch
Date: Wed, 26 Mar 2008 11:28:52 +0100
Message-ID: <20080326102852.GA29291@rere.qmqm.pl>
References: <47E39230.90400@icdsoft.com> <alpine.LNX.1.00.0803211404530.10642@fbirervta.pbzchgretzou.qr> <47E3E861.9090707@icdsoft.com> <alpine.LNX.1.00.0803211805340.10642@fbirervta.pbzchgretzou.qr> <47E90678.7090405@icdsoft.com> <alpine.LNX.1.10.0803260836030.22661@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rere.qmqm.pl ([86.63.132.164]:37100 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760023AbYCZK2u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:28:50 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0803260836030.22661@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 26, 2008 at 08:44:20AM +0100, Jan Engelhardt wrote:
> +		return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));

BTW, isn't this way faster:

	return a & htonl(~(~(u_int32_t)0 >> l));

 -- Michal Miroslaw
