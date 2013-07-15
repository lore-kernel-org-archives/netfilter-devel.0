From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [0/29] nfacct changes and additions
Date: Mon, 15 Jul 2013 14:36:36 +0200
Message-ID: <20130715123636.GA20949@localhost>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Michael Zintakis <michael.zintakis@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33377 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755608Ab3GOMgl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 08:36:41 -0400
Content-Disposition: inline
In-Reply-To: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm going to review several of your patches from this email to avoid
spamming the mailing list. I will reply some of them from the original
mail as my comments need some context.

This big batch contains patches for many different things, which is
not a good practise. Please, split patchsets into logical pieces, and
send them progressively.

On Wed, Jul 10, 2013 at 07:24:58PM +0100, Michael Zintakis wrote:
> The following patch set fixes bugs and introduces a variety of new features
> to the 3 nfacct components: kernel, libnetfilter_acct and nfacct executable.
> 
> All of the patches need to be applied in the order specified in this patch
> set (1-29) as they are interdependent. The full list of bugfixes and
> features added for each component are:

[kernel 1/29] bugfix: pkts/bytes need to be specified simultaneously

As Florian mentioned, the kernel validates that we don't crash on
incorrect configurations. We don't care if what you load does not
makes sense from the user perspective.

[kernel 2/29] bugfix: restore pkts/bytes counters in NLM_F_REPLACE

We already discussed this. You can atomically dump and reset counters
via the GET command with the NLM_F_DUMP flag set. Restoring counters
is allowed, but for unused rules. In case the system just started up,
you have to make sure that counters are restored via nfacct before
they are used by the rules.

[libnetfilter_acct 3/29] bugfix: correct xml name parsing
[libnetfilter_acct 4/29] bugfix: correct (plain) name parsing

Will reply to this in a separated email.

[nfacct 5/29] bugfix: prevent 0-sized parameter being accepted

I don't see what situation you're trying to catch with this patch.

[nfacct 6/29] bugfix: prevent 0-sized nfacct name being accepted

We already have a patch to validate this from the kernel, it returns
-EINVAL.

[nfacct 7/29] code-refactoring changes to the "command menu"

Will reply in separated email.

[nfacct 8/29] add 2 new options: "replace" and "flush"
[libnetfilter_acct 9/29] add *_SAVE template allowing save/restore

For 8/29 and 9/29, same reply as for 2/29.

[libnetfilter_acct 10/29] add *_BONLY template to show bytes-only
[libnetfilter_acct 11/29] add variable width and on-the-fly formatting
[nfacct 12/29] add variable width and on-the-fly number formatting
[nfacct 13/29] add new "save" and correct existing "restore" commands
[nfacct 14/29] add sort option to the "list" command
[nfacct 15/29] add "show bytes" option to "list" and "get" commands

>From 10/29 to 15/29, I will reply to this in separated emails as I
need the source code context for my comments.

[kernel 16/29] add permanent byte/packet format capability to nfacct

>From 16/29 to 29/29 this requires kernel changes that cannot get
into mainstream, the arguments you provided to get this mainstream are
bogus:

* From the memory side, this is adding new fields that are not used in
  the packet path, they only have a meaning from user-space.

* You mention that it's more secure to put this in the kernel. That's
  wrong since that provides a false feeling of security: Anyone could
  write a netlink socket to mangle those counters with your replace
  feature.

[libnetfilter_acct 17/29] add *permanent* number formatting support
[nfacct 18/29] add permanent number formatting to nfacct objects
[kernel 19/29] add byte threshold capability to nfacct
[libnetfilter_acct 20/29] add byte threshold capability support
[nfacct 21/29] add byte threshold capabilities to nfacct objects
[libnetfilter_acct 22/29] add *_EXTENDED template support
[nfacct 23/29] add "show extended" option to "list" and "get" commands
[kernel 24/29] add packets and bytes mark capability to nfacct
[libnetfilter_acct 25/29] add packets/bytes mark capability support
[nfacct 26/29] add setmark and clrmark to "get" and "list" commands
[libnetfilter_acct 27/29] add *_MONLY template support
[nfacct 28/29] add "show marks" option to "list" and "get" commands
[nfacct 29/29] change man page to describe all new features

Regards.
