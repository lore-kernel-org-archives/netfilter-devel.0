From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re:RPC conntrack code status
Date: Sat, 27 Mar 2004 10:47:41 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403270047.i2R0lfv12960@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: <andreas@conectiva.com.br>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Eduardo Pereira Habkost" <ehabkost@conectiva.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Hello Eduardo,

  I don't know about its permanent inclusion, but from the dev side,
I had half of the code I needed to be able to add a caching system
to the module (so that RPC calls that didn't go to the portmapper
first could still be resolved using a slab cache of current RPC
map ents + a cache refresher to retrieve new map ents when
desired from the portmapper) - I then wanted to add a modifier that
would only allow a source IP to see the map ents of calls that it
was allowed to make (otherwise the rpc portmapper could still be
used for information gathering).  It was not near completion, and 
I have spent the past 6months on openMosix rather than my 
netfilter code (due to need mostly).

  I don't actively use the current code - but I haven't had any
complaints with it -- outside of a lack of support for the rsh-via-rpc
required for one of the backup solutions - which I didn't get back to.



----- Original Message -----
>From: "Eduardo Pereira Habkost" <ehabkost@conectiva.com.br>
>To: <netfilter-devel@lists.netfilter.org>
>Subject:  RPC conntrack code status
>Date: Fri, 26 Mar 2004 11:55:54 -0300
>
> 
> Hi, All,
> 
> I've been looking at the Netfilter RPC conntrack module, and I would
> like to know the status of the permanent inclusion of this module. Is
> this module considered stable and there are plans to include it, soon?
> 
> Regards,
> 
> -- 
> Eduardo
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
