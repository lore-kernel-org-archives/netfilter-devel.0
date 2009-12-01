From: Patrick McHardy <kaber@trash.net>
Subject: Re: nflog_bind_group() question
Date: Tue, 01 Dec 2009 11:49:10 +0100
Message-ID: <4B14F4A6.1040306@trash.net>
References: <30defc5b0912010244i385afe45gac6bc521c19a75da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	vuurmuur-devel@lists.sourceforge.net
To: Fred Leeflang <fredl@dutchie.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40536 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZLAKtH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:49:07 -0500
In-Reply-To: <30defc5b0912010244i385afe45gac6bc521c19a75da@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fred Leeflang wrote:
> Hi devs,
> 
> We've recently implemented NFLOG support in vuurmuur, I've written an
> article on the effort here
> http://wordpress.3dn.nl/2009/11/25/iptabes-nflog-support-in-vuurmuur/
> 
> I'm curious about something I found out in the process. I've had
> ulogd2 running alongside vuurmuur for a while and configured it to
> listen to a specific nflog-group. When I had ulogd2 running I would
> not be able to run vuurmuur_log which also listens to an nflog-group.
> It took me a while to realize that it would not work because of having
> ulogd2 running and both trying to listen to the SAME nflog-group.
> 
> Does this mean that it's not possible for two applications at the same
> time to get netfilter_log messages from the same nflog-group?

That is correct, nfnetlink_log uses unicast messages to the process
bound to the group. I'd also prefer if we had used multicast messaging,
but that can't be easily changed now.
