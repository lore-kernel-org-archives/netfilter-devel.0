From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How to close connction in syn_table?
Date: Mon, 17 Jun 2002 13:58:57 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206171358.57308.hno@marasystems.com>
References: <02061712495100.00883@proxima.dsi.unive.it>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Bolzoni Damiano <dbolzoni@almach.dsi.unive.it>,
	netfilter-devel@lists.samba.org
In-Reply-To: <02061712495100.00883@proxima.dsi.unive.it>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is probably not the correct forum for questions on how to code against 
the Linux TCP/IP stack internals. This forum is about the netfilter framework 
that runs in parallell to the TCP/IP stack, in almost all aspects 
disconnected from the TCP/IP stack.

For questions relating details to the actual TCP/IP implementaion of Linux the 
linux-net  or lkml mailinglists is most likely a much safer bet.

What I can tell is that you are most likely not supposed to be calling into 
the TCP/IP stack from netfilter hooks unless you know exacly how to go about 
it (if at all possible). 

Regards
Henrik

Bolzoni Damiano wrote:
> Hi, I would like to close connection in SYN_RECV state.
> In order to do this, I look at syn_table, then call tcp_synq_drop but
> system craches...
> Does anyone know why?
>
> damiano
