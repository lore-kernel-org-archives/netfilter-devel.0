From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re:Direction Confusion
Date: Mon, 16 Jun 2003 14:31:40 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306160431.h5G4VfN22466@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Ricky Foo" <blue_pion@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Ricky,

  The FTP module (which I studied profusely to build the RSH and RPC
modules) does that because the FTP protocol runs over TCP.  Most
of the NetBios guff is udp based ... and udp broadcasts at that.

  If you want to make a module/helper decision based on the UDP
broadcasts that are "leaving" your system/LAN, then you assess
the outgoing packet(s) .. ie .. seek the original direction .. and hunt
through the data in the packet(s).


Regards,

----- Original Message -----
>From: "Ricky Foo" <blue_pion@hotmail.com>
>To: <netfilter-devel@lists.netfilter.org>
>Subject:  Direction Confusion
>Date: Mon, 16 Jun 2003 04:06:58 +0000
>
> Hi all,
> 
> For the netbios name service protocol, it is not request-reply based. I have 
> observed from ethereal that the client machine will send a request out but 
> will not receive back any replies. Thus for the similar code segment part 
> below for my case, what should I put since the connection will never be 
> "established" or "related" nor "reply" in any sense?
> 
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> this is the part for FTP:
> 
> 	/* Until there's been traffic both ways, don't look in packets. */
> 	if (ctinfo != IP_CT_ESTABLISHED
> 	    && ctinfo != IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
> 		printk("ftp: Conntrackinfo = %un", ctinfo);
> 		return NF_ACCEPT;
> 	}
> 
> 
>     Ricky
> 
> _________________________________________________________________
> Get 10mb of inbox space with MSN Hotmail Extra Storage 
> http://join.msn.com/?pgmarket=en-sg
> 
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
