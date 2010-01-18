From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] netfilter: add struct xt_mtdtor_param::net
Date: Mon, 18 Jan 2010 08:27:25 +0100
Message-ID: <4B540D5D.1030203@trash.net>
References: <20100116185643.GC24605@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47816 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0ARH12 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:27:28 -0500
In-Reply-To: <20100116185643.GC24605@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Add ->net to match destructor list like ->net in constructor list.
> 
> Make sure it's set in ebtables/iptables/ip6tables, this requires to
> propagate netns up to *_unregister_table().

Applied, thanks.
