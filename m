From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Problem with sk_buff
Date: Fri, 7 Jun 2002 21:09:39 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206072109.39147.hno@marasystems.com>
References: <000501c20e56$44f88830$c9907450@CHICCA>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Damiano Bolzoni" <damiano.bolzoni@tin.it>,
	<netfilter-devel@lists.samba.org>
In-Reply-To: <000501c20e56$44f88830$c9907450@CHICCA>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Damiano Bolzoni wrote:
> Hi people,
> I wrote a kernel module that uses netfilter. I'm interested on incoming IP
> packets that carry a TCP segment with SYN flag active. What I want to do is
> to know which socket has been created in order to handle that connection
> and I want to close it. sk_buff holds two pointer: struct sock* and struct
> socket* but they point to NULL.
> At this time I can test if the TCP segment has the SYN flag set but I can't
> close the socket...
> Anyone can help me?

This is too early in the packet processing path. The socket is not yet known. 
These fields is only valid on locally generated packets (outgoing/sent 
packets).

You will need to make a call into the TCP/IP kernel to look up the local 
socket.

Regards
Henrik
