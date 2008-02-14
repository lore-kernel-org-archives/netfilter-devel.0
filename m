From: Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>
Subject: Re: cups slow on linux-2.6.24
Date: Thu, 14 Feb 2008 16:02:29 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802141536560.22526@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0802102257420.14442@boston.corp.fedex.com>
Reply-To: "Mirror of cups.bugs Newsgroup" <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Krzysztof Piotr Oledzki <ole-gcSpNFQc7Gg@public.gmane.org>,
	Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>,
	Netfilter Development Mailinglist <netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cups-bugs <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
To: Jeff Chua <jeff.chua.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.0802102257420.14442-2K9XAwmnW1wYQUuIRqa960M9+F4ksjoh@public.gmane.org>
List-Unsubscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
Errors-To: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Sun, 10 Feb 2008, Jeff Chua wrote:

> Please note the lastest git commit is missing one part (which was in Jozsef's
> original patch).

Sorry everyone, that's my fault: the patch I sent for the stable branch 
was correct, however I mistyped a state in the patch for the newest 
git tree - Jeff spotted it, thanks! So here follows the patch against the 
newest git tree which corrects the mistake. Please review and commit.

commit 1177898d185f382f491afaee3cdc752729c74bd2
Author: Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>
Date:   Thu Feb 14 15:51:21 2008 +0100

    Mistyped state corrected.

Signed-off-by: Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 202d7fa..6256795 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -945,7 +945,7 @@ static int tcp_packet(struct nf_conn *ct,
 
 	ct->proto.tcp.state = new_state;
 	if (old_state != new_state
-	    && new_state == TCP_CONNTRACK_CLOSE)
+	    && new_state == TCP_CONNTRACK_FIN_WAIT)
 		ct->proto.tcp.seen[dir].flags |= IP_CT_TCP_FLAG_CLOSE_INIT;
 	timeout = ct->proto.tcp.retrans >= nf_ct_tcp_max_retrans
 		  && tcp_timeouts[new_state] > nf_ct_tcp_timeout_max_retrans
 

Best regards,
Jozsef
-
E-mail  : kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, kadlec-tC8PEuNsDRr1hxmkv4H60w@public.gmane.org
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
