From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] iptables: utils: Add bash completion
Date: Wed, 2 Mar 2016 12:34:12 +0100
Message-ID: <20160302113411.GA2068@salvia>
References: <1456412814-4580-1-git-send-email-mart.frauenlob@chello.at>
 <1456412814-4580-2-git-send-email-mart.frauenlob@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48460 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbcCBLeY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 06:34:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D21E713C0F9
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:34:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C0E61DA390
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:34:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8162FDA380
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:34:17 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1456412814-4580-2-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 25, 2016 at 04:06:53PM +0100, Mart Frauenlob wrote:
> This is a fully featured completion for ip[6]tables.
> It knows about all the basic parameters and the options of all
> targets and matches. Mandatory and exclusive options and inversion
> of options are taken care of. Protocol dependency and previously
> set values of options are also taken into account.
> Completion of option values is done whereever possible.
> Enviroment variables allow to modify completion behaviour.
> As to feed ip address from file or to turn on input validation.
> A readme file is included.
> 
> Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
> ---
>  utils/iptables_bash_completion/README.md |  290 ++++
>  utils/iptables_bash_completion/iptables  | 2426 ++++++++++++++++++++++++++++++

This is fair good amount of work, but this is also quite a bit of
new shell code to be maintained in our trees.

Moreover, I was told that, in the specific case of debian, there is a
package (bash-completion) where you place this.

So sorry, I'm not applying this.
