From: Patrick Schaaf <bof@bof.de>
Subject: Re: ALGs
Date: Wed, 4 Jun 2003 09:25:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030604072535.GB10472@oknodo.bof.de>
References: <Sea2-F11MieZutGvO8n00003af5@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ricky Foo <blue_pion@hotmail.com>
Content-Disposition: inline
In-Reply-To: <Sea2-F11MieZutGvO8n00003af5@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Ricky,

> Some doubts about the conntrack helper module.

A note: I have not written helper modules myself; the following answers
are from what I learned passively.

> 1. For the "help" callback, what exactly am I suppose to do with the 
> packets when this function is activated?

Find and update state information according to the packet's content,
make neccessary modifications to the packet, or the packet metadata.
All according to what your special protocol needs.

> 2. For the netbios protocol, there are a couple of ports to monitor, such 
> as 137 for name-service, 138 for datagram service, 139 for session service. 
> Does that mean I have to write 3 different tracking modules or do I follow 
> what has been done in the ftp module...i.e register the 3 different ports 
> to track.

Is it conceivable that people would like to use only a subset of the
possible combinations of those three protocols? If the answer is "yes",
then it may make good sense to implement three separate modules.

If the answer is "no, never", and you are a believer in such absolutes,
then throw it all into one file.

> 3. In the corresponding header files, what do we normally have to define 
> for the various structure? I kinda got confused by what I have read from 
> the source code!

If you don't need to keep any state, you shouldn't need to define any
structure in your header files.

If you do need to keep per-connection structure, look into the header
file include/linux/netfilter_ipv4/ip_conntrack.h. Search for the
definition of 'struct ip_conntrack'. Look at the 'union {} help'
inside that struct. You are supposed to add another struct,
defined by yourself, into this union.

> 4. How do I get to the payload part where the netbios data-fields are?

Look at how other help() implementations do it. For example, in the
ftp protocol helper, the first line of the help() function reads

	struct tcphdr *tcph = (void *)iph + iph->ihl * 4;

'iph' is the IP (layer 3) protocol header. This line uses the
IP header length field to get a pointer to the first byte of
layer 4 data. You need practically the same, but probably
casting into a 'struct udphdr', instead of a 'struct tcphdr'.

> Please pardon me if my questions do seems silly to you guys.

They do seem unoriented, but that's quite normal for people who
meet a significant blob of software for the first time. I hope
I could help you along a bit.

best regards
  Patrick
