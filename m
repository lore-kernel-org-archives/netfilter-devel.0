From: Chandrakanth Chereddi <kanth@hserus.net>
Subject: Re: libipq/payload doubt
Date: Wed, 19 May 2004 12:23:35 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040519065335.GD340@hserus.net>
References: <20040519062032.GA32401@maluco.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ulysses Almeida <munky@maluco.com.br>
Content-Disposition: inline
In-Reply-To: <20040519062032.GA32401@maluco.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 19/05/04 02:20 -0400, Ulysses Almeida wrote:
>   What I could see from ip_queue.c, ipq_packet_msg->payload, comes
> from skb->data. Where can i find (which files) where skb->data is
> filled. 'Cose till now, I don't know what info I can get from
> ipq_packet_msg->payload.

Please have a look at the linux/net/iptv4/netfilter/ip_queue.c source
file. It contains the routines for building the structure from the skb
to be sent to userspace via NETLINK sockets.

> why, when I print those info, I can't get expected ports. port 80 is
> showed as 20480.
> 
>   Do I have to convert something before printing in human readable
> format?

You need to convert from network byte order to host byte order (guessing
that you are using a x86 processor), please use the ntohs() call.

-- 
CCK./	kanth@hserus.net
"Passion and gradualness"	-- Pavlov.
