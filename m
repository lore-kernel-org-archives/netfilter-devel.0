From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [Resend] OSF update: netlink logging
Date: Sat, 31 Jan 2004 19:56:05 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040131195605.283c5935.johnpol@2ka.mipt.ru>
References: <20040131154725.5a6a82be.johnpol@2ka.mipt.ru>
	<20040131163155.GL11753@sunbeam.de.gnumonks.org>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sat__31_Jan_2004_19_56_05_+0300_XEaSOaktHLoYLjQX"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040131163155.GL11753@sunbeam.de.gnumonks.org>
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

--Multipart=_Sat__31_Jan_2004_19_56_05_+0300_XEaSOaktHLoYLjQX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 31 Jan 2004 17:31:55 +0100
Harald Welte <laforge@netfilter.org> wrote:


> > -#define IPTABLES_VERSION	"1.2.6a" /* It looks like FIXME */
> > +#define IPTABLES_VERSION	"1.2.7a" /* Permanent FIXME */
> 
> Why do you define IPTABLES_VERSION ??
> 
> This is defined by the makefile, and it is not a good idea to
> re-define it, since then your compiled extension won't work [since
> current version is higher than 1.2.7a].

Because I compile lib and modules separately from kernel and iptables
with my own makefiles.
And I didn't know that it was defined somewhere ;)

> Apart from that, the patch is fine to me.

I attach patch for libipt_osf.c without IPTABLES_VERSION.

Thank you.

> - -- 
> - - Harald Welte <laforge@netfilter.org>            
> http://www.netfilter.org/

	Evgeniy Polyakov ( s0mbre )

Only failure makes us experts. -- Theo de Raadt

--Multipart=_Sat__31_Jan_2004_19_56_05_+0300_XEaSOaktHLoYLjQX
Content-Type: text/plain;
 name="libipt_osf.diff"
Content-Disposition: attachment;
 filename="libipt_osf.diff"
Content-Transfer-Encoding: 7bit

--- iptables/extensions/libipt_osf.c	Fri Jan  2 15:58:30 2004
+++ iptables/extensions/libipt_osf.c	Fri Jan 16 17:56:43 2004
@@ -42,7 +42,8 @@
 		"--smart		Use some smart extensions to determine OS (do not use TTL).\n"
 		"--log level		Log all(or only first) determined genres even if "
 					"they do not match desired one. "
-					"Level may be 0(all) or 1(only first entry).\n",
+					"Level may be 0(all) or 1(only first entry).\n"
+		"--netlink		Log through netlink(NETLINK_NFLOG).\n",
 		IPTABLES_VERSION);
 }
 
@@ -51,6 +52,7 @@
 	{ .name = "genre",	.has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = "smart",	.has_arg = 0, .flag = 0, .val = '2' },
 	{ .name = "log",	.has_arg = 1, .flag = 0, .val = '3' },
+	{ .name = "netlink",	.has_arg = 0, .flag = 0, .val = '4' },
 	{ .name = 0 }
 };
 
@@ -101,6 +103,12 @@
 			*flags |= IPT_OSF_LOG;
 			info->loglevel = atoi(argv[optind-1]);
 			info->flags |= IPT_OSF_LOG;
+			break;
+		case '4': /* --netlink */
+			if (*flags & IPT_OSF_NETLINK)
+				exit_error(PARAMETER_PROBLEM, "Can't specify multiple smart parameter");
+			*flags |= IPT_OSF_NETLINK;
+			info->flags |= IPT_OSF_NETLINK;
 			break;
 		default:
 			return 0;

--Multipart=_Sat__31_Jan_2004_19_56_05_+0300_XEaSOaktHLoYLjQX--
