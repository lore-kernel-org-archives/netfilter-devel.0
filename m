From: Venkata Narayana <mesg2nari@yahoo.com>
Subject: Re: REDIRECT changes DST address of the packet
Date: Tue, 26 Jul 2005 01:27:08 -0700 (PDT)
Message-ID: <20050726082708.3234.qmail@web60817.mail.yahoo.com>
References: <42E581D4.10402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42E581D4.10402@trash.net>
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

Thank you Patrick. 

Here I'm using single fd wor multiple addresses. so
theoritically speaking it won't work with this... In
udp recvmsg function if we can get the address then 
it  sounds good.

If I am wrong sorry for that.

Thanks,
Venkat


--- Patrick McHardy <kaber@trash.net> wrote:

> Patrick McHardy wrote:
> > Venkata Narayana wrote:
> > 
> >> I am able to get the original dst address when I
> am
> >> using tcp connection.
> >> How can I get with UDP???
> > 
> > Does this patch help? It should make
> SO_ORIGINAL_DST usable
> > with UDP as well.
> > 
> > diff --git
> a/net/ipv4/netfilter/ip_conntrack_core.c
> b/net/ipv4/netfilter/ip_conntrack_core.c
> > --- a/net/ipv4/netfilter/ip_conntrack_core.c
> > +++ b/net/ipv4/netfilter/ip_conntrack_core.c
> > @@ -1310,9 +1310,8 @@ getorigdst(struct sock *sk,
> int optval, 
> >  	tuple.dst.u.tcp.port = inet->dport;
> >  	tuple.dst.protonum = IPPROTO_TCP;
> 
> Please try this patch instead, I missed the above
> line.
> > [NETFILTER]: Make SO_ORIGINAL_DST usable for UDP
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> ---
> commit 59740eead041f1e9c22555a5107bf9ca98a780da
> tree a4d80f970e9fa526bff6c173cfe6d5a0610279a4
> parent eb82d02518ac3a400663163995097749d91c7c4c
> author Patrick McHardy <kaber@trash.net> Tue, 26 Jul
> 2005 02:19:09 +0200
> committer Patrick McHardy <kaber@trash.net> Tue, 26
> Jul 2005 02:19:09 +0200
> 
>  net/ipv4/netfilter/ip_conntrack_core.c |    7
> +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/ip_conntrack_core.c
> b/net/ipv4/netfilter/ip_conntrack_core.c
> --- a/net/ipv4/netfilter/ip_conntrack_core.c
> +++ b/net/ipv4/netfilter/ip_conntrack_core.c
> @@ -1308,11 +1308,10 @@ getorigdst(struct sock *sk,
> int optval, 
>  	tuple.src.u.tcp.port = inet->sport;
>  	tuple.dst.ip = inet->daddr;
>  	tuple.dst.u.tcp.port = inet->dport;
> -	tuple.dst.protonum = IPPROTO_TCP;
> +	tuple.dst.protonum = sk->sk_protocol;
>  
> -	/* We only do TCP at the moment: is there a better
> way? */
> -	if (strcmp(sk->sk_prot->name, "TCP")) {
> -		DEBUGP("SO_ORIGINAL_DST: Not a TCP socket\n");
> +	if (sk->sk_protocol != IPPROTO_TCP &&
> sk->sk_protocol != IPPROTO_UDP) {
> +		DEBUGP("SO_ORIGINAL_DST: Not a TCP/UDP
> socket\n");
>  		return -ENOPROTOOPT;
>  	}
>  
> 


__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
