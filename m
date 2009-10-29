From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] iptables: fix undersized deletion mask creation
Date: Thu, 29 Oct 2009 23:55:51 +0100
Message-ID: <4AEA1D77.3020706@trash.net>
References: <1256839878-24358-1-git-send-email-jengelh@medozas.de> <1256839878-24358-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61346 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbZJ2Wzy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2009 18:55:54 -0400
In-Reply-To: <1256839878-24358-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The mask created for the -D rulespec is simply too small.
> xtables_targets points to whatever target has last been loaded, so
> xtables_targets->size is quite almost wrong, as we need to use the
> size of the target for the specific rule that is about to be deleted.
> 
> This bug existed ever since iptables history is tracked, and requires
> certain circumstances to be visible, where the deletion operation is
> one. Furthermore, multiple userspace target extensions must have been
> loaded, and a target B whose .size is smaller than the target A of
> the rule we are about to delete must have been loaded more recently
> than target A. The minimal testcase is (rule 60007 gets wrongly
> removed)
> 
> 	*nat
> 	-F
> 	-X
> 	-A POSTROUTING -p udp -j SNAT --to 192.168.1.1:60007
> 	-A POSTROUTING -p udp -j SNAT --to 192.168.1.1:60008
> 	-A POSTROUTING -p udp -j CONNMARK --set-mark 0
> 	-D POSTROUTING -p udp -j SNAT --to 192.168.1.1:60008
> 	COMMIT
> 
> References: http://bugzilla.netfilter.org/show_bug.cgi?id=606

Very nice catch, thanks Jan.
