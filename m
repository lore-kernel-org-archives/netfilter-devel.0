From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH] netfilter: nf_ct_sctp: validate vtag for new conntrack
 entries
Date: Tue, 15 Dec 2015 17:03:04 -0200
Message-ID: <20151215190304.GA3724@mrl.redhat.com>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
 <20151210120233.GA2084@salvia>
 <56697B14.3010909@gmail.com>
 <20151210134247.GA3942@salvia>
 <20151210140625.GC3886@mrl.redhat.com>
 <20151210170647.GA1547@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232AbbLOTDI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Dec 2015 14:03:08 -0500
Content-Disposition: inline
In-Reply-To: <20151210170647.GA1547@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 10, 2015 at 06:06:57PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Dec 10, 2015 at 12:06:25PM -0200, Marcelo Ricardo Leitner wrote:
> > On Thu, Dec 10, 2015 at 02:42:47PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Dec 10, 2015 at 11:16:04AM -0200, Marcelo Ricardo Leitner wrote:
> > >
> > > You can use a mask in expectations for wildcard matching, I think
> > > you're basically doing this in your patch. So it would be just one
> > > single expectation for that combination with the permanent flags set
> > > on. I think we may need another flag to make new conntracks
> > 
> > Yes
> > 
> > > independent from the master (IIRC currently if the master conntrack is
> > > gone, related ones will be gone too and we don't want this to happen
> > > in this case).
> > 
> > Ah yes, that too.
> > 
> > If such entry times out, we could promote a related entry to master,
> > maybe.
> >
> > Because with this link in there we are able to remove all the
> > entries when we see a shutdown/abort instead of leaving them to timeout.
> 
> I think in this case it doesn't make sense to have a pointer to the
> master conntrack for a new sctp flow that got established via
> expectation. That new sctp flow would be completely independent. I

Not really. It's just another path/transport for the same sctp
association. From sctp point of view, these two conntrack entries share
their end points, they refer to the same sockets.

> would need to audit the core code to evaluate the impact of having a
> conntrack with the IPS_EXPECTED_BIT set with no master set. It would
> be good if you can investigate this.

Sure. I'll get to that after considering the tuple enlargement.

> > > > This was the main reason that I didn't use expectations.  Yet this
> > > > req changed when I realized that we can't process ASCONF chunks without
> > > > validating the AUTH chunk first, which we just can't just when in the middle
> > > > of the communication.
> > > 
> > > OK, so that's why we cannot create expectations for specific
> > > addresses, right?
> > 
> > Right. We would be trusting un-trusty data.
> 
> I see, but without IP source and destination address in the
> expectation, how is this effective from a security point of view? My
> concerns go in the direction of possible spoofing that result in holes
> in the firewall for sctp traffic.

It may not be 100% secure without the IP addresses in it but it adds
another 32bit that the attacker must be able to match in order to get
through that door.

Currently, if the attacker knows the ports used, it's enough to get
at least a heartbeat through.

> > > > After that went down it's just two other:
> > > > - by removing the addresses from it, we have the possibility that a host may
> > > > use multiple addresses but not for a single sctp association, but like
> > > > running two distinct assocs, one using each IP address, but same ports, and
> > > > same vtags. It could happen.. it would cause a clash as the expectation
> > > > would be the same but for different masters.
> > > > 
> > > > - adding vtag to it increases nf_conntrack_tuple by 4 bytes, so 8 bytes per
> > > > nf_conn, while this feature will be off for the majority of the
> > > > installations.> > 
> > > 
> > > Yes, there is a bit more extra memory.
> > > 
> > > I think we can shrink this back by moving the expectation master
> > > pointer to an extension (they are rarely used). Another one to
> > > consider is secmark, I don't know of many using this but I may be wrong.
> > 
> > Ok
> 
> Anyway, it would be good to evaluate the performance impact on
> enlarging the tuple. Not only extra memory, the hashing for lookups
> will take 4 extra bytes per packet after such change.
> 
> I would need to have a look, but there must be a nice way to
> accomodate this into the expectation infrastructure without having any
> impact on that front. Probably we can have a per-protocol family
> expectation table (instead of a global table) where the hashing to
> look up for expectations depends on the protocol (so in the sctp case,
> we can include the vtag from the ct->state in the hash lookup).
> 
> Just an idea, we should avoid any significant impact on performance
> for everyone else just to handle this sctp multihoming case.

This is very interesting, specially considering the below ---v

> > > > The possibility of using RELATED is very attractive, though. Would make more
> > > > sense, I think.
> > > 
> > > OK.
> > > 
> > > > The extra bytes, we might do it, but for that conflict, only if we
> > > > require the usage of conntrack zones in such cases. It would work
> > > > for me..
> > > 
> > > Not sure what you mean.
> > 
> > That we can go this other way if you think it's best, not a problem. :-)
> > 
> > For not breaking d7ee35190427 ("netfilter: nf_ct_sctp: minimal
> > multihoming support"), we would still need that sysctl, something like
> > 'expected_heartbeats', still defaulting to false.
> 
> You mean we need that new sysctl to explicitly enable multihoming
> tracking in any case, right?

I think you got it but I have a feeling that there is a small
misunderstanding in here. Let me try to rephrase it. We need that new
sysctl in order to know if we should allow conntrack entries to be
created from heartbeats alone (as it is today) or if even these
heartbeats should be matched against a known sport/dport/vtag tuple (as
I'm proposing with this patch).


About the idea to put the vtag into the tuple itself, this is more like a heads
up, sharing it early. I'm afraid that's going to be very complicated because we
store all infos in u union in big endian.

                union {
                        /* Add other protocols here. */
                        __be64 all;
			    ^^-- to fit the new be32 (was be16)

                        struct {
                                __be16 port;
                        } tcp;
                        struct {
                                __be16 port;
                        } udp;
                        struct {
                                u_int8_t type, code;
                        } icmp;
                        struct {
                                __be16 port;
                        } dccp;
                        struct {
                                __be16 port;
                                __be32 vtag;
                        } sctp;  <-- expanded

but this change will cause the structs with __be16 to read the higher
portion of that be64 instead if on a little-endian system.

$ pahole test
struct pack64 {
	union {
		__be64             all;                  /*           8 */
		struct {
			__be16     port;                 /*     0     2 */
		} tcp;                                   /*           2 */
	} u;                                             /*     0     8 */

	/* size: 8, cachelines: 1, members: 1 */
	/* last cacheline: 8 bytes */
};
struct pack16 {
	union {
		__be16             all;                  /*           2 */
		struct {
			__be16     port;                 /*     0     2 */
		} tcp;                                   /*           2 */
	} u;                                             /*     0     2 */

	/* size: 2, cachelines: 1, members: 1 */
	/* last cacheline: 2 bytes */
};

and there is code that relies on this direct mapping, like in:

nf_nat_l4proto_in_range():
        __be16 port;

        if (maniptype == NF_NAT_MANIP_SRC)
                port = tuple->src.u.all;
        else
                port = tuple->dst.u.all;

nf_nat_ipv6_decode_session():
        if (ct->status & statusbit) {
                fl6->daddr = t->dst.u3.in6;
                if (t->dst.protonum == IPPROTO_TCP ||
                    t->dst.protonum == IPPROTO_UDP ||
                    t->dst.protonum == IPPROTO_UDPLITE ||
                    t->dst.protonum == IPPROTO_DCCP ||
                    t->dst.protonum == IPPROTO_SCTP)
                        fl6->fl6_dport = t->dst.u.all;
        }

ip_vs_conn_drop_conntrack():
        tuple.src.u3 = cp->caddr;                                         
        tuple.src.u.all = cp->cport;                                      
        tuple.src.l3num = cp->af;                                         
        tuple.dst.u3 = cp->vaddr;                                         
        tuple.dst.u.all = cp->vport;                                      

amongst others, including the the masks, like in:

__nf_ct_helper_find():
        struct nf_conntrack_tuple_mask mask = { .src.u.all = htons(0xFFFF) };
...
        hlist_for_each_entry_rcu(helper, &nf_ct_helper_hash[h], hnode) {
                if (nf_ct_tuple_src_mask_cmp(tuple, &helper->tuple, &mask))
                        return helper;
        }

and:
ct_proto_port_check():
        /* Shortcut to match all recognized protocols by using ->src.all. */
        if ((info->match_flags & XT_CONNTRACK_ORIGSRC_PORT) &&
            (tuple->src.u.all == info->origsrc_port) ^
            !(info->invert_flags & XT_CONNTRACK_ORIGSRC_PORT))
                return false;

Seems some bit-dancing will be necessary.

Thanks,
Marcelo

