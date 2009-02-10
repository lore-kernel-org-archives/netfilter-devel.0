From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: Add exit_error cb to xtables_globals
Date: Tue, 10 Feb 2009 17:20:04 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902101717390.24089@fbirervta.pbzchgretzou.qr>
References: <1234236584.20903.31.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41212 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbZBJQUJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 11:20:09 -0500
In-Reply-To: <1234236584.20903.31.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-02-10 04:29, jamal wrote:

>Suggestion from Jan. Building up to compiling most basic app..
>

I looked through this and wondered - how do we want to model
the ownership of the structure?

For example, one possibility (which you did) is that
xtables_globals is defined in the program, and libxtables
takes a pointer/reference to it during xtables_set_params.

Alternatively, libxtables could collect the globals in
a struct (defined in xtables.c), and programs override
it at will, either by setting variables directly,
like it is currently done with xtables_program_name,
or by use of a function;

Any preference on which approach to choose?
