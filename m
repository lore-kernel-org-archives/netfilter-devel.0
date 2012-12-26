From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 09/13] iptables: fix order of internal commands list
Date: Wed, 26 Dec 2012 15:27:46 +0100
Message-ID: <20121226142746.GA31482@1984>
References: <1356477089-13241-1-git-send-email-jengelh@inai.de>
 <1356477089-13241-10-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44852 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab2LZO1z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Dec 2012 09:27:55 -0500
Content-Disposition: inline
In-Reply-To: <1356477089-13241-10-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 26, 2012 at 12:11:25AM +0100, Jan Engelhardt wrote:
> Specifying -S on the command line would add 4096 (0x1000, 1<<12) to the
> cmd flags, but -S was in fact commands_v_options[13]. This led to a
> bogus option checking and an error message:
> 
> $ iptables -A foo -S
> iptables v1.4.14: Cannot use -E with -A

# iptables -A foo -S
iptables v1.4.17: Cannot use -S with -A

Are you hitting an old bug?
