From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Inbound packet buffering
Date: Mon, 19 Jan 2004 15:39:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <400BEC10.8030503@eurodev.net>
References: <20040119143454.34247.qmail@web11610.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Doug SC <dougsc@yahoo.com>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20040119143454.34247.qmail@web11610.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi doug!

Doug SC wrote:

>Good Morning.
>
>I have a kernel driver which has registered for
>inbound packets.
>
>nf_register_hook(...NF_IP_PRE_ROUTING...)
>
>I am looking to take action on certain UDP ports on
>packets which may exceed MTU.  I see the fragmented
>packets at this hook and since I can't be certain of
>the order of receipt I need to buffer packets until I
>receive the fragment which contains the ports.
>  
>
If you understood well, you don't want to work with fragmented packets 
anymore or you look for an easy way to handle them, do you?

I have two ideas:

a) load the ip_conntrack module for connection tracking, it gathers all 
the fragments in the NF_IP_PRE_ROUTING hook and fragment them again in 
the NF_IP_POST_ROUTING. So you could register your hook in the 
NF_IP_FORWARD hook instead of  the NF_IP_PRE_ROUTING hook and you won't 
be working with fragmented packets anymore, the conntrack will do that 
work for you.

b) use the same code as ip_conntrack does:

http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_core.c#L826
http://lxr.linux.no/source/net/ipv4/netfilter/ip_conntrack_standalone.c#L201

cheers,
Pablo
