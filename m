From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 11 Oct 2007 15:50:00 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710111547490.4674@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1171873723-1192110600=:4674"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:44566 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbXJKNuL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 09:50:11 -0400
In-Reply-To: <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1171873723-1192110600=:4674
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 10 Oct 2007, Jozsef Kadlecsik wrote:

> Hi,
>
> On Wed, 3 Oct 2007, Krzysztof Oledzki wrote:
>
>> I also wondering if the code from nf_conntrack_proto_tcp.c is correct:
>>
>> --- cut here ---
>> new_state =3D tcp_conntracks[dir][index][old_state];
>>
>> switch (new_state)
>> (...)
>> case TCP_CONNTRACK_SYN_SENT:
>> if (old_state < TCP_CONNTRACK_TIME_WAIT)
>>         break;
>> if ((conntrack->proto.tcp.seen[dir].flags &
>>         IP_CT_TCP_FLAG_CLOSE_INIT)
>>     || after(ntohl(th->seq),
>>              conntrack->proto.tcp.seen[dir].td_end)) {
>>         /* Attempt to reopen a closed connection.
>>         * Delete this connection and look up again. */
>>         write_unlock_bh(&tcp_lock);
>>         if (del_timer(&conntrack->timeout))
>>                 conntrack->timeout.function((unsigned long)
>>                                             conntrack);
>>         return -NF_REPEAT;
>
> With your description I could reproduce the bug and actually you were
> completely right: the code above is incorrect. Somehow I was able to
> misread RFC1122 and mixed the roles :-(:
>
>   When a connection is >>closed actively<<, it MUST linger in
>   TIME-WAIT state for a time 2xMSL (Maximum Segment Lifetime).
>   However, it MAY >>accept<< a new SYN from the remote TCP to
>   reopen the connection directly from TIME-WAIT state, if it:
>   [...]
>
> The fix is as follows: if the receiver initiated an active close, then th=
e
> sender may reopen the connection - otherwise try to figure out if we hold
> a dead connection.
>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Thank you, it seems that this patch solved my problem.

Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>

Best regards,

 =09=09=09=09=09Krzysztof Ol=EAdzki
---187430788-1171873723-1192110600=:4674--
