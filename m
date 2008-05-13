From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 4/4] iptables --list chain rulenum
Date: Tue, 13 May 2008 12:56:25 +0200
Message-ID: <482973D9.7070909@trash.net>
References: <1210617624.3442.45.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38594 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbYEMK5D (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 06:57:03 -0400
In-Reply-To: <1210617624.3442.45.camel@henriknordstrom.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Henrik Nordstrom wrote:
> Excent --list (and --list-rules) to allow selection of a single rule
> number
> 
> iptables --list INPUT 4
> iptables --list-rules INPUT 4
> 
> list rule number 4 in INPUT.

Applied, thanks.
