From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: RPC Conntrack - DUMP - fragmentation
Date: Wed, 31 Mar 2004 22:11:31 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403312204130.24487-100000@filer.marasystems.com>
References: <47D438A0510BD611B9470002A58EDAE703BE6962@mchh2a6e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "'netfilter-devel@lists.netfilter.org'" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Lockenvitz Jan EXT <Jan.Lockenvitz.extern@icn.siemens.de>
In-Reply-To: <47D438A0510BD611B9470002A58EDAE703BE6962@mchh2a6e.mchh.siemens.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 31 Mar 2004, Lockenvitz Jan EXT wrote:

> And now the Problem: The DUMP Response is listing all RPC Services the Server offers and 
> so the packet length would be about 400 Byte. And the packet is fragmentet !!
> Well, I don't know why the TCP packet needs to be fragmentet at 400 byte? The MTU is set to 1500.
> Our main problem is, how can we handle the fragmented packets in the netfilter achitecture???

As this is a conntrack helper I assume you talk about application
fragmented data, not fragmented packets..  application fragmented data is
where one part of the response sent in one TCP/UDP segment and another
part in the next segment. This unfortunately is very hard to deal with
within netfilter.

conntrack forcibly defragments fragmented IP packets, but it can do 
nothing about application fragmented data.

> We can already check whether the DUMP response is fragmeted or not. But we don't know how
> to concatenate the information from both fragments.

You need to keep a memory in the connection state.

A probably better approach for protocols like this is to send the traffic 
to a userspace proxy via REDIRECT/TPROXY. Here you have the benefit of 
full stream reassembly and other good things and much less headache from 
these issues..

Another much messier approach would be to fake ACK (or whatever 
continuation messages used by the transport protocol) to be able to 
reconstruct the datastream before it is forwarded. This is hoever 
considered black magic and should not be taken lightly.. there is numerous 
reasons why this is not a good idea.

Regards
Henrik
