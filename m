From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Tue, 7 Feb 2017 15:52:19 -0500
Message-ID: <20170207205219.GA5864@madcap2.tricolour.ca>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
	<20170118151520.GY3087@madcap2.tricolour.ca>
	<CAHC9VhS_6Q=bxnzU8ni1a2fRWnXoMcELzAmy0HmwMH_xhgfRBw@mail.gmail.com>
	<21839828.eXAB1nqvpV@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <21839828.eXAB1nqvpV@x2>
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

On 2017-01-20 09:49, Steve Grubb wrote:
> On Wednesday, January 18, 2017 6:35:29 PM EST Paul Moore wrote:
> > On Wed, Jan 18, 2017 at 10:15 AM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2017-01-18 07:32, Paul Moore wrote:
> > >> On Wed, Jan 18, 2017 at 12:39 AM, Richard Guy Briggs <rgb@redhat.com> 
> wrote:
> > >> > On 2017-01-17 21:34, Richard Guy Briggs wrote:
> > >> >> On 2017-01-17 15:17, Paul Moore wrote:
> > >> >> > On Tue, Jan 17, 2017 at 11:12 AM, Richard Guy Briggs 
> <rgb@redhat.com> wrote:
> > >> >> > > On 2017-01-17 08:55, Steve Grubb wrote:
> > >> >> > >> On Tuesday, January 17, 2017 12:25:51 AM EST Richard Guy Briggs 
> wrote:
> > >> >> > ...
> > >> >> > 
> > >> >> > >> > Ones that are not so straightforward:
> > >> >> > >> > - "secmark" depends on a kernel config setting, so should it
> > >> >> > >> > always be
> > >> >> > >> > 
> > >> >> > >> >   present but "(none)" if that kernel feature is compiled out?
> > >> >> > >> 
> > >> >> > >> If this is selinux related, I'd treat it the same way that we do
> > >> >> > >> subj
> > >> >> > >> everywhere else.
> > >> >> > > 
> > >> >> > > Ok.
> > >> >> > 
> > >> >> > To be clear, a packet's secmark should be recorded via a dedicated
> > >> >> > field, e.g. "secmark", and not use the "subj" field (it isn't a
> > >> >> > subject label in the traditional sense).
> > >> >> 
> > >> >> I think Steve was talking about if, when or where to include that
> > >> >> field,
> > >> >> not what its label is.
> > >> > 
> > >> > In this case it is an "obj=" field, but since it is part of the LSM,
> > >> > each one has its own fields.
> > >> 
> > >> As I said above, use a "secmark" field and not the subject or object
> > >> fields; packet labeling is rather complex and there is value in
> > >> differentiating between secmark labels and network peer labels.
> > > 
> > > Ok, I'll change it from the existing "obj=" to "secmark=".  Since it is
> > > an LSM-dependent field, it will go away when that LSM module does.  It
> > > is the very last item in the list of fields, so I don't see this as a
> > > problem.
> > > 
> > > 
> > > I have more questions and observations:
> > > 
> > > Do we care if the rest of the record's fields are there if the packet is
> > > truncated?  In other words, can I omit all the following fields (that
> > > will end up being set to (none) or -1 since there is no data for them)?
> > > I'd prefer to complete the record, but Steve may not care and might
> > > prefer to save the bandwidth.
> > > 
> > > Can I truncate the field name "truncated" to "trunc" (since I don't see
> > > it yet in the audit field dictionary) if we do include all the fields?
> > > 
> > > I observe that support for IPPROTO_DCCP and IPPROTO_SCTP can be added
> > > virtually for free since the source and desination ports in their packet
> > > formats is identical to TCP and UDP (and UDPLITE).
> > > 
> > > 
> > > At this point, it looks like having one record for IP/IPv6 with
> > > TCP/UDP/DCCP/SCTP makes sense.  Whether or not to add ethernet bridge
> > > headers and ICMP* is a more difficult question.  Ethernet bridge adds 40
> > > chars if it isn't used, up to 62 if it is.  ICMP* adds 26 max.
> > > 
> > > It is an independent record, but it would be nice to be able to reuse
> > > the message ID with a new record type to list sub-parts of the packet,
> > > for example, reuse the existing record type (AUDIT_NETFILTER_PKT) for
> > > the first 5 fields, mark and secmark, then another record type
> > > (AUDIT_NETFILTER_PKT_ETH) for ethernet header, a record
> > > (AUDIT_NETFILTER_PKT_IP) for IP/IPv6 header, then another
> > > (AUDIT_NETFILTER_PKT_PROTO) for transport layer protocol.  This way, the
> > > absence of an ethernet bridge header won't swing out three fields, or
> > > waste 40 chars.  IPv4 adds about 20 chars not used by IPv6. 
> > > TCP/UDP/DCCP/SCTP vs ICMP* is about 25 chars each.  The max message is
> > > 322 chars (eth bridge, IPv6).  A non-ethernet-bridge non-IP* message
> > > would be as little as 76 without the extra fields, but as much as 219
> > > with the extra fields filled with unset values.
> > > 
> > > A full message could look like (I've left off secmark, which would go at
> > > the end): action=9 hook=9999999999 len=9999999999 inif=ZZZZ outif=ZZZZ
> > > mark=0xffffffff smac=FF:FF:FF:FF:FF:FF dmac=FF:FF:FF:FF:FF:FF
> > > macproto=0xffff trunc=9 saddr=FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF
> > > daddr=FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF:FFFF ipid=-1 proto=255 frag=-1
> > > trunc=9 sport=99999 dport=99999 icmptype=999 icmpcode=999
> >
> > At this point I think it would be good to hear what requirements exist
> > for per-packet auditing.  Steve, are there any current Common Criteria
> > (or other) requirements that impact per-packet auditing?
> 
> I don't think you want to flood your logs. That is not helpful. It asks for the 
> ability to detect information flow. Typically you want to know source and 
> destination, protocol, where on the system its coming from or going to, pid if 
> possible and the subject information if available. I know that you can be 
> acting as a proxy and forwarding outside packets into a network. That is not 
> the typical case CC is concerned about. Its more about what the user is doing.

So while I'm not advocating this is what should be done and I'm trying
to establish bounds to the scope of this feature, but would it be
reasonable to simply not log packets that were transiting this machine
without a local endpoint?

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
