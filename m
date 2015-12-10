From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH] netfilter: nf_ct_sctp: validate vtag for new conntrack
 entries
Date: Thu, 10 Dec 2015 12:06:25 -0200
Message-ID: <20151210140625.GC3886@mrl.redhat.com>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
 <20151210120233.GA2084@salvia>
 <56697B14.3010909@gmail.com>
 <20151210134247.GA3942@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbbLJOG3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Dec 2015 09:06:29 -0500
Content-Disposition: inline
In-Reply-To: <20151210134247.GA3942@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 10, 2015 at 02:42:47PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Dec 10, 2015 at 11:16:04AM -0200, Marcelo Ricardo Leitner wrote:
> > Hello,
> > 
> > Em 10-12-2015 10:02, Pablo Neira Ayuso escreveu:
> > >Hi Marcelo,
> > >
> > >On Tue, Dec 08, 2015 at 11:11:10AM -0200, Marcelo Ricardo Leitner wrote:
> > >>Commit d7ee35190427 ("netfilter: nf_ct_sctp: minimal multihoming
> > >>support") allowed creating conntrack entries based on the heartbeat
> > >>exchange, so that we can track secondary paths too.
> > >>
> > >>This patch adds a vtag verification to that. That is, in order to allow
> > >>a HEARTBEAT or a HEARTBEAT_ACK through, the tuple (src port, dst port,
> > >>vtag) must be already known.
> > >
> > >This infrastructure that you're adding in this patch looks very
> > >similar to me to conntrack expectations.
> > >
> > >Did you evaluate this possibility?
> > 
> > Yes,
> > 
> > >The idea would be to add the vtag to the tuples since it allows us to
> > >uniquely identify the SCTP flow. Then, if you see the hearbeat, you
> > >can register an expectation for the tuple (any-src-ip, any-dst-ip,
> > >sctp, specific-sport, specific-dport, specific-vtag-value).
> > >
> > >Then, any secondary STCP flow matching that expectation in the future
> > >will be accepted as RELATED traffic.
> > 
> > When I first evaluated using expectations, I was going to track all
> > addresses that the association was announcing. This would mean we would have
> > to add expectations for all address combinations that might have been
> > possible.
> 
> You can use a mask in expectations for wildcard matching, I think
> you're basically doing this in your patch. So it would be just one
> single expectation for that combination with the permanent flags set
> on. I think we may need another flag to make new conntracks

Yes

> independent from the master (IIRC currently if the master conntrack is
> gone, related ones will be gone too and we don't want this to happen
> in this case).

Ah yes, that too.

If such entry times out, we could promote a related entry to master,
maybe.  Because with this link in there we are able to remove all the
entries when we see a shutdown/abort instead of leaving them to timeout.

> > This was the main reason that I didn't use expectations.  Yet this
> > req changed when I realized that we can't process ASCONF chunks without
> > validating the AUTH chunk first, which we just can't just when in the middle
> > of the communication.
> 
> OK, so that's why we cannot create expectations for specific
> addresses, right?

Right. We would be trusting un-trusty data.

> > After that went down it's just two other:
> > - by removing the addresses from it, we have the possibility that a host may
> > use multiple addresses but not for a single sctp association, but like
> > running two distinct assocs, one using each IP address, but same ports, and
> > same vtags. It could happen.. it would cause a clash as the expectation
> > would be the same but for different masters.
> > 
> > - adding vtag to it increases nf_conntrack_tuple by 4 bytes, so 8 bytes per
> > nf_conn, while this feature will be off for the majority of the
> > installations.
> 
> Yes, there is a bit more extra memory.
> 
> I think we can shrink this back by moving the expectation master
> pointer to an extension (they are rarely used). Another one to
> consider is secmark, I don't know of many using this but I may be wrong.

Ok

> > The possibility of using RELATED is very attractive, though. Would make more
> > sense, I think.
> 
> OK.
> 
> > The extra bytes, we might do it, but for that conflict, only if we
> > require the usage of conntrack zones in such cases. It would work
> > for me..
> 
> Not sure what you mean.

That we can go this other way if you think it's best, not a problem. :-)

For not breaking d7ee35190427 ("netfilter: nf_ct_sctp: minimal
multihoming support"), we would still need that sysctl, something like
'expected_heartbeats', still defaulting to false.

  Marcelo

