From: jamal <hadi@cyberus.ca>
Subject: Re: [PATCH] libxtables: Add exit_error cb to xtables_globals
Date: Tue, 10 Feb 2009 12:01:23 -0500
Message-ID: <1234285283.20903.64.camel@dogo.mojatatu.com>
References: <1234236584.20903.31.camel@dogo.mojatatu.com>
	 <alpine.LSU.2.00.0902101717390.24089@fbirervta.pbzchgretzou.qr>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:50906 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZBJRDT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:03:19 -0500
Received: by ewy14 with SMTP id 14so3156505ewy.13
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2009 09:03:17 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0902101717390.24089@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2009-02-10 at 17:20 +0100, Jan Engelhardt wrote:

> 
> I looked through this and wondered - how do we want to model
> the ownership of the structure?
> 
> For example, one possibility (which you did) is that
> xtables_globals is defined in the program, and libxtables
> takes a pointer/reference to it during xtables_set_params.
> 
> Alternatively, libxtables could collect the globals in
> a struct (defined in xtables.c), and programs override
> it at will, either by setting variables directly,
> like it is currently done with xtables_program_name,
> or by use of a function;
> 
> Any preference on which approach to choose?

I think you could go either way.

>From a personal taste perspective (and maybe usability as
defined by someone who is lazy like myself), I would pick the 
option that makes me write the smallest amount of code - which 
is what the current patches provide.
[I dislike libcurl for example which makes me call all
sorts of set() functions].

I would even wanna go further:
unify xtables_init(), xtables_set_nfproto() and 
xtables_set_params() i.e just have the app call
xtables_init(&myxtables_params). If the app only declares
myxtables_params and sets nothing in it, then xtables_init()
provides it with the default parameters (sort of what i do with
basic_exit_error)


cheers,
jamal

