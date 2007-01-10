From: Patrick McHardy <kaber@trash.net>
Subject: Re: What should we do with packets marked as INVALID?
Date: Wed, 10 Jan 2007 07:06:24 +0100
Message-ID: <45A48260.1000400@trash.net>
References: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Krzysztof Oledzki wrote:
> Hello,
> 
> One of the most important feature provided by the netfilter subsystem is
> stateful connection tracking - the ability to decide that a packet is
> valid (or not) using not only data from a packet itself but also from a
> history of a flaw.
> 
> So, the question is: what should we do with packets marked as INVALID?
> 
> For a very long time I have thought that something like this should work
> best:
> 
> -A INVALID -m limit --limit 10/s -j LOG --log-prefix "INVALID: "
> --log-level 7 --log-tcp-sequence --log-tcp-options --log-ip-options
> -A INVALID -p tcp -m limit --limit 4/s -j REJECT --reject-with tcp-reset
> -A INVALID -p udp -m limit --limit 4/s -j REJECT
> -A INVALID -j DROP
> 
> -A FORWARD -m conntrack --ctstate INVALID -j INVALID
> 
> This whole REJECT idea is to kill out of sync sessions - IMO it is
> better to send RST/port-unreachable ASAP, so hosts know they should
> reconnect immediatley (if that's appropriately) without needing to wait
> (sometines very long) for a session to timeout. Think on stalled NFS
> mounts, etc.
> 
> Then I realized that the same INVALID state handles packets from a valid
> flow (proto/src/dst/sport/dport match conntrack table) but with
> something the netfilter decides that is wrong (ex. out of window
> segments, short/truncated/malformed packets, bad checksum, etc).
> Rejecting such packets kills valid connections, and it is quite common
> to get a lot of, for example, "ip_ct_tcp: ACK is under the lower bound
> (possible overly delayed ACK)" on bigger firewalls:
> 
> root@fw2:~# grep -c "ip_ct_tcp: ACK is under the lower bound (possible
> overly delayed ACK)" /var/log/syslog
> 905
> 
> So OK, REJECT is wrong (possibly kills valid connections), DROP (makes
> invalid connections hang "forever") is also wrong, so maybe we should
> forward such packets and allow dst hosts to handle it
> (ignore/reset/etc). Bzzzz... no, wait, it is also wrong as we lose one
> of the most important netfilter feature.


DROP shouldn't make sessions hang (otherwise they would break with NAT
as well) and is in my opinion the correct thing to do with INVALID
packets.
