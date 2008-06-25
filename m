From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/8 v2] textsearch: fix finite state machine textsearch
 for handling case insensitive searching
Date: Wed, 25 Jun 2008 13:02:12 +0200
Message-ID: <486225B4.8050208@trash.net>
References: <> <1214389503-21385-1-git-send-email-joonwpark81@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Joonwoo Park <joonwpark81@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49981 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043AbYFYLCS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:02:18 -0400
In-Reply-To: <1214389503-21385-1-git-send-email-joonwpark81@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joonwoo Park wrote:
> For fsm text search, handle case insensitive parameter as -EINVAL.

Applied.
