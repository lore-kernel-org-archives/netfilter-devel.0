From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel crash [problem with helpers]
Date: Thu, 27 May 2004 02:34:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B53794.7060600@trash.net>
References: <200405261412.32587.raivis@mt.lv>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060606000501010700030304"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Raivis Bucis <raivis@mt.lv>
In-Reply-To: <200405261412.32587.raivis@mt.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060606000501010700030304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Raivis Bucis wrote:
> ip_conntrack assumes that expect->expectant->helper allways will be non null, 
> but that is not allways the case.
> 
> When tftp conntrack is used, on first received UDP packet, tfp helper adds 
> expectation. If it gets NATed later to some other port, 
> ip_conntrack_alter_reply will set its helper to NULL, but expectation is 
> still kept, and when expected conntrack is created, its master conntrack 
> doesn't have helper anymore. This leads to kernel oops in list_conntracks 
> when reading "/proc/net/ip_conntrack", etc.

Thanks for tracking this down.

> 
> Therefore I propose following fix:
> 
> diff -u -r1.13 ip_conntrack_core.c
> --- ip_conntrack_core.c 9 Jan 2004 07:52:10 -0000       1.13
> +++ ip_conntrack_core.c 26 May 2004 11:05:23 -0000
> @@ -1139,10 +1139,13 @@
>         DUMP_TUPLE(newreply);
> 
>         conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
> -       if (!conntrack->master)
> -               conntrack->helper = LIST_FIND(&helpers, helper_cmp,
> -                                             struct ip_conntrack_helper *,
> -                                             newreply);
> +       if (!conntrack->master) {
> +               struct ip_conntrack_helper *newhelper;
> +               newhelper = LIST_FIND(&helpers, helper_cmp,
> +                                     struct ip_conntrack_helper *,
> +                                     newreply);
> +               if (newhelper) conntrack->helper = newhelper;
> +       }
>         WRITE_UNLOCK(&ip_conntrack_lock);
> 
>         return 1;
> 
> 
> Or maybe, we should check whether it has expectations before looking for new 
> helper.

Yes, your second solution is better. Changing helpers is fine as long as
no expectations exist. I have added this patch instead.

Regards
Patrick

> 
> Raivis Bucis


--------------060606000501010700030304
Content-Type: text/x-patch;
 name="linux.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux.patch"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/05/27 02:01:28+02:00 kaber@trash.net 
#   [NETFILTER]: Don't assign new helper after NAT when there are already expectations present
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2004/05/27 02:01:19+02:00 kaber@trash.net +2 -4
#   [NETFILTER]: Don't assign new helper after NAT when there are already expectations present
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2004-05-27 02:03:11 +02:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2004-05-27 02:03:11 +02:00
@@ -1127,10 +1127,8 @@
 	DUMP_TUPLE(newreply);
 
 	conntrack->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-	if (!conntrack->master)
-		conntrack->helper = LIST_FIND(&helpers, helper_cmp,
-					      struct ip_conntrack_helper *,
-					      newreply);
+	if (!conntrack->master && list_empty(&conntrack->sibling_list))
+		conntrack->helper = ip_ct_find_helper(newreply);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
 	return 1;

--------------060606000501010700030304--
