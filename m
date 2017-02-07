From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH] audit: normalize NETFILTER_PKT
Date: Tue, 7 Feb 2017 16:22:31 -0500
Message-ID: <20170207212231.GG26850@madcap2.tricolour.ca>
References: <e3af1eaaf566af375dbc79abd4535e86f2fc8a6d.1485522479.git.rgb@redhat.com>
	<20170131194419.GE27141@madcap2.tricolour.ca>
	<CAHC9VhQu7sG_mMWjhYC=k-Kr_YQmrOyMboR3mckuBdSqsFuboQ@mail.gmail.com>
	<6667634.hKks8rloKk@x2>
	<CAHC9VhRKJjn7VWFusUo7FZy=SBrD_-P51XYye6baZpRC1bkvOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>, linux-audit@redhat.com
To: Paul Moore <paul@paul-moore.com>
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHC9VhRKJjn7VWFusUo7FZy=SBrD_-P51XYye6baZpRC1bkvOQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

On 2017-02-06 14:41, Paul Moore wrote:
> On Sat, Feb 4, 2017 at 8:25 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> > On Friday, February 3, 2017 6:44:16 PM EST Paul Moore wrote:
> >> I'm still trying to understand what purpose this record actually
> >> serves, and what requirements may exist.  In an earlier thread
> >> somewhere Steve mentioned some broad requirements around data
> >> import/export, and I really wonder if the NETFILTER_PKT record
> >> provides anything useful here when it really isn't connecting the
> >> traffic to the sender/receiver without a lot of additional logging and
> >> post-processing smarts.  If you were interested in data import/export
> >> I think auditing the socket syscalls would provide a much more useful
> >> set of records in the audit log.
> >
> > The problem here is we cannot be selective enough through the syscall
> > interface to get exactly what we want. For example, any auditing of connect
> > and accept will also get af_unix traffic which is likely to be uid/gid lookups
> > through sssd or glibc. Typically we want the IPv4/6 traffic. The netfilter rules
> > are better suited to describing which packets are of interest.
> 
> Okay, but how useful are these NETFILTER_PKT records, really?  The
> only linkage you have back to the process on the local machine is via
> the addr/proto/port tuple and that seems far from ideal.

And even that could be spoofed easily and gathering more corroborating
information would seem useful.

Would the presence of the SOCKADDR record in any SYSCALL record be
useful for somehow tagging a class of fd as being of interest?

> >> Considering that one of the primary motivations for the audit
> >> subsystem is to enable compliance with various security
> >> specifications, let's get the ones we know about listed in this thread
> >> and then figure out how best to meet those requirements.
> >
> > Common Criteria calls out for the ability to detect any attempt at information
> > flow. Everything else leverages the CC requirements.
> 
> Yes, you've mentioned this previously.  This is good, but we need to
> make these requirements a bit more concrete; we need something we can
> use to arrive at a working implementation that satisfies these
> requirements.
> 
> If this is purely about information flowing from A to B, would the
> source and destination addr/proto/port for TCP and UDP suffice?  Do we
> need anything else?
> 
> -- 
> paul moore
> www.paul-moore.com

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
