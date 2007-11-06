From: Max Kellermann <max@duempel.org>
Subject: Re: [PATCH 0/3] iptables-edit: tool to apply iptables rules to iptables-save'ed statefiles
Date: Tue, 6 Nov 2007 10:53:49 +0100
Message-ID: <20071106095349.GA19069@roonstrasse.net>
References: <472E6039.7060801@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([81.209.165.42]:40172 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750999AbXKFJxu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:53:50 -0500
Content-Disposition: inline
In-Reply-To: <472E6039.7060801@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2007/11/05 01:13, Peter Warasin <peter@endian.com> wrote:
[...]
> Most firewall scripts (for example fwbuilder, shorewall, firehole,
> etc..) work always this way:
> - They flush and remove all iptables chains
> - Apply the iptables rules successively by:
>   o Compile a shell script with an iptables rule per line
>   o Calculating the iptables rules from a configuration file on the fly.

I'm taking the chance to move some attention to my "ferm" project
(which you did not mention): ferm uses iptables-restore to install the
new rules atomically.

 http://ferm.foo-projects.org/

ferm does not do that by default (yet), because iptables versions
prior to 1.3 were too bugged for that to work properly - you have to
run "ferm --fast" to take advantage of atomical iptables-restore.

[...]
> Another advantage could be something like this:
> 
> $ iptables-restore netfilter_edited.dump && sleep 10 && \
> iptables-restore netfilter.dump
> 
> which automatically would jump back to the old ruleset if the
> administrator did something wrong and locket out himself.

This is implemented in ferm as "interactive" mode (ferm
--interactive).

Max

