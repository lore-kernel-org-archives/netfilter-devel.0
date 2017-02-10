From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Thu, 09 Feb 2017 19:09:12 -0500
Message-ID: <1933298.JBL9FoQ3nj@x2>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
	<CAHC9VhTG-ByCf5v0tmXmVJBhCer3-3AvMUJP45UPTNF_Xik3JA@mail.gmail.com>
	<20170209234938.GO26850@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <20170209234938.GO26850@madcap2.tricolour.ca>
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

On Thursday, February 9, 2017 6:49:38 PM EST Richard Guy Briggs wrote:
> On 2017-02-08 18:09, Paul Moore wrote:
> > On Wed, Feb 8, 2017 at 11:30 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> > > On Tuesday, February 7, 2017 10:56:39 PM EST Paul Moore wrote:
> > >> On Tue, Feb 7, 2017 at 3:52 PM, Richard Guy Briggs <rgb@redhat.com> 
wrote:
> > >> > So while I'm not advocating this is what should be done and I'm
> > >> > trying
> > >> > to establish bounds to the scope of this feature, but would it be
> > >> > reasonable to simply not log packets that were transiting this
> > >> > machine
> > >> > without a local endpoint?
> > >> 
> > >> I'm still waiting on more detailed requirements information from
> > >> Steve, but based on what we've heard so far, it seems that ignoring
> > >> forwarded traffic is a reasonable thing to do.
> > > 
> > > OK, I have done the analysis to see where things stand on this ...
> > 
> > ...
> > 
> > > At this point, I would say there is no purpose for xt_AUDIT.c based on
> > > Common Criteria. It looks like its built in response to the
> > > CONFIG_NETFILTER_XT_TARGET_AUDIT config option. So, it can be cleanly
> > > deprecated.
> > 
> > Based on some off-list discussions with Richard it would appear that
> > there are several users of the NETFILTER_PKT record so I am in no
> > hurry to deprecate it.  Considering that there are no CC requirements
> > on the record, I think we can focus on simply providing a basic record
> > that satisfies the whims of the userspace tools without adding any
> > pain to the kernel.  I believe Richard is currently working on a
> > proposal to do that, let's discuss it further in that thread.
> 
> If there is no strict rule about turning any other type of record other than
> SYSCALLs into compound records, we could add the user credentials if they
> are identifyable without having a number of unset fields by using an
> auxilliary record.  If this isn't possible or desirable, we'd need to
> include those fields as unset in every message unless we discard
> messages for which there is no identifying information.

There's no actual rule on this, but its not expected and I'd have to check to 
see what this would do to the parsers. The main drawback is that just setting 
up an auxiliary record is going to eat 40 bytes without the record name. That 
will also make processing them more difficult because information is on multiple 
lines. And we'd need clear rules about what the last record is to know when 
the event is complete if they are interlaced.


> We probably don't want to trot out all the fields in a packet like
> tcpdump does, since many of them won't be of interest to us.  We want
> protocol family, end points, type of packet.  The ones that would be
> quite useful but may be hard to get are pid, auid, sessionid.
> 
> There is no packet for which all fields are valid.  This is why using
> "unset" values in those fields was suggested.
> 
> I'd start by splitting data from control protocols if we even need
> source/destination ports or icmp* details.  Those seem like pretty
> important details, so I think we need to start there.
> 
> I'd be inclined to use the same message type for IPv4 and IPv6 and just
> drop the IPv4-specific fields, or include them with the IPv6 record and
> set them to "unset" (ipid, frag).
> 
> As for the MAC (Media Access Control) addresses I'm not sure what to
> recommend.  We could fill them in with the outer MAC, we could leave them as
> unset or could just delete them entirely.
> 
> Source IP addresses can be easily spoofed, particularly for UDP, so they
> are not particularly useful and a MAC may have more useful information
> if there are multiple potential local sources.  Depending on the local
> hardware there is usually a MAC address, but may have been stripped by
> the time we see that packet, but I think it is worth adding, but not
> sure the best way to do this if there is a second MAC for tunnelling,
> etc...

I don't think audit should worry about spoofing. Yes it can be done, but we 
should accurately record what was presented to the system. Other tools can be 
employed to watch for arp spoofing and source routed packets. Its a biiger 
problem than just the audit logs.


> Ok, with that guidance...  from the start of the message:
> 
> helpful		action, hook
> useless?	len
> helpful		inif, outif, mark
> useless?	smac, dmac, macproto
> helpful		protocol family
> useless?	truncated
> helpful		saddr, daddr
> useless?	ipid
> helpful		proto
> useless?	frag
> useless?	truncated
> helpful		sport, dport
> helpful		icmptype, icmpcode
> helpful		secmark (I forgot to change it from "obj" to "secmark" in my
> patch).
> 
> I agree truncate is not helpful, neither is ipid or frag I'm guessing.  I'm
> not sure what the 3 MAC fields give us, other than some idea of routing
> information (which might actually be useful in this context due to the ease
> of IP addr and port spoofing).  I'd be tempted to add a network protocol
> field between mark and saddr.
> 
> That could potentially bring us down to 4 distinct messages with no useless
> fields: -IP data	-action, hook, inif, outif, mark, pfam, saddr, daddr,
> proto, sport, dport[, secmark] -IP control	-action, hook, inif, outif,
> mark, pfam, saddr, daddr, proto, icmptype, icmpcode[, secmark] -other
> IP	-action, hook, inif, outif, mark, pfam, saddr, daddr, proto[, secmark]
> -other non-IP	-action, hook, inif, outif, mark, pfam[, secmark]

I'd want to see proto near the begining to guid interpretation of later fields.


> I'd like to see a CHAIN name in there, but that doesn't appear to be
> available, so we'd have to make do with the "mark" field.
> 
> (I'd add DCCP/SCTP to TCP/UDP under data since it is trivial.)
> 
> 
> Swinging fields in and out makes it very handy to use one message type
> for all of them and can save precious disk bandwidth, but the point was
> to normalize these messages.  Is that still realistic and necessary?

I prefer seeing 4 event types that follow an exact order everytime.

> If so, we're trying to find a balance between message type explosion and
> disk bandwidth. 

4 is not really an explosion. However, there is no actual requirement for 
these events any more. If we are going to keep them, the really should follow 
an exact order each time.

-Steve

> We either need to make this more fine-grained by
> message type, ignore fields that aren't valid for that type indicated
> with "unset", or swing fields in and out.
