From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next 2/2] netfilter: x_tables: fix cgroup's NF_INET_LOCAL_IN
 sk lookups
Date: Wed, 25 Mar 2015 18:27:06 +0100
Message-ID: <5512EFEA.1030808@iogearbox.net>
References: <cover.1427209409.git.daniel@iogearbox.net> <20fdc704558880831cbbaa8bba5e4855591cd4ba.1427209409.git.daniel@iogearbox.net> <20150325160300.GA3722@salvia> <5512E4A8.50900@iogearbox.net> <20150325171740.GA23660@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:52238 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbbCYR1M (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 13:27:12 -0400
In-Reply-To: <20150325171740.GA23660@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/25/2015 06:17 PM, Pablo Neira Ayuso wrote:
...
> I mean, we may get a packet from the input path while in TIME_WAIT, and
> sk will be actually a inet_timewait_sock, which has a different
> layout (no sk_classid).

Sorry, you are correct, thanks for the hint. We would actually
need to test if we deal with a full socket, iow sk_fullsock(sk).
