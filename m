From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: RAWNAT kernel crash
Date: Thu, 10 Jul 2008 11:22:25 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807101119180.27323@fbirervta.pbzchgretzou.qr>
References: <4875D2DC.9040107@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Manu <manuprivat@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34971 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYGJJW0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:22:26 -0400
In-Reply-To: <4875D2DC.9040107@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-07-10 11:14, Manu wrote:

> hello together,
>
> I did succesfully compile the RAWNAT stuff from xtables-addons with the current
> snapshot.
> I can set the following rules:
> iptables -t raw -I PREROUTING -i eth2 -s 192.168.0.123 -j RAWSNAT --to-source
> 10.0.23.2
> iptables -t rawpost -I POSTROUTING -o eth2 -d 10.0.23.2 -j RAWDNAT
> --to-destination 192.168.0.123
>
> To set the rule for table rawpost I have to change the source code in
> xt_RAWNAT.c:
> from/to:
> static bool rawnat_tg_check(const char *table, const void *entry,
> static bool rawnat_tg_check(const char *table, const void *entry,
>   const struct xt_target *target, void *targinfo, unsigned int hook_mask)
>   const struct xt_target *target, void *targinfo, unsigned int hook_mask)
> {
> {
>       if (strcmp(table, "raw") == 0 || strcmp(table, "postraw") == 0)
>       if (strcmp(table, "raw") == 0 || strcmp(table, "rawpost") == 0)
>               return true;
>               return true;
>
>       printk(KERN_ERR KBUILD_MODNAME " may only be used in the \"raw\" or "
>       printk(KERN_ERR KBUILD_MODNAME " may only be used in the \"raw\" or "
>              "\"rawpost\" table.\n");
>              "\"rawpost\" table.\n");
>       return false;
>       return false;
> }
> }

I do not see a change.

> I can set the rules but everytime I want to send traffic through the rules I
> got a system crash!?

I will investigate... I assume you do have dcd0c66 at least?

> In my kernel configuration I didn't compiled in the SECMARK stuff! Because if I
> do so my computer didn't boot! I don't know why?

I updated the RAWNAT branch to merge in master; it should not
strictly need SECMARK anymore.

> I have attached my kernel config file.
>
> kernel: 2.6.23.9
> iptables: 1.4.1.1
> gcc: 3.3
>
> If somebody knows the issue or can help to solve my problem - it would be
> greatly appreciated.

Posting the crash would be helpful.
