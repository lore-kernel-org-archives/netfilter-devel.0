From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re:RPC Conntrack - DUMP - fragmentation
Date: Fri, 02 Apr 2004 11:01:52 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404020101.i3211rp11163@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Lockenvitz Jan EXT" <Jan.Lockenvitz.extern@icn.siemens.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Jan,

  The biggest issue here is the RPC layer is not actually "reconstructed'
in memory.  This essentially means that while we have a state machine
in the transport layers, we are still just packet filtering at the application
layers.

  So, to look forward, what you (we all) really want is for the RPC
module to store a complete "dump" of the RPC processes available
from each "server" that it can see.  You then really want the RPC
module to build its own RPC DUMP output based on what RPC 
procedures any give "client" is permitted to see (made up of data 
we already have in our DUMP memory table).

  The real work comes in when you realise that you need some sort
of "cache refresher" that will allow the RPC module to make its own
DUMP request of the server being interrogated, to assure that the 
local memory procedure map is still correct. 
  It was at this stage that I got bogged down last time (I'd built myself 
a library for kernel level network calls - lifted partly from the khttpd, 
and partly from other open sources).  I got trapped in memory 
management and in ONC RPC network packet structures.  A 
presentation I went to recently had an ONC RPC packet fully mapped
 - the presenter reads here - I am yet to ask him for that slide -- but it 
will help a fair bit.


  In short, there appear to be stability issues that must be resolved 
first.  Then, the "smarter" code needs to be worked on.  I originally
upgraded the RPC connection tracker out of sheer spite for the pain
that the CheckPoint Firewall-1 RPC "helper" had caused me.  I am
keen to add the features above, but time is a killer (particularly
between now and July).

  If you've got code samples that will help with your features being
supported, then post them up to the list here.  The caching software
should give you the rest of your solution - when its written.




Regards,





----- Original Message -----
>From: "Lockenvitz Jan EXT" <Jan.Lockenvitz.extern@icn.siemens.de>
>To: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
>Subject:  RPC Conntrack - DUMP - fragmentation
>Date: Wed, 31 Mar 2004 17:13:08 +0200
>
> Hi,
> 
> we (my colleague and me) tried to track NFS  between two LINUX boxes with the 
> RPC Conntracking modules installed via P-O-M. Well, we wondered why this was not 
working.
> So we had a look into the sources.
> It loks like the RPC modules cannot handle DUMP requests and responses (only GET
> seems to be possible). So we (mainly my colleague) started to insert some code for the
> DUMP packets. And it is already working some how ;-)
> 
> And now the Problem: The DUMP Response is listing all RPC Services the Server offers 
and 
> so the packet length would be about 400 Byte. And the packet is fragmentet !!
> Well, I don't know why the TCP packet needs to be fragmentet at 400 byte? The MTU is set 
to 1500.
> Our main problem is, how can we handle the fragmented packets in the netfilter 
achitecture???
> 
> We can already check whether the DUMP response is fragmeted or not. But we don't 
know how
> to concatenate the information from both fragments.
> 
> Thanx in advance,
> Jan
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
