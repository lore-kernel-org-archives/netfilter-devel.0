From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: What should we do with packets marked as INVALID?
Date: Mon, 15 Jan 2007 11:41:32 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0701151131080.13986@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
	<45A48260.1000400@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-780864965-1168857692=:13986"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A48260.1000400@trash.net>
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

---187430788-780864965-1168857692=:13986
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 10 Jan 2007, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>> Hello,
>>
>> One of the most important feature provided by the netfilter subsystem is
>> stateful connection tracking - the ability to decide that a packet is
>> valid (or not) using not only data from a packet itself but also from a
>> history of a flaw.
>>
>> So, the question is: what should we do with packets marked as INVALID?
>>
>> For a very long time I have thought that something like this should work
>> best:
>>
>> -A INVALID -m limit --limit 10/s -j LOG --log-prefix "INVALID: "
>> --log-level 7 --log-tcp-sequence --log-tcp-options --log-ip-options
>> -A INVALID -p tcp -m limit --limit 4/s -j REJECT --reject-with tcp-reset
>> -A INVALID -p udp -m limit --limit 4/s -j REJECT
>> -A INVALID -j DROP
>>
>> -A FORWARD -m conntrack --ctstate INVALID -j INVALID
>>
>> This whole REJECT idea is to kill out of sync sessions - IMO it is
>> better to send RST/port-unreachable ASAP, so hosts know they should
>> reconnect immediatley (if that's appropriately) without needing to wait
>> (sometines very long) for a session to timeout. Think on stalled NFS
>> mounts, etc.
>>
>> Then I realized that the same INVALID state handles packets from a valid
>> flow (proto/src/dst/sport/dport match conntrack table) but with
>> something the netfilter decides that is wrong (ex. out of window
>> segments, short/truncated/malformed packets, bad checksum, etc).
>> Rejecting such packets kills valid connections, and it is quite common
>> to get a lot of, for example, "ip_ct_tcp: ACK is under the lower bound
>> (possible overly delayed ACK)" on bigger firewalls:
>>
>> root@fw2:~# grep -c "ip_ct_tcp: ACK is under the lower bound (possible
>> overly delayed ACK)" /var/log/syslog
>> 905
>>
>> So OK, REJECT is wrong (possibly kills valid connections), DROP (makes
>> invalid connections hang "forever") is also wrong, so maybe we should
>> forward such packets and allow dst hosts to handle it
>> (ignore/reset/etc). Bzzzz... no, wait, it is also wrong as we lose one
>> of the most important netfilter feature.
>
>
> DROP shouldn't make sessions hang (otherwise they would break with NAT
> as well)

It blocks until timeout which sometimes simply takes to long.

> and is in my opinion the correct thing to do with INVALID packets.

OK, hopefully I found a smart solution. With=20
net.ipv4.netfilter.ip_conntrack_tcp_loose enabled it is possible to=20
distinguish between new tcp-ack packet without preceding syn and improper=
=20
tcp-ack packet with a matching tuple:

iptA FORWARD -m conntrack --ctstate INVALID -j INVALID
iptA FORWARD -p tcp -m conntrack --ctstate NEW ! --syn -j INVALID_NewTCP


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-780864965-1168857692=:13986--
