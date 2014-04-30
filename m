From: Paul Robert Marino <prmarino1@gmail.com>
Subject: Re: keepalived scripts
Date: Wed, 30 Apr 2014 15:19:27 -0400
Message-ID: <CAPJdpdC5b-_+JgQpG4nM4K8sgNWbuHk21=dtsCH2c7++EdxX6A@mail.gmail.com>
References: <CAPJdpdA0BfDu4nKLFZd45Dc6W4TFxz7KG0_7jn23RaWzw9sSZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:62964 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165AbaD3TT2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:19:28 -0400
Received: by mail-oa0-f48.google.com with SMTP id i4so1780783oah.21
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Apr 2014 12:19:27 -0700 (PDT)
In-Reply-To: <CAPJdpdA0BfDu4nKLFZd45Dc6W4TFxz7KG0_7jn23RaWzw9sSZg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

wow crickets so does this mean no one wants my help on this lol


On Sun, Apr 27, 2014 at 5:07 PM, Paul Robert Marino <prmarino1@gmail.com> wrote:
> hello every one
>
> I am new to the list but I have been working professionally building
> custom mission critical HA netfilters based firewalls on and off for
> approximately a decade (I remember the days when conntrak tools was
> more of a proof of concept alpha which took a number of kernel patches
> via patch-o-matic and some which were not in patch-o-matic yet).
>
> I have noticed three things in the TODO for conntrak tools 1.4.2 which
> I believe I could be extremely helpful with.
>
>  [ ] improve shell scripts for keepalived/heartbeat: *really* important
>  [ ] add scripts to use the floating priority feature in keepalived to avoid
>      premature take over.
> [ ] study better keepalived transitions
>
>
> I have been extremely active on the keepalived list for a few years
> and have helped many people with best practices with their
> configurations and scripts.
> I am also painfully well aware that most of the howto documents for
> keepalived are nearly a decade out of date. The only really good
> documentation for keepalived is here
> https://github.com/acassen/keepalived/blob/master/doc/keepalived.conf.SYNOPSIS
> but many of the users do not know that.
>
> My employer has mandated that any non industry specific scripts to
> manage open source tools should be submitted either upstream or posted
> on a community site under the GPL as part of the peer review process.
>
>
> I was just about to post my scripts and guidelines and example
> configurations on github but now seeing this in the TODO I think I may
> be able to help and full fill my employers excellent mandate.
> if some one can please point me to a couple of things.
>
> 1) Any detailed documents or discussions on what you are exactly
> looking for the scripts to do.
>
> 2) most of my current scripts are in bash but many of them I intend to
> rewrite or supplement some of them with Perl in the near future;
> because I would like to add some more intelligence to them than can
> easily be achieved in a shell script?
> Would that be a problem or would you like the scripts to deal only
> with making them work with just bash?
> One example of where I would like some logic added from Perl is I
> would like to read the configuration and do things like skip the cache
> sync step if you are using "DisableExternalCache On' in FTFW mode.
>
> 3) I can look this up my self but If any one can send me links to the
> patch submission procedures and any code style guidelines for the
> project it would be very helpful.
