From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [NETFILTER]: xt_conntrack: add port and direction matching
Date: Thu, 17 Jan 2008 14:52:18 +0100
Message-ID: <478F5D92.3040404@netfilter.org>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128050.14900@fbirervta.pbzchgretzou.qr> <477E487D.8000901@trash.net> <478C573D.2060401@trash.net> <Pine.LNX.4.64.0801151328040.30034@fbirervta.pbzchgretzou.qr> <478CBF6D.3060309@trash.net> <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40939 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751757AbYAQNuB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:50:01 -0500
In-Reply-To: <Pine.LNX.4.64.0801161857300.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +	switch (tuple->dst.protonum) {
> +	case IPPROTO_TCP:
> +	case IPPROTO_UDP:
> +	case IPPROTO_SCTP:

Minor nitpick. Add IPPROTO_UDPLITE.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
