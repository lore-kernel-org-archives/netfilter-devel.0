From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_proto_sctp INIT_ACK messages dropped
Date: Fri, 18 Feb 2005 01:50:54 +0100
Message-ID: <42153BEE.7@trash.net>
References: <009e01c5137d$b751fa90$320aa8c0@blueslicemtl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: 'Harald Welte' <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Kiran Kumar Immidi <immidi@spymac.com>
To: Ariel Rosenblatt <ariel@blueslice.com>
In-Reply-To: <009e01c5137d$b751fa90$320aa8c0@blueslicemtl>
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

Ariel Rosenblatt wrote:

>Hello Patrick,
>
>That is true, the conntrack must not change after the INIT_ACK is sent, and
>as matter of fact once the endpoint sent the INIT_ACK it should do nothing
>else to avoid DOS attacks; this until the 4-way cookie based handshake is
>done and the TCB created. The COOKIE ECHO for an existing TCB case is
>handled in 5.2.4, the special case I brought up is 5.2.4.A (Association
>restart, 5.2.4.1).
>
>The endpoint receiving the INIT_ACK is the "other" endpoint. So if the tag
>was not properly saved when the INIT message left the originating endpoint
>the INIT_ACK generated as a reply to the unexpected INIT will get dropped at
>the INIT originating endpoint.
>
>Note that the INIT_ACK is _NOT_ unexpected as the originating endpoint
>previously sent an INIT (unexpected INIT_ACKs should always be discarded,
>section 5.2.3), without the patch the INIT_ACK is being silently discarded.
>The patch saves the initialization tag for the outgoing INIT, which will be
>needed later to verify the incoming INIT_ACK. Without this a lost
>association (e.g. power failure) can never be re-established before the
>ESTABLISHED_TIMEOUT (currently set to 5 days) expires.
>
>It is the destination endpoint that receives an unexpected INIT and it is
>therefore bound to reply with an INIT_ACK, to get the 4-way handshake going
>(section 5.2.2). However, as I mentioned above, the destination endpoint
>shouldn't modify the existing association TCB or create a new one, otherwise
>the destination endpoint will be vulnerable to DOS attacks.
>  
>
As is conntrack if it modifies the saved tag of an established connection
without looking for a valid exchange of Tie-Tags and COOKIE-ECHO, if I don't
completely misunderstand. Someone simply needs to send an INIT for an 
existing
association and can prevent further packets from getting through. But I 
think
you're patch is what is intended by the code, so we probably should put 
it in
for now. Kiran, could you have a look at Ariel's patch please ?

Thanks,
Patrick
