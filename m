From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] TCP simultaneous open support
Date: Tue, 02 Jun 2009 13:42:32 +0200
Message-ID: <4A251028.6020300@netfilter.org>
References: <alpine.DEB.2.00.0905311614330.760@blackhole.kfki.hu> <4A250DDA.1010406@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org,
	Saatvik Agarwal <saatvik.agarwal@stanford.edu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35524 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZFBM2T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:28:19 -0400
In-Reply-To: <4A250DDA.1010406@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jozsef Kadlecsik wrote:
>> Hi Patrick,
>>
>> The patch below adds supporting TCP simultaneous open to conntrack.
>> The unused LISTEN state is replaced by a new state (SYN_SENT2)
>> denoting the second SYN sent from the reply direction in the new case.
>> The state table is updated and the function tcp_in_window is modified
>> to handle simultaneous open.
>>
>> The functionality can fairly easily be tested by socat. A sample
>> tcpdump recording
>> ...
>> and the corresponding netlink events:
>>
>>     [NEW] tcp      6 120 SYN_SENT src=192.168.0.254 dst=192.168.0.1
>> sport=2020 dport=2020 [UNREPLIED] src=192.168.0.1 dst=192.168.0.254
>> sport=2020 dport=2020
>>  [UPDATE] tcp      6 120 LISTEN src=192.168.0.254 dst=192.168.0.1
>> sport=2020 dport=2020 src=192.168.0.1 dst=192.168.0.254 sport=2020
>> dport=2020
>>  [UPDATE] tcp      6 60 SYN_RECV src=192.168.0.254 dst=192.168.0.1
>> sport=2020 dport=2020 src=192.168.0.1 dst=192.168.0.254 sport=2020
>> dport=2020
>>  [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.0.254
>> dst=192.168.0.1 sport=2020 dport=2020 src=192.168.0.1
>> dst=192.168.0.254 sport=2020 dport=2020 [ASSURED]
>>
>> The RST packet was dropped in the raw table, thus it did not reach
>> conntrack.  nfnetlink_conntrack is unpatched so it shows the new
>> SYN_SENT2 state as the old unused LISTEN.
>>
>> With TCP simultaneous open support we satisfy REQ-2 in RFC 5382 ;-).
>>
>> Additional minor correction in this patch is that in order to catch
>> uninitialized reply directions, "td_maxwin == 0" is used instead of
>> "td_end == 0" because the former can't be true except in uninitialized
>> state while td_end may accidentally be equal to zero in the mid of a
>> connection.
> 
> Thanks Jozsef. Just one question:
> 
>> -    TCP_CONNTRACK_LISTEN,
>> +    TCP_CONNTRACK_SYN_SENT2,
> 
> is this constant already used in userspace? From your conntrack
> output above I'd assume the answer is yes, so we should keep it
> around as an alias to avoid compilation errors.

libnetfilter_conntrack keeps its own copy of it in user-space. libnl
seems not to do it, so the alias would be a good idea.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
