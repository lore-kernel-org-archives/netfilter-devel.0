From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: What should we do with packets marked as INVALID?
Date: Mon, 25 Dec 2006 15:08:14 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0612251357240.7663@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0612250059460.27316@bizon.gios.gov.pl>
	<Pine.LNX.4.61.0612251324540.16427@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1877714721-1167055694=:7663"
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0612251324540.16427@yvahk01.tjqt.qr>
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

---187430788-1877714721-1167055694=:7663
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 25 Dec 2006, Jan Engelhardt wrote:

>
>
>> Date: Mon, 25 Dec 2006 02:33:59 +0100 (CET)
>> From: Krzysztof Oledzki <ole@ans.pl>
>> To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.or=
g>
>> Subject: What should we do with packets marked as INVALID?
>>
>> Hello,
>>
>> One of the most important feature provided by the netfilter
>> subsystem is stateful connection tracking - the ability to decide
>> that a packet is valid (or not) using not only data from a packet
>> itself but also from a history of a flaw.
>>
>> So, the question is: what should we do with packets marked as
>> INVALID?
>
>
> http://jengelh.hopto.org/p/chaostables/fw.html
> section 3. YMMV.

OK, but my fw does not try to pickup unknown connections as I disabled=20
ip_conntrack_tcp_loose (net.ipv4.netfilter.ip_conntrack_tcp_loose=3D0) -=20
there is no chance to pickup connections using sack/wscale, I don't flush=
=20
conntrack and I don't reboot it very often. So I assume that my firewall=20
should know _all_ active connections and drop/kill others.

>>
>> For a very long time I have thought that something like this should
>> work best:
>>
>> -A INVALID -m limit --limit 10/s -j LOG --log-prefix "INVALID: " --log-l=
evel 7
>> --log-tcp-sequence --log-tcp-options --log-ip-options
>> -A INVALID -p tcp -m limit --limit 4/s -j REJECT --reject-with tcp-reset
>> -A INVALID -p udp -m limit --limit 4/s -j REJECT
>> -A INVALID -j DROP
>>
>> -A FORWARD -m conntrack --ctstate INVALID -j INVALID
>>
>> This whole REJECT idea is to kill out of sync sessions - IMO it is
>> better to send RST/port-unreachable ASAP, so hosts know they should
>> reconnect immediatley (if that's appropriately) without needing to
>> wait (sometines very long) for a session to timeout. Think on
>> stalled NFS mounts, etc.
>>
>> Then I realized that the same INVALID state handles packets from a
>> valid flow (proto/src/dst/sport/dport match conntrack table) but
>> with something the netfilter decides that is wrong (ex. out of
>> window segments, short/truncated/malformed packets, bad checksum,
>
> When do these happen anyways? Bad checksum should probably be caught
> by the TCP layer.

It is checked in ip_conntrack_proto_tcp.c:

         /* Checksum invalid? Ignore.
          * We skip checking packets on the outgoing path
          * because it is assumed to be correct.
          */
         /* FIXME: Source route IP option packets --RR */
         if (ip_conntrack_checksum && hooknum =3D=3D NF_IP_PRE_ROUTING &&
             nf_ip_checksum(skb, hooknum, iph->ihl * 4, IPPROTO_TCP)) {
                 if (LOG_INVALID(IPPROTO_TCP))
                         nf_log_packet(PF_INET, 0, skb, NULL, NULL, NULL,
                                   "ip_ct_tcp: bad TCP checksum ");
                 return -NF_ACCEPT;

         }

So, bad checksum =3D> INVALID.

Anyway, other error messages are also quite common:

root@fw2:~# grep ip_ct_tcp /var/log/syslog |cut -d " " -f 6-|cut -d =3D -f =
1|sed s/IN//|sort|uniq -c|sort
      10 ip_ct_tcp: invalid state
      11 ip_ct_tcp: truncated/malformed packet
      30 ip_ct_tcp: killing out of sync session
     173 ip_ct_tcp: SEQ is under the lower bound (already ACKed data retran=
smitted)
     241 ip_ct_tcp: SEQ is over the upper bound (over the window of the rec=
eiver)
     500 ip_ct_tcp: ACK is over the upper bound (ACKed data not seen yet)
     863 ip_ct_tcp: ACK is under the lower bound (possible overly delayed A=
CK)
    1134 ip_ct_tcp: invalid TCP flag combination
    3050 ip_ct_tcp: bad TCP checksum
   10552 ip_ct_tcp: invalid packet ignored

>> So, I have two propositions:
>> - Add another state (ex. UNCLEAN) for packet that matches
>> proto/src/dst/sport/dport, but netfilter consider that it is wrong. Ther=
e will
>> be two states: INVALID (for packet with no known conntrack entry) and UN=
CLEAN
>> and that gives us possibility to distinguish between these two states:
>>
>> -A FORWARD -m conntrack --ctstate UNCLEAN -j DROP
>
> There was a 'unclean' match in POMng sometime ago, coincidence?

Partialy, yes. The "-m unclean" is able to check if something in a packet=
=20
seems to be wrong, so I think it may be good name for additional state=20
in '-m conntrack'. ;)

>> -A FORWARD -m conntrack --ctstate INVALID -j INVALID
>>
>> - Drop such packets implicitly (something like s/-NF_ACCEPT/-NF_DROP/ in
>> ip_conntrack_proto_*.c) and safely REJECT packets with INVALID state, li=
ke in
>> my first example. This time INVALID will means that there is no appropri=
ate
>> conntrack entry, nothing else.
>>
>> Comments?
>>


Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1877714721-1167055694=:7663--
