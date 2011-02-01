From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 00/13] ipset kernel patches v3
Date: Tue, 01 Feb 2011 18:42:44 +0100
Message-ID: <4D484614.1000400@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46550 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab1BARmr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 12:42:47 -0500
In-Reply-To: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 23:52, schrieb Jozsef Kadlecsik:
> Hi,
> 
> Here follows the updated ipset kernel patches. The list of changes compared
> to the previous one:
> 
> - Separate ipset errnos completely from system ones and bump protocol
>   version
> - Use better error codes in xt_set.c
> - Fix sparse warning about shadowed definition
> - bitmap:ip type: flavour specific adt functions
> - bitmap:port type: flavour specific adt functions
> - Move the type specificic attribute validation to the core
> - Use vzalloc() instead of __vmalloc()
> - Use meaningful error messages in xt_set.c
> - Constified attribute cannot be written
> - Send (N)ACK at dumping only when NLM_F_ACK is set
> - Correct the error codes: use ENOENT and EMSGSIZE

A few more issues I just noticed:

- There are still a bunch of purely kernel internal files
  in include/linux/netfilter/ipset which should be moved to
  include/net/netfilter/ipset.

- Some other include files contain mostly kernel internal
  things, I'd prefer to split those and move the kernel internal
  portions to include/net/netfilter/ipvs as well.

- The headers are not installed. I'm currently adding proper
  Kbuild entries, will send over for review in a few minutes.
