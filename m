From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Developing with libipq
Date: Thu, 14 Oct 2004 20:10:32 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <416EC118.7000209@eurodev.net>
References: <20041014192019.3832d581.tigrezno@log01.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jvalencia <tigrezno@log01.org>
In-Reply-To: <20041014192019.3832d581.tigrezno@log01.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Jvalencia wrote:

>Hi all, i'm new to netfilter and just started trying some simple things.
>I've made a program (simple program) to take a packet and print its metadata.
>The output is this:
>
>ID of queued packet: 3413885640
>Netfilter mark value: 0
>Packet arrival time (seconds): 0
>Packet arrival time (+useconds): 0
>Netfilter hook we rode in on: 3
>  
>

You are enqueing packets in the localout hook.

#define NF_IP_LOCAL_OUT         3

>Name of incoming interface: 
>Name of outcoming interface: eth0
>Hardware protocol: 0
>Hardware type: 0
>Hardware address length: (null)
>Hardware address: 
>Length of packet data: 0
>
>
>Is this result valid? most values are 0
>  
>

yes, in localout hook the packets are in network layer, so they don't 
still know anything about the link layer information, that is, mac 
address and folks.

regards,
Pablo
