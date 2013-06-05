From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Locally transmitted Multicast packets are being looped back,
 even if IP_MULTICAST_LOOP option is set to zero
Date: Wed, 05 Jun 2013 07:20:07 -0700
Message-ID: <1370442007.24311.258.camel@edumazet-glaptop>
References: <51AF172C.9090803@india.tejasnetworks.com>
	 <1370440003.24311.249.camel@edumazet-glaptop>
	 <51AF4789.9090807@india.tejasnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Vijay Tandeker <vijayt@india.tejasnetworks.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <51AF4789.9090807@india.tejasnetworks.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 2013-06-05 at 19:43 +0530, Vijay Tandeker wrote:
> Thanks Eric for your quick reply. Sorry but in linux-2.6.32, IP_NODEFRAG 
> option is not supported. Is this a new socket option to fix this problem ?
> 
> Regards,
> Vijay
> 
> On Wednesday 05 June 2013 07:16 PM, Eric Dumazet wrote:
> > On Wed, 2013-06-05 at 16:17 +0530, Vijay Tandeker wrote:
> >
> >    
> >> My questions:-
> >>    - Is this done intentionally ?
> >>    - If No, please suggest the solution to restore skb->sk pointer.
> >>    - If Yes, please suggest the solution to restore skb->sk pointer.
> >>
> >> Kindly let me know in case if the problem is not clear or you need any
> >> more data.
> >>
> >>      
> > Have you tried
> >
> > int one = 1;
> > setsockopt(fd, SOL_IP, IP_NODEFRAG,&one, sizeof(one));

Yes, it was added in 2.6.36

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=7b2ff18ee7b0ec4bc3162f821e221781aaca48bd



