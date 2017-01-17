From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Tue, 17 Jan 2017 13:35:30 -0500
Message-ID: <2235067.DTYE1rL4RS@x2>
References: <20170117052551.GQ3087@madcap2.tricolour.ca> <20170117161228.GS3087@madcap2.tricolour.ca> <20170117162943.GT3087@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37132 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbdAQSf3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 13:35:29 -0500
In-Reply-To: <20170117162943.GT3087@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday, January 17, 2017 11:29:43 AM EST Richard Guy Briggs wrote:
> On 2017-01-17 11:12, Richard Guy Briggs wrote:
> > On 2017-01-17 08:55, Steve Grubb wrote:
> > > On Tuesday, January 17, 2017 12:25:51 AM EST Richard Guy Briggs wrote:
> > > > I'm just starting to look at the normalization of AUDIT_NETFILTER_PKT
> > > > event messages and it is not quite as straightforward as I had
> > > > expected.
> > > > 
> > > > It is being tracked here:
> > > > 	https://github.com/linux-audit/audit-kernel/issues/11
> > > > 
> > > > and refers to a previous posting from Mr. Dash Four from four years
> > > > ago
> > > > to which there was no reply.
> > > > 
> > > > The example given in the tracker above for "frag=" is fairly
> > > > straightforward, but digging more, there are a number of others that
> > > > are
> > > > not quite so obvious.
> > > > 
> > > > How many different combinations of fields is acceptable?  Can we
> > > > create
> > > > new message types for each one, or is there a preferred way to
> > > > indicate
> > > > which sub-type it is other than implicit from the arguments given?
> > > 
> > > That would be preferential to swinging fields in and out. But we also
> > > don't
> > > want to add too many new types. If two protocols look almost identical,
> > > I'd
> > > try to coerce them to be the same. If adding 2 new types solves the
> > > problem
> > > just do it. If it takes 10, then maybe we should understand why.
> > 
> > Ok, I'll have a go at mapping some out and see where we end up...
> > 
> > > > Others that are straightforward:
> > > > - The first "truncated=" gets pulled in with "0".
> > > > 
> > > > - "mark=" gets pulled in with "0".
> > > > 
> > > > Ones that are not so straightforward:
> > > > - "secmark" depends on a kernel config setting, so should it always be
> > > > 
> > > >   present but "(none)" if that kernel feature is compiled out?
> > > 
> > > If this is selinux related, I'd treat it the same way that we do subj
> > > everywhere else.
> > 
> > Ok.
> > 
> > > > - ARPHRD_ETHER pulls in 3 fields, I would pull them all in and set
> > > > them
> > > > 
> > > >   to "(none)" to indicate that type isn't present.
> > > 
> > > "(none)" is for character fields that have nothing. Typically we set -1
> > > for
> > > numeric fields that are unset. If numbers are expected, its going to get
> > > the strtol() treatment and "(none)" will cause a conversion error.
> > 
> > Ah, ok.  I certainly don't want to break the parser, so I'll use -1 or
> > find another way to indicate it.
> > 
> > > > - audit_ip4() and audit_ip6 share "saddr=", "daddr=", proto=", but ip4
> > > > 
> > > >   adds "ipid=", which would be set to "(none)" for ip6.
> 
> I assume that v4, v6 and mac address fields count as text?

Yes. We also use '?' in places where there is no value if that looks better.

-Steve

> > > That is numeric. -1?
> > 
> > Yup, 16-bit.  I'll make it -1.
> > 
> > > -Steve
> > > 
> > > > - audit_proto() pulls in "truncated=" again, then either "sport=" and
> > > > 
> > > >   "dport=" OR "icmptype=" and "icmpcode=".
> > > > 
> > > > If all fields are pulled in, we end up adding 10 fields beyond a
> > > > standard well-formed packet, and 15 beyond a truncated packet.
> > > > 
> > > > Note: In the cases of "mark" and "secmark" both are unions.  In the
> > > > case of
> > > > "mark", I don't see a problem since it isn't conditionally compiled
> > > > out
> > > > and won't be mis-interpreted.  In the case of "secmark=", it could be
> > > > mis-interpreted as offload_fwd_mark if that field is even compiled in,
> > > > but that would be addressed in the compiler directive...
> > > > 
> > > > 
> > > > One last question: Does anyone have a test suite that can generate any
> > > > or all of these types of packets?
> > > > 
> > > > 
> > > > Thanks!
> > > > 
> > > > 
> > > > - RGB
> > 
> > - RGB
> > 
> > --
> > Richard Guy Briggs <rgb@redhat.com>
> > Kernel Security Engineering, Base Operating Systems, Red Hat
> > Remote, Ottawa, Canada
> > Voice: +1.647.777.2635, Internal: (81) 32635
> 
> - RGB
> 
> --
> Richard Guy Briggs <rgb@redhat.com>
> Kernel Security Engineering, Base Operating Systems, Red Hat
> Remote, Ottawa, Canada
> Voice: +1.647.777.2635, Internal: (81) 32635


