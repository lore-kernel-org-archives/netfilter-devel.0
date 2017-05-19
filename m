From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 1/1] iptables: Fix crash on malformed iptables-restore
Date: Fri, 19 May 2017 12:38:25 +0200
Message-ID: <20170519103825.GC28091@breakpoint.cc>
References: <1495187664-7807-1-git-send-email-ojford@gmail.com>
 <20170519100410.GB28091@breakpoint.cc>
 <CAGMVOdu7K-e2t9eU03er+GguG3WYHFwcxR68H+S+Ra6PQok+Yg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Oliver Ford <ojford@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59580 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755521AbdESKjJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 06:39:09 -0400
Content-Disposition: inline
In-Reply-To: <CAGMVOdu7K-e2t9eU03er+GguG3WYHFwcxR68H+S+Ra6PQok+Yg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oliver Ford <ojford@gmail.com> wrote:
> On Fri, May 19, 2017 at 11:04 AM, Florian Westphal <fw@strlen.de> wrote:
> > Oliver Ford <ojford@gmail.com> wrote:
> >> Filter a beginning '--t'. Because the getopt_long function allows abbreviations,
> >> any parameter beginning with '--t' will be treated as '--table'.
> >
> > No, thats not correct:
> > --t is treated as --table.
> > --tfoo is an invalid option.
> > --ttl is ttl.
> >
> > So this:
> >
> >> +                             || !strncmp(param_buffer, "--t", 3)) {
> >>                               xtables_error(PARAMETER_PROBLEM,
> >> +                                     "The -t option (seen in line %u) cannot be "
> >> +                                     "used in ip6tables-restore.\n", line);
> >
> > .. rejects rules like
> >
> > -A INPUT -m ttl --ttl 32
> 
> Would strncmp(param_buffer, "--ta", 4) work? I don't think there are
> any options that begin with --ta other than --table.

That won't catch '--t'.

It will also add trouble later if any module adds an option like --tap,
--tail, --target, etc.

Whats wrong with:

if ((param_buffer[0] == '-' && param_buffer[1] != '-' &&
     strchr(param_buffer, 't') ||
     (!strncmp(param_buffer, "--t", 3) &&
      !strncmp(param_buffer, "--table", strlen(param_buffer)))) {

?
