From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Problem with sk_buff - part 2
Date: Fri, 7 Jun 2002 21:29:37 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206072129.37965.hno@marasystems.com>
References: <003d01c20e58$4a85f880$c9907450@CHICCA>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Damiano Bolzoni" <damiano.bolzoni@tin.it>,
	<netfilter-devel@lists.samba.org>
In-Reply-To: <003d01c20e58$4a85f880$c9907450@CHICCA>
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
> Thank you for answer!
> I thought that was a problem like that.
> What call I have to make? which parameters have to pass?

It is not as simple. The TCP/IP stack is not designed to have others poke 
around into it..

See tcp_ipv4.c:tcp_v4_rcv().

Can you explain again why you want to access the socket from netfilter?

Regards
Henrik
