From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: AW: TCP window tracking has bad side effects
Date: Wed, 1 Dec 2004 13:58:35 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412011352390.27175@blackhole.kfki.hu>
References: <47D438A0510BD611B9470002A58EDAE706B3B51F@mchh2a6e.mchh.siemens.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Lockenvitz Jan EXT <Jan.Lockenvitz.extern@icn.siemens.de>
In-Reply-To: <47D438A0510BD611B9470002A58EDAE706B3B51F@mchh2a6e.mchh.siemens.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 1 Dec 2004, Lockenvitz Jan EXT wrote:

> i recently saw the same problem on a Checkpoint FW. The problem there
> was the blocked SYN packet.
> The packet was blocked because it had the same Src-IP:src-port and
> Dst-IP:dst-port than the old connection in the state table. So the
> SYN never reached the other box and no ACK packet (with old sequence and
> ack-nr) was send and of course no RST.

Because the man in the middle (netfilter) cannot know wether the
connection has already died and the current SYN is a true new request or a
SYN probe, the TCP window tracking code lets through the SYN packet. If
it's a real new connection request, the packet will be answered with a
proper SYN/ACK and the new connection will be handled properly. If it was
a SYN probe and we see an ACK as a reply, the old connection will remain
in the conntrack hash table.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
