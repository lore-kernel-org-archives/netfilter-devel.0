From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Wed, 18 Jan 2017 00:39:04 -0500
Message-ID: <20170118053904.GE18214@madcap2.tricolour.ca>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
 <3051394.ngqbNXneNL@x2>
 <20170117161228.GS3087@madcap2.tricolour.ca>
 <CAHC9VhT7aR1hHfDyU-r6QXTV92rEx1x8s7cH66bzh8FiDv24eQ@mail.gmail.com>
 <20170118023429.GW3087@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>
To: Paul Moore <paul@paul-moore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750947AbdARFjL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 00:39:11 -0500
Content-Disposition: inline
In-Reply-To: <20170118023429.GW3087@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-01-17 21:34, Richard Guy Briggs wrote:
> On 2017-01-17 15:17, Paul Moore wrote:
> > On Tue, Jan 17, 2017 at 11:12 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2017-01-17 08:55, Steve Grubb wrote:
> > >> On Tuesday, January 17, 2017 12:25:51 AM EST Richard Guy Briggs wrote:
> > 
> > ...
> > 
> > >> > Ones that are not so straightforward:
> > >> > - "secmark" depends on a kernel config setting, so should it always be
> > >> >   present but "(none)" if that kernel feature is compiled out?
> > >>
> > >> If this is selinux related, I'd treat it the same way that we do subj
> > >> everywhere else.
> > >
> > > Ok.
> > 
> > To be clear, a packet's secmark should be recorded via a dedicated
> > field, e.g. "secmark", and not use the "subj" field (it isn't a
> > subject label in the traditional sense).
> 
> I think Steve was talking about if, when or where to include that field,
> not what its label is.

In this case it is an "obj=" field, but since it is part of the LSM,
each one has its own fields.

> > paul moore
> 
> - RGB

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
