From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: change ip address in the hook
Date: Tue, 30 Mar 2004 08:13:53 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40690211.4030606@netlab.hut.fi>
References: <20040328215738.GA19392@mail.xprtsol.com>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: lmn@mail.xprtsol.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi!

Can you be a bit more precise in what you do when you "change the ip 
address of a packet in the LOCAL_OUT hook and let it send out"? What are 
all the operations you do? Which address (source / destination) do you 
change? Do you calculate a new IP checksum after having changed the IP 
address?

       Emmanuel


lmn@mail.xprtsol.com wrote:

>Hi,
>
>For example, I want to change the ip address of a packet in the LOCAL_OUT hook and let it send out, but I didn't see the packet on the wire. (Route for the modified ip addresses existed.) Similar things happen for the PRE_ROUTING hook. This is like doing the NAT manually.
>
>If I use iptables command to add a rule doing the similar function, I can see the packet was sent out. So what is the difference inside these two approaches?
>
>Thanks,
>
>LMN
>
>  
>
