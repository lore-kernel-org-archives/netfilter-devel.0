From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/8 v2] textsearch: fix Boyer-Moore algorithm for case
 insensitive searching
Date: Wed, 25 Jun 2008 12:59:04 +0200
Message-ID: <486224F8.7010807@trash.net>
References: <> <1214389498-21345-1-git-send-email-joonwpark81@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev <netdev@vger.kernel.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Joonwoo Park <joonwpark81@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49900 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbYFYK7J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:59:09 -0400
In-Reply-To: <1214389498-21345-1-git-send-email-joonwpark81@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Joonwoo Park wrote:
> Fix Boyer-Moore algorithm to have capability of case insensitive
> searching

Applied, thanks.
