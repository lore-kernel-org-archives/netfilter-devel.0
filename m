From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ownercmd for ip6tables
Date: Tue, 08 Apr 2003 19:33:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9307D3.6050808@trash.net>
References: <3E92F3C4.9070908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000509030907080006080906"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <3E92F3C4.9070908@trash.net>
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
--------------000509030907080006080906
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

forgot to attach it.

Patrick McHardy wrote:

> This patch adds support for the --owner-cmd option to ip6t_owner.
> I have this lying around for about 9 month and i can not remember
> if i ever tested it and i have no ipv6 network available (sorry).
>
> Bye,
> Patrick


--------------000509030907080006080906
Content-Type: text/plain;
 name="owner6cmd-pom.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="owner6cmd-pom.diff"

diff -urN a/userspace/ownercmd.patch.ipv6 b/userspace/ownercmd.patch.ipv6
--- a/userspace/ownercmd.patch.ipv6	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/ownercmd.patch.ipv6	2003-04-07 23:59:48.000000000 +0200
@@ -0,0 +1,73 @@
+diff -urN ../../kernel/linux-2.4.20-pre4/include/linux/netfilter_ipv6/ip6t_owner.h linux-2.4.20-pre4/include/linux/netfilter_ipv6/ip6t_owner.h
+--- ../../kernel/linux-2.4.20-pre4/include/linux/netfilter_ipv6/ip6t_owner.h	2000-06-20 23:32:27.000000000 +0200
++++ linux-2.4.20-pre4/include/linux/netfilter_ipv6/ip6t_owner.h	2002-08-30 02:05:19.000000000 +0200
+@@ -6,12 +6,14 @@
+ #define IP6T_OWNER_GID	0x02
+ #define IP6T_OWNER_PID	0x04
+ #define IP6T_OWNER_SID	0x08
++#define IP6T_OWNER_COMM 0x10
+ 
+ struct ip6t_owner_info {
+     uid_t uid;
+     gid_t gid;
+     pid_t pid;
+     pid_t sid;
++    char comm[16];
+     u_int8_t match, invert;	/* flags */
+ };
+ 
+diff -urN ../../kernel/linux-2.4.20-pre4/net/ipv6/netfilter/ip6t_owner.c linux-2.4.20-pre4/net/ipv6/netfilter/ip6t_owner.c
+--- ../../kernel/linux-2.4.20-pre4/net/ipv6/netfilter/ip6t_owner.c	2001-10-31 00:08:12.000000000 +0100
++++ linux-2.4.20-pre4/net/ipv6/netfilter/ip6t_owner.c	2002-08-30 02:04:04.000000000 +0200
+@@ -16,6 +16,38 @@
+ MODULE_LICENSE("GPL");
+ 
+ static int
++match_comm(const struct sk_buff *skb, const char *comm)
++{
++	struct task_struct *p;
++	struct files_struct *files;
++	int i;
++
++	read_lock(&tasklist_lock);
++	for_each_task(p) {
++		if(strncmp(p->comm, comm, sizeof(p->comm)))
++			continue;
++
++		task_lock(p);
++		files = p->files;
++		if(files) {
++			read_lock(&files->file_lock);
++			for (i=0; i < files->max_fds; i++) {
++				if (fcheck_files(files, i) == skb->sk->socket->file) {
++					read_unlock(&files->file_lock);
++					task_unlock(p);
++					read_unlock(&tasklist_lock);
++					return 1;
++				}
++			}
++			read_unlock(&files->file_lock);
++		}
++		task_unlock(p);
++	}
++	read_unlock(&tasklist_lock);
++	return 0;
++}
++
++static int
+ match_pid(const struct sk_buff *skb, pid_t pid)
+ {
+ 	struct task_struct *p;
+@@ -119,6 +151,12 @@
+ 			return 0;
+ 	}
+ 
++	if(info->match & IP6T_OWNER_COMM) {
++		if (!match_comm(skb, info->comm) ^
++		    !!(info->invert & IP6T_OWNER_COMM))
++			return 0;
++	}
++
+ 	return 1;
+ }
+ 
diff -urN a/userspace/ownercmd.patch.ipv6.help b/userspace/ownercmd.patch.ipv6.help
--- a/userspace/ownercmd.patch.ipv6.help	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/ownercmd.patch.ipv6.help	2003-04-08 00:00:52.000000000 +0200
@@ -0,0 +1,18 @@
+Author: Patrich McHardy <kaber@trash.net>
+	Ported from Marc Boucher's ipv4 version
+Status: Untested, help text stolen from original version, feedback is welcome!
+
+This patch adds support for local process name matching
+to the owner match (--cmd-owner option).
+
+You can use this feature to filter connections forwarded by
+your ssh daemon with rules like:
+
+ip6tables -N CheckSSHSyns
+# allow forwarded connections to rsync port on 192.168.1.1
+ip6tables -A CheckSSHSyns -p tcp -d 192.168.1.1 --dport 873 -j RETURN
+# refuse everything else
+ip6tables -A CheckSSHSyns -j REJECT --reject-with tcp-reset
+
+ip6tables -I OUTPUT -p tcp --syn -m owner --cmd-owner sshd -j CheckSSHSyns
+
diff -urN a/userspace/ownercmd.patch.ipv6.userspace b/userspace/ownercmd.patch.ipv6.userspace
--- a/userspace/ownercmd.patch.ipv6.userspace	1970-01-01 01:00:00.000000000 +0100
+++ b/userspace/ownercmd.patch.ipv6.userspace	2003-04-07 23:59:48.000000000 +0200
@@ -0,0 +1,93 @@
+--- userspace/extensions/libip6t_owner.c	2002-05-29 15:08:16.000000000 +0200
++++ userspace/extensions/libip6t_owner.c	2002-08-30 02:43:43.000000000 +0200
+@@ -14,14 +14,26 @@
+ static void
+ help(void)
+ {
++#ifdef IP6T_OWNER_COMM
+ 	printf(
+ "OWNER match v%s options:\n"
+ "[!] --uid-owner userid     Match local uid\n"
+ "[!] --gid-owner groupid    Match local gid\n"
+ "[!] --pid-owner processid  Match local pid\n"
+ "[!] --sid-owner sessionid  Match local sid\n"
++"[!] --cmd-owner name       Match local command name\n"
+ "\n",
+ IPTABLES_VERSION);
++#else
++	printf(
++"OWNER match v%s options:\n"
++"[!] --uid-owner userid     Match local uid\n"
++"[!] --gid-owner groupid    Match local gid\n"
++"[!] --pid-owner processid  Match local pid\n"
++"[!] --sid-owner sessionid  Match local sid\n"
++"\n",
++IPTABLES_VERSION);
++#endif /* IP6T_OWNER_COMM */
+ }
+ 
+ static struct option opts[] = {
+@@ -29,6 +41,9 @@
+ 	{ "gid-owner", 1, 0, '2' },
+ 	{ "pid-owner", 1, 0, '3' },
+ 	{ "sid-owner", 1, 0, '4' },
++#ifdef IP6T_OWNER_COMM
++	{ "cmd-owner", 1, 0, '5' },
++#endif
+ 	{0}
+ };
+ 
+@@ -107,6 +122,21 @@
+ 		*flags = 1;
+ 		break;
+ 
++#ifdef IP6T_OWNER_COMM
++	case '5':
++		check_inverse(optarg, &invert, &optind, 0);
++		if(strlen(optarg) > sizeof(ownerinfo->comm))
++			exit_error(PARAMETER_PROBLEM, "OWNER CMD `%s' too long, max %d characters", optarg, sizeof(ownerinfo->comm));
++		
++		strncpy(ownerinfo->comm, optarg, sizeof(ownerinfo->comm));
++
++		if (invert)
++			ownerinfo->invert |= IP6T_OWNER_COMM;
++		ownerinfo->match |= IP6T_OWNER_COMM;
++		*flags = 1;
++		break;
++#endif
++		
+ 	default:
+ 		return 0;
+ 	}
+@@ -154,6 +184,11 @@
+ 		case IP6T_OWNER_SID:
+ 			printf("%u ", info->sid);
+ 			break;
++#ifdef IP6T_OWNER_COMM
++		case IP6T_OWNER_COMM:
++			printf("%.*s ", (int)sizeof(info->comm), info->comm);
++			break;
++#endif
+ 		default:
+ 			break;
+ 		}
+@@ -181,6 +216,9 @@
+ 	print_item(info, IP6T_OWNER_GID, numeric, "OWNER GID match ");
+ 	print_item(info, IP6T_OWNER_PID, numeric, "OWNER PID match ");
+ 	print_item(info, IP6T_OWNER_SID, numeric, "OWNER SID match ");
++#ifdef IP6T_OWNER_COMM
++	print_item(info, IP6T_OWNER_COMM, numeric, "OWNER CMD match ");
++#endif
+ }
+ 
+ /* Saves the union ip6t_matchinfo in parsable form to stdout. */
+@@ -193,6 +231,9 @@
+ 	print_item(info, IP6T_OWNER_GID, 0, "--gid-owner ");
+ 	print_item(info, IP6T_OWNER_PID, 0, "--pid-owner ");
+ 	print_item(info, IP6T_OWNER_SID, 0, "--sid-owner ");
++#ifdef IP6T_OWNER_COMM
++	print_item(info, IP6T_OWNER_COMM, 0, "--cmd-owner ");
++#endif
+ }
+ 
+ static

--------------000509030907080006080906--
