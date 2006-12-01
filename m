From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipt_multiport: getsockopt failed strangely: Invalid argument
Date: Sat, 02 Dec 2006 00:51:20 +0100
Message-ID: <4570BFF8.4060107@trash.net>
References: <87irgvomfx.fsf@scoobidee.mini-dweeb.org>	<45705747.9090806@trash.net>
	<20061201.152406.32722891.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010308090102040606090209"
Cc: arnaud@andesi.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20061201.152406.32722891.davem@davemloft.net>
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
--------------010308090102040606090209
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Fri, 01 Dec 2006 17:24:39 +0100
> 
> 
>>I *think* this should be fixed in 2.6.19. The 32 bit compat code
>>didn't implement the SO_GET_REVISION_MATCH/TARGET options and
>>returned an error.
> 
> 
> Agreed.
> 
> Once I have the fix I'll push it around to the -stable
> branches for you Patrick.
> 

Its already in 2.6.19, but I didn't expect it to really fix
something. I've attached it again, it applies all the way
back to 2.6.17 when the compat code was introduced.


--------------010308090102040606090209
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ip_tables: revision support for compat code

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 79030ed07de673e8451a03aecb9ada9f4d75d491
tree 4ba8bd843c8bc95db0ea6877880b73d06da620e5
parent bec71b162747708d4b45b0cd399b484f52f2901a
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 12:05:08 -0700
committer David S. Miller <davem@sunset.davemloft.net> Fri, 22 Sep 2006 15:20:00 -0700

 net/ipv4/netfilter/ip_tables.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3d5d4a4..673581d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1994,6 +1994,8 @@ compat_get_entries(struct compat_ipt_get
 	return ret;
 }
 
+static int do_ipt_get_ctl(struct sock *, int, void __user *, int *);
+
 static int
 compat_do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 {
@@ -2007,8 +2009,7 @@ compat_do_ipt_get_ctl(struct sock *sk, i
 		ret = compat_get_entries(user, len);
 		break;
 	default:
-		duprintf("compat_do_ipt_get_ctl: unknown request %i\n", cmd);
-		ret = -EINVAL;
+		ret = do_ipt_get_ctl(sk, cmd, user, len);
 	}
 	return ret;
 }

--------------010308090102040606090209--
