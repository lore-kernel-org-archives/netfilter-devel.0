From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] linux tproxy support
Date: Mon, 3 Jun 2002 23:29:34 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206032329.34012@henrik.marasystems.com>
References: <20020603155815.GA27696@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>,
	netfilter-devel@lists.samba.org
In-Reply-To: <20020603155815.GA27696@balabit.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 03 June 2002 17:58, Balazs Scheidler wrote:
> TODO:
> * when the socket is closed, the entry assigned to the socket
> should be deleted. Sadly the only solution is to patch the core to
> notify tproxy about this event, so the assigned entry can be
> deleted.

The standard conntrack code shares part of this problem I think.

There are a couple of conditions where the socket TCP state will be 
shut down without a FIN ever being seen. The most obvious example is 
time out during transmission.

Regards
Henrik
