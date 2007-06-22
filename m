From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070620_2
Date: Fri, 22 Jun 2007 15:22:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706221516420.26568@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706221331530.26568@fbirervta.pbzchgretzou.qr>
	<467BB5DE.8010609@trash.net>
	<Pine.LNX.4.64.0706221420090.26568@fbirervta.pbzchgretzou.qr>
	<467BC39F.2030107@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Andrew Beverley <andy@andybev.com>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467BC39F.2030107@trash.net>
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


On Jun 22 2007 14:42, Patrick McHardy wrote:
>> 
>> Conntrack states are needed. For TCP this is TCP_CONNTRACK_TIME_WAIT.
>> Hence I think all states that could possibly exist (as far as conntrack is
>> concerned) are listed in netfilter/nf_conntrack_<proto>.h
>
>Indeed, its in include/linux/netfilter/nf_conntrack_sctp.h.
>I'm wondering why its looking at the states though, a conntrack
>in TIME_WAIT state is still a conntrack.

The original author thought that a TIME_WAIT socket does not count
towards the limit anymore (interpreting the code). Seems reasonable.
Does SCTP does not have the concept of TIME_WAIT - does SCTP end
with that is known in TCP land by "LAST_ACK"?
If so, then all is well with SCTP and no extra state check if needed for SCTP.

>> Yes there is a user-administrator race. For example,
>>  * host opens N connections (and hits the connlimit limit) and new
>>    connections are rejected
>>  * administrator reloads ip tables
>>  * now, the next N that are seen -- which may not even be the *original*
>>    connections -- are allowed, so the older ones could get magically
>>    disconnected.
>
>That sucks a bit.

Well give me your stance on this. Do I have to change that now?


Thanks,

	Jan
-- 
