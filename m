From: "Ricky Foo" <blue_pion@hotmail.com>
Subject: Direction Confusion
Date: Mon, 16 Jun 2003 04:06:58 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Sea2-F28lQtNFoNEwBI0002375a@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

For the netbios name service protocol, it is not request-reply based. I have 
observed from ethereal that the client machine will send a request out but 
will not receive back any replies. Thus for the similar code segment part 
below for my case, what should I put since the connection will never be 
"established" or "related" nor "reply" in any sense?

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
this is the part for FTP:

	/* Until there's been traffic both ways, don't look in packets. */
	if (ctinfo != IP_CT_ESTABLISHED
	    && ctinfo != IP_CT_ESTABLISHED+IP_CT_IS_REPLY) {
		printk("ftp: Conntrackinfo = %u\n", ctinfo);
		return NF_ACCEPT;
	}


    Ricky

_________________________________________________________________
Get 10mb of inbox space with MSN Hotmail Extra Storage 
http://join.msn.com/?pgmarket=en-sg
