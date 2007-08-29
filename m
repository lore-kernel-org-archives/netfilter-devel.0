From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: looking up a flow in the kernel structures given its identifier
Date: Wed, 29 Aug 2007 07:59:23 -0300
Message-ID: <20070829105923.GC10015@ghostprotocols.net>
References: <20070828202109.GA10015@ghostprotocols.net>
	<136296.34208.qm@web26601.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Sirine Chaitou <schit_2007@yahoo.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <136296.34208.qm@web26601.mail.ukl.yahoo.com>
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

Em Tue, Aug 28, 2007 at 11:48:55PM +0200, Sirine Chaitou escreveu:
> Thanks a lot for your help.
> Well, my purpose is to overwrite the initial sequence
> number of a connection which has been already in the
> SYN_RECV state.

Now you provide more information, great. __inet_lookup for connections
in the SYN_RECV state will return the master socket, the one in LISTEN
state. Look at:

 tcp_v4_rcv
   tcp_v4_do_rcv
     tcp_v4_hnd_req
       inet_csk_search_req

  Here you'll get a struct request_sock, then look at:

         tcp_check_req

  Where you'll see tcp_rsk(req)->rcv_isn.

Sockets in the SYN_RECV state are minisocks, a technique used to save
memory on this embrionic state.

What you want is there, on the tcp_request_sock minisock hierarchy:

The things that are common for any protocol wanting to use this
hierarchy, not necessarily AF_INET even, are in struct request_sock.

Then you have struct inet_request_sock, that is what is common for
AF_INET protocols, v4 or v6. It is an specialization of struct
request_sock:

struct inet_request_sock {
  struct request_sock req;
  ...
}

Then you have tcp_request_sock with what is required for a TCP
connection:

struct tcp_request_sock {
  struct inet_request_sock req;
  ...
}

When the 3way handshake finishes the minisock is promoted to a
full struct tcp_sock in tcp_check_req, right here:


		/* OK, ACK is valid, create big socket and
		 * feed this segment to it. It will repeat all
		 * the tests. THIS SEGMENT MUST MOVE SOCKET TO
		 * ESTABLISHED STATE. If it will be dropped after
		 * socket is created, wait for troubles.
		 */
		child = inet_csk(sk)->icsk_af_ops->syn_recv_sock(sk, skb,
								 req, NULL);

inet_csk(sk)->icsk_af_ops->syn_recv_sock for TCP is:

struct inet_connection_sock_af_ops ipv4_specific = {
    ...
    .syn_recv_sock = tcp_v4_syn_recv_sock,
    ...
}

Look at tcp_v4_syn_recv_sock and you'll see that it calls
tcp_create_openreq_child passing the master socket and the minisock
representing the just finished 3way handshake and look at what it does
to treq->snt_isn and treq->rcv_isn.
 
> what I am given is the minimal state corresponding to
> <src_ip, dst_ip,s_port,d_port,isn> where isn is the
> new sequence number.
> 
> I tried the following as in tcp_v4.c:
> struct sock *sk;
> sk =inet_lookup (&tcp_hashinfo, src, dst, p_src,
> p_dst, inet_iif (skb));
> if (!sk)
>   goto no_tcp_socket;
> if (sk->sk_state != TCP_SYN_RECV)
>   goto state_error;
> no_tcp_socket:
>   printk ("%s: no socket corresponds to this
> connection state",__FUNCTION__);
> state_error:
>   printk ("%s: connection corresponding not in a
> TCP_SYN_RECV state",__FUNCTION__);
> 
> The problem is that I can't see how to get a pointer
> to the tcp_initial_sequence number corresponding to
> that socket.

What I described should be enough for you.

In the future please don't add "Very urgent", as someone else says this
annoys people. Also please don't start private conversations, this
discussion should be public so that in the future people in your current
situation can help themselves with google, its not always that people
are in the mood for answering such questions.

Regards,

- Arnaldo
