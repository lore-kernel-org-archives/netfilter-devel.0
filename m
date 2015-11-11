From: Phil Whineray <phil@firehol.org>
Subject: Re: [PATCH] Expose x_tables /proc entries as 0444 not 0440
Date: Wed, 11 Nov 2015 19:35:39 +0000
Message-ID: <20151111193539.GA2751@compaq.slightly-cracked.com>
References: <20151107074939.GA4003@compaq.slightly-cracked.com>
 <20151111165026.GA20549@salvia>
 <20151111184052.GA26909@breakpoint.cc>
 <alpine.LSU.2.20.1511111945170.32360@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36168 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbKKTfr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 14:35:47 -0500
Received: by wmww144 with SMTP id w144so172823591wmw.1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 11:35:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1511111945170.32360@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 11, 2015 at 07:48:11PM +0100, Jan Engelhardt wrote:
> On Wednesday 2015-11-11 19:40, Florian Westphal wrote:
> >Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >> > Hiding the contents from non-root users does not achieve anything
> >> > practical. Possible values are well-known and the specifics can
> >> > be inferred from a list of loaded modules on most systems.
> 
> Conversely, an administrator could just load all modules to give a false 
> impression. Since the adversary can in turn expect it, he knows as 
> little as before. In particular, containerized environments will have it 
> such that many modules are loaded, but each container still has their 
> own ruleset.
> So yeah, hiding the contents is not going to achieve anything - nor is 
> showing. (I am concurring here with the other respondents.)

Sorry - I've gotten confused about who thinks what exactly. I hope
the below isn't wasting everyone's time.

Unhiding /proc/ip_tables_names content achieves something specific: it
is used by iptables-save to determine what it should write out (in
the absence of a specific table being asked for, which I believe is
the norm).

I currently have a workaround using a horrific series of bind mounts
which substitutes in a normal file with the values iptables-save expects.

Two alternates on the table are:

- change ownership of the file in the namespace (wherein a user runs
  "unshare -U -r -n cat /proc/net/ip_tables_names" to do the same as
  "cat /proc/net/ip_tables_names" with 0444 perms, so not adding much
  unless unprivileged namespaces are disabled.
  
- try to do something with capabilities (I'd need to research this)

Given /proc/modules is 0444 and the observation that loaded != used
I don't think any significant information is leaked by the patch. I
don't mind having a stab at an alternate implementation but is it worth
it?
