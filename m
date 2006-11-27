From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 02/05]: nf_conntrack: automatic sysctl registation
 for conntrack protocols
Date: Mon, 27 Nov 2006 11:38:44 +0100
Message-ID: <456AC034.9090701@trash.net>
References: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>	<20061126144450.4215.9710.sendpatchset@localhost.localdomain>	<200611270517.kAR5HMV3029948@toshiba.co.jp>
	<456ABE55.1050800@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040203090604030605000000"
Cc: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <456ABE55.1050800@trash.net>
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
--------------040203090604030605000000
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index 0afc298..941b5c3 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -173,7 +173,7 @@ static void nf_ct_l3proto_unregister_sys
>  {
>  #ifdef CONFIG_SYSCTL
>  	mutex_lock(&nf_ct_proto_sysctl_mutex);
> -	if (l3proto->ctl_table != NULL)
> +	if (l3proto->ctl_table_header != NULL)
>  		nf_ct_unregister_sysctl(&l3proto->ctl_table_header,
>  					l3proto->ctl_table, NULL);
>  	mutex_unlock(&nf_ct_proto_sysctl_mutex);
> @@ -260,7 +260,8 @@ static void nf_ct_l4proto_unregister_sys
>  {
>  #ifdef CONFIG_SYSCTL
>  	mutex_lock(&nf_ct_proto_sysctl_mutex);
> -	if (l4proto->ctl_table != NULL)
> +	if (l4proto->ctl_table_header != NULL &&
> +	    *l4proto->ctl_table_header != NULL)
>  		nf_ct_unregister_sysctl(l4proto->ctl_table_header,
>  					l4proto->ctl_table,
>  					l4proto->ctl_table_users);

And a simiar change for the compat stuff, but I've also removed the
double pointer for the header since the compat tables are not supposed
to be shared.

--------------040203090604030605000000
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 5c72118..fc8af08 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -81,7 +81,7 @@ #ifdef CONFIG_SYSCTL
 	struct ctl_table	*ctl_table;
 	unsigned int		*ctl_table_users;
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	struct ctl_table_header	**ctl_compat_table_header;
+	struct ctl_table_header	*ctl_compat_table_header;
 	struct ctl_table	*ctl_compat_table;
 #endif
 #endif
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index e97e288..46aa44a 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -337,7 +337,6 @@ static struct ctl_table icmp_sysctl_tabl
 	}
 };
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-static struct ctl_table_header *icmp_compat_sysctl_header;
 static struct ctl_table icmp_compat_sysctl_table[] = {
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_ICMP_TIMEOUT,
@@ -377,7 +376,6 @@ #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &icmp_sysctl_header,
 	.ctl_table		= icmp_sysctl_table,
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	.ctl_compat_table_header= &icmp_compat_sysctl_header,
 	.ctl_compat_table	= icmp_compat_sysctl_table,
 #endif
 #endif
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index d686bb4..4798afc 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -255,7 +255,7 @@ #ifdef CONFIG_SYSCTL
 	}
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
 	if (l4proto->ctl_compat_table != NULL) {
-		err = nf_ct_register_sysctl(l4proto->ctl_compat_table_header,
+		err = nf_ct_register_sysctl(&l4proto->ctl_compat_table_header,
 					    nf_net_ipv4_netfilter_sysctl_path,
 					    l4proto->ctl_compat_table, NULL);
 		if (err == 0)
@@ -281,8 +281,8 @@ #ifdef CONFIG_SYSCTL
 					l4proto->ctl_table,
 					l4proto->ctl_table_users);
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	if (l4proto->ctl_compat_table != NULL)
-		nf_ct_unregister_sysctl(l4proto->ctl_compat_table_header,
+	if (l4proto->ctl_compat_table_header != NULL)
+		nf_ct_unregister_sysctl(&l4proto->ctl_compat_table_header,
 					l4proto->ctl_compat_table, NULL);
 #endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 	mutex_unlock(&nf_ct_proto_sysctl_mutex);
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 8df3bc6..6990253 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -87,7 +87,6 @@ static struct ctl_table generic_sysctl_t
 	}
 };
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-static struct ctl_table_header *generic_compat_sysctl_header;
 static struct ctl_table generic_compat_sysctl_table[] = {
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_GENERIC_TIMEOUT,
@@ -119,7 +118,6 @@ #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &generic_sysctl_header,
 	.ctl_table		= generic_sysctl_table,
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	.ctl_compat_table_header= &generic_compat_sysctl_header,
 	.ctl_compat_table	= generic_compat_sysctl_table,
 #endif
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 807d215..7c64b9c 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -575,7 +575,6 @@ static struct ctl_table sctp_sysctl_tabl
 };
 
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-static struct ctl_table_header *sctp_compat_sysctl_header;
 static struct ctl_table sctp_compat_sysctl_table[] = {
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_SCTP_TIMEOUT_CLOSED,
@@ -656,7 +655,6 @@ #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &sctp_sysctl_header,
 	.ctl_table		= sctp_sysctl_table,
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	.ctl_compat_table_header= &sctp_compat_sysctl_header,
 	.ctl_compat_table	= sctp_compat_sysctl_table,
 #endif
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6fcf388..d99c7c4 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1275,7 +1275,6 @@ static struct ctl_table tcp_sysctl_table
 };
 
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-static struct ctl_table_header *tcp_compat_sysctl_header;
 static struct ctl_table tcp_compat_sysctl_table[] = {
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT,
@@ -1404,7 +1403,6 @@ #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &tcp_sysctl_header,
 	.ctl_table		= tcp_sysctl_table,
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	.ctl_compat_table_header= &tcp_compat_sysctl_header,
 	.ctl_compat_table	= tcp_compat_sysctl_table,
 #endif
 #endif
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 75c1e45..908fde7 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -173,7 +173,6 @@ static struct ctl_table udp_sysctl_table
 	}
 };
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-static struct ctl_table_header *udp_compat_sysctl_header;
 static struct ctl_table udp_compat_sysctl_table[] = {
 	{
 		.ctl_name	= NET_IPV4_NF_CONNTRACK_UDP_TIMEOUT,
@@ -220,7 +219,6 @@ #ifdef CONFIG_SYSCTL
 	.ctl_table_header	= &udp_sysctl_header,
 	.ctl_table		= udp_sysctl_table,
 #ifdef CONFIG_NF_CONNTRACK_PROC_COMPAT
-	.ctl_compat_table_header= &udp_compat_sysctl_header,
 	.ctl_compat_table	= udp_compat_sysctl_table,
 #endif
 #endif

--------------040203090604030605000000--
