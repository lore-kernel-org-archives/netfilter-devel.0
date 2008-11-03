From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: Every other char with LOG netfilter output (bug?)
Date: Mon, 3 Nov 2008 13:41:53 -0200
Message-ID: <490f1bc5.0603c00a.5277.44e5@mx.google.com>
References: <rlujt5-k63.ln1@tux.abusar.org.br>
	<49074E81.6010207@trash.net>
	<49075276.2686460a.0b00.ffff9f09@mx.google.com>
	<4907564D.5090103@trash.net>
	<49094b22.0f87460a.09d2.55b6@mx.google.com>
	<49095F02.7040104@trash.net>
	<490a671a.0687460a.3af5.40a2@mx.google.com>
	<490EF1B8.2060308@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:7605 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbYKCPl7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:41:59 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1163696qwe.37
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Nov 2008 07:41:58 -0800 (PST)
In-Reply-To: <490EF1B8.2060308@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 03 Nov 2008 13:42:32 +0100
Patrick McHardy <kaber@trash.net> wrote:

> It doesn't explain why the LOG output is corrupted, but it seems
> the hanging connections are caused by RST packets that are considered
> INVALID.
> 
> Please enable conntrack debugging by executing:
> 
> echo 255 >/proc/sys/net/netfilter/nf_conntrack_log_invalid
> 
> so we can see why these packets are considered invalid.

	Hi Patrick, problem solved. The problem was syslogd. :(

	Thanks ;)

-- 
