From: Steve Hill <steve@navaho.co.uk>
Subject: Re: memory leak related to bridging, conntrack and frags in 2.6.0
Date: Fri, 12 Dec 2003 16:11:38 +0000 (GMT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312121606000.8670-100000@sorbus2.navaho>
References: <20031212155543.GD14920@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andy Loukes <andy@navaho.co.uk>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031212155543.GD14920@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 12 Dec 2003, Harald Welte wrote:

> are you sure it's a memory leak?  Please explain why.  Which number in
> /proc/slabinfo are you looking at?  And did you confirm that this is not
> just some cache that expires after some time?

I am looking into this too - size-64 is increasing (and keeps increasing 
until the box dies after it's filled all 128MB of RAM).

The memory that is leaking seems to be allocated on line 299 on 
net/bridge/br_netfilter.c:
  
        if ((nf_bridge = nf_bridge_alloc(skb)) == NULL)
                return NF_DROP;
  
Only the first fragment gets freed later on, all the other fragments seem 
to get leaked during defragmentation.  (I'm not an expert on netfilter, 
but I presume that the defrag routines defragment the packet and puts it 
in the first skb, leaving the skbs for the other packets needing to be 
freed?)

-- 

- Steve Hill
Senior Software Developer                        Email: steve@navaho.co.uk
Navaho Technologies Ltd.                           Tel: +44-870-7034015

        ... Alcohol and calculus don't mix - Don't drink and derive! ...
