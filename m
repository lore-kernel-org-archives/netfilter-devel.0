From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Set default policy of chains in filter tables to DROP/ACCEPT
Date: Thu, 24 Jan 2008 15:35:40 +0100
Message-ID: <4798A23C.5030904@trash.net>
References: <1201183885868-git-send-email-panther@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Laszlo Attila Toth <panther@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44561 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbYAXOfp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:35:45 -0500
In-Reply-To: <1201183885868-git-send-email-panther@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laszlo Attila Toth wrote:
> Set the default policy of INPUT/FORWARD/OUTPUT chains of IPv4/IPv6 filter
> tables to DROP or ACCEPT in kernel configuration. It can be override by
> a module parameter (defaultdrop for IPv4 and defaultdropv6 for IPv6).


Whats the point of this? You can simply execute the corresponding
iptables commands early during boot ...
