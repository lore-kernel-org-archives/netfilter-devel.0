From: Venkata Narayana <mesg2nari@yahoo.com>
Subject: Re: REDIRECT changes DST address of the packet
Date: Mon, 1 Aug 2005 07:24:31 -0700 (PDT)
Message-ID: <20050801142431.9492.qmail@web60822.mail.yahoo.com>
References: <42E60796.2060909@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42E60796.2060909@trash.net>
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


Hello Patric/Krisztian,

As Mr Krisztian suggested I was able to patch the
2.6.11 kernel with tproxy but trying to use
IP_RECVORIGADDRS socket option on udp socket. If it is
natted traffic I am unable to receive the message.
Can you suggest the alternative mechanism to get the
original DSt address in UDP transaction.

Thanks,
Venkat.



--- Patrick McHardy <kaber@trash.net> wrote:

> KOVACS Krisztian wrote:
> 
> >   Patrick, I'm afraid this is not enough for a
> full-featured UDP
> > solution. If you're using a single socket to
> receive UDP packets sent to
> > multiple original addresses this approach simply
> fails. A better
> > solution would require receiving the original
> destination address in a
> > per-packet manner.
> 
> You're right, it doesn't work for unconnected
> sockets. I'm looking into
> other possibilities now. I'm thinking of something
> similar to
> SIOCGSTAMP - altough this would require increasing
> the size of struct
> sock.
> 
> >   We're using something similar as part of the
> transparent proxying
> > patchset, but unfortunately this requires
> enlarging the skb and is a
> > little hackish. The patch introduces an
> IP_RECVORIGADDRS socket option.
> > If you enable this sockopt on a UDP socket, then
> recvmsg() will return
> > the original addresses as a control message.
> 
> Why does the skb need to be enlarged?
> 
> Regards
> Patrick
> 



		
____________________________________________________
Start your day with Yahoo! - make it your home page 
http://www.yahoo.com/r/hs 
 
