From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: conntrack and ICMP errors
Date: Fri, 11 Apr 2003 12:16:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030411101648.GB32552@balabit.hu>
References: <20030410182056.GA17723@bzorp.balabit.hu> <20030410200816.GA18520@oknodo.bof.de> <20030411094340.GA32552@balabit.hu> <20030411094956.GC18520@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030411094956.GC18520@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Apr 11, 2003 at 11:49:56AM +0200, Patrick Schaaf wrote:
> > > To summarize:
> > > 
> > > 	ICMP messages DO NOT TERMINATE TCP CONNECTIONS.
> > > 
> > > Please print that out, and eat the printout. You may add salt and pepper.
> > 
> > I thought the TCP example would not be very good, but I would rather not eat
> > printouts (not even salted ones ;).
> > 
> > Here's an example when an ICMP packet DOES terminate a TCP connection:
> > 
> > When a SYN is received on a port which is not listening the stack is free to
> > return either a TCP RST packet or an ICMP port unreachable packet: Windows
> > stacks return ICMP port unreachable, Linux returns TCP RST and our
> > REJECT target sends an ICMP port unreachable (by default).
> 
> Sorry, but that's not a valid argument against my point. When a SYN is
> received, there IS no TCP connection to terminate, yet. Do you see
> conntracking keeping an ESTABLISHED connection, in this case? I don't
> think so.
> 
> Does Windows return ICMP port unreachable for non-SYN frames, too?
> And, does it accept port unreachable messages and terminates local
> sockets? Same questions regarding Linux and non-SYN frames?

You are right, ICMP port unreachable is sent only in reaction to a SYN. So I
was not right, however:

when an RST is received to a SYN the timeout becomes 60 secs
(ip_conntrack_proto_tcp.c, timeout in state CONNTRACK_CLOSE)

when an ICMP error is received to a SYN it is not considered therefore the
SYN_SENT timeout applies which is 120 secs

OK, this is not a grave problem but is still an inconsistency.

My point is that ICMP errors _might_ be useful for conntrack consideration.

> 
> > While TCP RST terminates the conntrack session ICMP port unreachable does
> > not. I would not call this consistent.
> 
> Depends on your answers to my previous paragraph. If normal behaviour
> for non-SYN packet is receiving back port unreachables, AND this makes
> an endpoint terminate an already established TCP connection, then you
> have a point, and I have learned something new. In that case, I could
> agree that conntracking may also need to learn something new.

Checking tcp_ipv4.c, function tcp_v4_err() reveals that ICMP destination
unreachables are converted to an error code:

        case ICMP_DEST_UNREACH:
                if (code > NR_ICMP_UNREACH)
                        goto out;

                if (code == ICMP_FRAG_NEEDED) { /* PMTU discovery (RFC1191) */
                        if (sk->lock.users == 0)
                                do_pmtu_discovery(sk, iph, info);
                        goto out;
                }

                err = icmp_err_convert[code].errno;
                break;

But this error is propagated to userspace if IP_RECVERR socket option is
enabled for the socket:

        if (sk->lock.users == 0 && sk->protinfo.af_inet.recverr) {
                sk->err = err;
                sk->error_report(sk);
        } else  { /* Only an error on timeout */
                sk->err_soft = err;
        }

err_soft is picked up only in case send() timeouts. Therefore other than the
small timeout difference between the SYN-RST and SYN-ICMP UNREACH scenarios
TCP would not necessary need to consider ICMP errors.

> 
> > On the other hand connection tracking an UDP session is less robust than
> > TCP, simply because UDP has no state. Therefore we are using time based
> > session tracking which is blind at least compared to TCP conntrack.
> > Therefore it might make use of additional hints like ICMP port unreachables.
> 
> That may make sense. I'm not very familiar with the requirements of UDP
> based protocols.

Currently UDP uses 30 secs timeout when the first packet arrives and 180
seconds afterwards. A port unreachable usually means that the target service
is down. ICMP errors are handled by client stacks by always propagating the error:

	... parse error ... 
        if (!sk->protinfo.af_inet.recverr) {
                if (!harderr || sk->state != TCP_ESTABLISHED)
                        goto out;
        } else {
                ip_icmp_error(sk, skb, err, uh->dest, info, (u8*)(uh+1));
        }
        sk->err = err;
        sk->error_report(sk);

Although the application does not necessarily terminate communication after
receiving an error from send() but it is highly probable. And this might be
reflected in the conntrack timeout.

The more I think about this the more I understand the my scenario (with the
proxies) would not be solved by terminating sessions when an ICMP error
occurs, the solution would be more to explicitly request a state removal
from userspace. Hmm... it might be time to check ctnetlink?

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
