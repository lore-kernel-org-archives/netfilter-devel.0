From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/3] iptables-edit: iptables-edit: adds --table to
 iptables-restore
Date: Wed, 7 Nov 2007 17:41:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711071737520.20249@fbirervta.pbzchgretzou.qr>
References: <472E6041.7090601@endian.com> <Pine.LNX.4.64.0711071150390.1982@fbirervta.pbzchgretzou.qr>
 <4731C14F.50607@endian.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39369 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbXKGQli (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:41:38 -0500
In-Reply-To: <4731C14F.50607@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 7 2007 14:44, Peter Warasin wrote:
>Jan Engelhardt wrote:
>
>> |adds --table to iptables-restore which allows to restore only the
>> |supplied table
>
>This patch is already applied. Should i fix your suggestions or leave it
>as it is?

Try changing, it's just the Subversion thing.

>> |-	while ((c = getopt_long(argc, argv, "bcvthnM:", options, NULL)) != -1) {
>> |+	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
>> 
>> Use -t instead, that would go in line with the -t from iptables.
>
>-t is already --test, therefore i used -T
>I suggest changing --test to --dry-run (-d), so -t will turn free for
>--table, what do you think?

Is a dry-run option really needed? iptables-edit does not commit
any tables to the kernel, so the program in itself is already
in dry-run mode. If the resulting ruleset that iptables-edit will
generate is not loadable (e.g. xt_somemodule missing), then
iptables-restore should turn that up when trying to load the
bogus ruleset.

