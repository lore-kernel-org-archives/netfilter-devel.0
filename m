From: Patrick Schaaf <bof@bof.de>
Subject: Re: IP Queue and fragmentation
Date: Fri, 14 Feb 2003 09:44:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030214084448.GA7631@oknodo.bof.de>
References: <C3F7A1AD0781F84784B5528466CA09DD04F4E0@megisto-sql1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Manickavel Subramaniraj <MSubramaniraj@MEGISTO.com>
Content-Disposition: inline
In-Reply-To: <C3F7A1AD0781F84784B5528466CA09DD04F4E0@megisto-sql1>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

>     I need some help in IP queue. I am passing IP packets to user space
> using IP Queue by setting up iptables as follows 
>  
> iptables -A FORWARD -p udp -d 10.10.0.0/16 - j QUEUE
>  
> What I am trying to do is in Linux 2.4 kernel is to create a  transparent
> proxy(UDP), where application needs reassembled IP packet.

Any reason why you don't use the nat table's REDIRECT target?

> 1) Is any thing that I can do to reassemble the packet before sending to
> user space?

As an example of how to gather the fragments, grep for skb_linearize
in net/ipv4/netfilter/ip_conntrack_core.c. When conntracking is active,
all packets will be defragmented by the kernel. All the nat functionality
is implemented with the assumption of defragmented packets, that's why
it is done that way.

If using conntrack is not an option for you, you could extend the QUEUE
target implementation to take an option, which tells it to reassemble
on the kernel side, just like ip_conntrack_core.c does. Such an option
may be generally useful, so I think it could be welcome.

> 2) Is there any user space reassembly code available?. so I can try to
> reassemble the packet in user space.

I don't know of any, but it shouldn't be too hard to write. On the other
hand the kernel already has all the infrastructure, so it would be a bit
ugly to duplicate that.

best regards
  Patrick
