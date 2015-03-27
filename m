From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v2 2/2] netfilter: x_tables: fix cgroup's NF_INET_LOCAL_IN
 sk lookups
Date: Fri, 27 Mar 2015 09:40:46 +0100
Message-ID: <5515178E.1050101@iogearbox.net>
References: <cover.1427394874.git.daniel@iogearbox.net> <213b822a711fb7af77f6ecbdfbe41a079b27ddcb.1427394874.git.daniel@iogearbox.net> <20150327001408.GD3545@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:53910 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbC0Ikx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 04:40:53 -0400
In-Reply-To: <20150327001408.GD3545@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/27/2015 01:14 AM, Pablo Neira Ayuso wrote:
> On Thu, Mar 26, 2015 at 08:14:48PM +0100, Daniel Borkmann wrote:
> [...]
>> However, that as-is only partially works, i.e. it works for the case
>> of established TCP and connected UDP sockets when early demux is
>> enabled, but not for various other ingress scenarios: i) early demux
>> disabled (sysctl), ii) udp on unconnected sockets, iii) tcp and udp
>> (any kind) on localhost communications.
>
> This extension has been around since Dec 2013, I'd rather see a new
> revision that includes an option --lookup-sock.

Okay, I'm totally fine with that.

Please note, the commit I'm trying to fix is _not_ the original
xt_cgroup inclusion, but rather a00e76349f35 ("netfilter: x_tables:
allow to use cgroup match for LOCAL_IN nf hooks"), which is March
2014, fwiw.

> More comments below.
...
>> +#ifdef XT_HAVE_IPV6
>
> Please, kill this custom XT_HAVE_IPV6 and now use IS_ENABLED(NF_SOCK_IPV6)

Will do, thanks.
