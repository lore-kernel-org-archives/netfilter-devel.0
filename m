From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] don't try to track broadcasts or multicasts (4/4)
Date: 08 Jun 2002 16:51:47 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023547908.19838.46.camel@tux>
References: <1023366027.845.30.camel@tux>
	<20020608073547.GA1109@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20020608073547.GA1109@naboo.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2002-06-08 at 09:35, Harald Welte wrote:

> hm.  I would generally agree with you, but there is one issue which
> needs to be looked into before considering this patch:
> 
> What happens if some client sends an ip-unicast diagram as link layer
> broadcast?  How does the linux stack react to this?
> 
> If the packet is processed/routed the same way like any other ip-unicast
> link-layer unicast packet, we still need to do tracking of broadcast
> packets.
> 
> Could you try to look into that and keep us posted?

Hmm why didn't I think about that?

I've done some simple testing and the results are:

TCP:
send SYN to ll broadcast: ignored
send SYN,ACK to ll broadcast: ignored

UDP:
packet sent to ll broadcast: accepted

ICMP:
echo-request sent to ll broadcast: accepted
echo-reply sent to ll broadcast: accepted
port unreachable sent to ll broadcast: accepted

I havn't done any tests with multicast ll addresses.

Seeing these results there's not much need for a patch of this kind.
TCP ll broadcasts are extremely rare. almost all ll broadcasts here are
UDP.

It was a nice thought but doesn't work in the real world.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
