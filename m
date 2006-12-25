From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: What should we do with packets marked as INVALID?
Date: Mon, 25 Dec 2006 13:29:39 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612251324540.16427@yvahk01.tjqt.qr>
References: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1283855629-84035743-1167049779=:16427"
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1283855629-84035743-1167049779=:16427
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



>Date: Mon, 25 Dec 2006 02:33:59 +0100 (CET)
>From: Krzysztof Oledzki <ole@ans.pl>
>To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
>Subject: What should we do with packets marked as INVALID?
>
> Hello,
>
> One of the most important feature provided by the netfilter
> subsystem is stateful connection tracking - the ability to decide
> that a packet is valid (or not) using not only data from a packet
> itself but also from a history of a flaw.
>
> So, the question is: what should we do with packets marked as
> INVALID?


http://jengelh.hopto.org/p/chaostables/fw.html
section 3. YMMV.

>
> For a very long time I have thought that something like this should
> work best:
>
> -A INVALID -m limit --limit 10/s -j LOG --log-prefix "INVALID: " --log-level 7
> --log-tcp-sequence --log-tcp-options --log-ip-options
> -A INVALID -p tcp -m limit --limit 4/s -j REJECT --reject-with tcp-reset
> -A INVALID -p udp -m limit --limit 4/s -j REJECT
> -A INVALID -j DROP
>
> -A FORWARD -m conntrack --ctstate INVALID -j INVALID
>
> This whole REJECT idea is to kill out of sync sessions - IMO it is
> better to send RST/port-unreachable ASAP, so hosts know they should
> reconnect immediatley (if that's appropriately) without needing to
> wait (sometines very long) for a session to timeout. Think on
> stalled NFS mounts, etc.
>
> Then I realized that the same INVALID state handles packets from a
> valid flow (proto/src/dst/sport/dport match conntrack table) but
> with something the netfilter decides that is wrong (ex. out of
> window segments, short/truncated/malformed packets, bad checksum,

When do these happen anyways? Bad checksum should probably be caught
by the TCP layer.


> So, I have two propositions:
> - Add another state (ex. UNCLEAN) for packet that matches
> proto/src/dst/sport/dport, but netfilter consider that it is wrong. There will
> be two states: INVALID (for packet with no known conntrack entry) and UNCLEAN
> and that gives us possibility to distinguish between these two states:
>
> -A FORWARD -m conntrack --ctstate UNCLEAN -j DROP

There was a 'unclean' match in POMng sometime ago, coincidence?

> -A FORWARD -m conntrack --ctstate INVALID -j INVALID
>
> - Drop such packets implicitly (something like s/-NF_ACCEPT/-NF_DROP/ in
> ip_conntrack_proto_*.c) and safely REJECT packets with INVALID state, like in
> my first example. This time INVALID will means that there is no appropriate
> conntrack entry, nothing else.
>
> Comments?
>
> Best regardas,
>
>
> 			Krzysztof Olędzki
>

	-`J'
-- 
--1283855629-84035743-1167049779=:16427--
