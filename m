From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_proto_sctp INIT_ACK messages dropped
Date: Tue, 22 Feb 2005 15:05:54 +0100
Message-ID: <421B3C42.2060106@trash.net>
References: <000e01c51843$d0a2e8e0$320aa8c0@blueslicemtl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090403090908060409070705"
Cc: 'Harald Welte' <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	'Kiran Kumar Immidi' <immidi@spymac.com>
To: Ariel Rosenblatt <ariel@blueslice.com>
In-Reply-To: <000e01c51843$d0a2e8e0$320aa8c0@blueslicemtl>
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

This is a multi-part message in MIME format.
--------------090403090908060409070705
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Ariel Rosenblatt wrote:
> You are right about the conntrack being susceptible to fraudulent INIT
> messages. This holds true for INIT-ACKs as well as the first INIT send. 
> 
> Saving the verification tags harms more than it helps, because it makes the
> connection tracking vulnerable to dos attacks. While the goal is dumping
> invalid traffic, it could instead wind up discarding valid traffic. 
> 
> I thought about these issues and I don't see a way of using verification
> tags without making the connection tracking susceptible to this problems.
> Saving tie-tags for existing associations until the COOKIE-ECHO/ACK is
> processed could alleviate the problem. However, it will still take one
	> fraudulent message to launch an attack and cause the module to 
discard valid
> traffic or prevent the association from being established by overwriting the
> valid tie-tag. 

How can it be attacked with a single message ? I'm thinking of something
like this (based on RFC 2960 5.2.4.1):

Endpoint A                                          Endpoint Z
<-------------- Association is established---------------------->
Tag=Tag_A                                             Tag=Tag_Z
<--------------------------------------------------------------->
{A crashes and restarts}
{app sets up a association with Z}
(build TCB)
INIT [I-Tag=Tag_A'
       & other info]  --------\ <- conntrack lets this packet pass
(Start T1-init timer)         \
(Enter COOKIE-WAIT state)      \---> (find a existing TCB
                                       compose temp TCB and Cookie_Z
                                       with Tie-Tags to previous
                                       association)
                                 /--- INIT ACK [Veri Tag=Tag_A',
                                /               I-Tag=Tag_Z',
(Cancel T1-init timer) <------/                Cookie_Z[TieTags=
                                                Tag_A,Tag_Z
                                                 & other info]
                                      (destroy temp TCB,leave original
                                       in place)

Conntrack notes the Tie-Tags if they match the used tags and
lets this message pass.

COOKIE ECHO [Veri=Tag_Z',
              Cookie_Z
              Tie=Tag_A,
              Tag_Z]----------\
(Start T1-init timer)         \
(Enter COOKIE-ECHOED state)    \---> (Find existing association,
                                       Tie-Tags match old tags,
                                       Tags do not match i.e.
                                       case X X M M above,
                                       Announce Restart to ULP
                                       and reset association).

Conntrack verifies the tags match the saved tags and resets the
association.

So without a full exchange no data is changed.

> In the mean time I patched the module with the code below (please see a more
> robust patch at the end of the message) to solve the saved vtag problem for
> both directions.

Thanks. I applied this slightly different version (no new variable) and
I'm going to submit it later today.

Regards
Patrick

--------------090403090908060409070705
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/22 14:52:03+01:00 ariel@blueslice.com 
#   [NETFILTER]: Fix sctp association restart
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_proto_sctp.c
#   2005/02/22 14:51:54+01:00 ariel@blueslice.com +2 -2
#   [NETFILTER]: Fix sctp association restart
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-02-22 14:54:35 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c	2005-02-22 14:54:35 +01:00
@@ -400,8 +400,8 @@
 					return -1;
 			}
 			DEBUGP("Setting vtag %x for dir %d\n", 
-					ih->init_tag, CTINFO2DIR(ctinfo));
-			conntrack->proto.sctp.vtag[IP_CT_DIR_ORIGINAL] = ih->init_tag;
+					ih->init_tag, !CTINFO2DIR(ctinfo));
+			conntrack->proto.sctp.vtag[!CTINFO2DIR(ctinfo)] = ih->init_tag;
 		}
 
 		conntrack->proto.sctp.state = newconntrack;

--------------090403090908060409070705--
