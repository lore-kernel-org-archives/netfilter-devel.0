From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: xt_HMARK: endian bugs
Date: Mon, 14 May 2012 21:13:55 +0200
Message-ID: <1337022835.8512.610.camel@edumazet-glaptop>
References: <1337002943-16374-1-git-send-email-hans.schillstrom@ericsson.com>
	 <201205141809.18174.hans.schillstrom@ericsson.com>
	 <1337012674.8512.589.camel@edumazet-glaptop>
	 <201205141951.36692.hans.schillstrom@ericsson.com>
	 <alpine.DEB.2.00.1205142032570.28548@blackhole.kfki.hu>
	 <20120514190211.GC14897@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Hans Schillstrom <hans.schillstrom@ericsson.com>,
	Jan Engelhardt <jengelh@inai.de>,
	"kaber@trash.net" <kaber@trash.net>,
	"jengelh@medozas.de" <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
	"hans@schillstrom.com" <hans@schillstrom.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59388 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521Ab2ENTOB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 May 2012 15:14:01 -0400
In-Reply-To: <20120514190211.GC14897@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2012-05-14 at 21:02 +0200, Pablo Neira Ayuso wrote:

> IIRC, Hans wants that, in case you have a cluster composed of system
> with different endianess, the hash mark calculated will be the same
> in both systems. To ensure that the distribution is consistent with
> independency of the endianess.

Then jhash() must be audited to make sure its output is OK with this
requirement.





