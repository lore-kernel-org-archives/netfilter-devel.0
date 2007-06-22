From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070620_2
Date: Fri, 22 Jun 2007 14:42:07 +0200
Message-ID: <467BC39F.2030107@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706221331530.26568@fbirervta.pbzchgretzou.qr>
	<467BB5DE.8010609@trash.net>
	<Pine.LNX.4.64.0706221420090.26568@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Andrew Beverley <andy@andybev.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706221420090.26568@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jun 22 2007 13:43, Patrick McHardy wrote:
> 
>>I didn't realize that. Still, why doesn't it support all protocols?
> 
> 
> It suppers all protocols that Netfilter supports, surprise surprise :)
> -A OUTPUT -p udp -m connlimit uses what Netfilter considers an UDP
> connection. /proc/net/ip_conntrack shows that. Of course these UDP
> "connections" expeire within 30 seconds by default, but that's another problem. 


OK, that fine then.


> 
> 
>>>>Also nothing guarantees that you're looking at a TCP connection here.
> 
> 
> Which is why I asked how to find out I am actually looking at TCP.
> There's tuple.proto or the proto field in struct nf_conn, but the question is,
> which one should I use, or are both the same?
> 
> 
>>>True that. What is the SCTP state (include/linux/netfilter/nf_conntrack_tcp.h)
>>>I am looking for? (And DCCP does not seem to have states.)
>>
>>SCTP states are defined in the .c file itself I think.
> 
> 
> Conntrack states are needed. For TCP this is TCP_CONNTRACK_TIME_WAIT.
> Hence I think all states that could possibly exist (as far as conntrack is
> concerned) are listed in netfilter/nf_conntrack_<proto>.h


Indeed, its in include/linux/netfilter/nf_conntrack_sctp.h.
I'm wondering why its looking at the states though, a conntrack
in TIME_WAIT state is still a conntrack.

>>>Sorry, what state?
>>>Each rule keeps its own list of known connections, yes :-/
>>
>>Thats the state. It will forget them every time you change _anything_
>>in the ruleset. On second though, I guess it doesn't matter because
>>the state can be entirely reconstructed at runtime?
> 
> 
> Yes there is a user-administrator race. For example,
>  * host opens N connections (and hits the connlimit limit) and new
>    connections are rejected
>  * administrator reloads ip tables
>  * now, the next N that are seen -- which may not even be the *original*
>    connections -- are allowed, so the older ones could get magically
>    disconnected.


That sucks a bit.

> And: a lot more netfilter matches might be affected by this. hashlimit 
> comes to mind. I'd say this is an administrator issue and a justified 
> sacrifice to take.


No, hashlimit looks up the state from a global list. It behaves
strangely when changing parameters without deleting the table
first though.
