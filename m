From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [lnf-log PATCHv2 3/3] nlmsg: add printf function in conjunction
 with libmnl
Date: Wed, 26 Aug 2015 21:01:54 +0200
Message-ID: <20150826190154.GA18376@salvia>
References: <20150810081342.GB25169@gmail.com>
 <20150810081752.GD25169@gmail.com>
 <20150818060409.GA3062@salvia>
 <20150819071103.GA15064@gmail.com>
 <20150819220403.GA5220@salvia>
 <20150820072645.GA3916@gmail.com>
 <20150820181613.GA4227@salvia>
 <20150821002306.GA11754@gmail.com>
 <20150821003033.GD11754@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50665 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbbHZSzg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Aug 2015 14:55:36 -0400
Content-Disposition: inline
In-Reply-To: <20150821003033.GD11754@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 21, 2015 at 09:30:33AM +0900, Ken-ichirou MATSUZAWA wrote:
> To printf nflog netlink message in XML, nflog_snprintf_xml can be
> used after converting nflog nlattrs to nflog_data, but we should not
> have any code that mixes both new and old, which handles nflog_data,
> APIs. The idea is to deprecate libnfnetlink and any client of that
> library at some point, that will take quite time though since we'll
> have to mark those old interfaces as deprecated.

this one also applied, thanks.

