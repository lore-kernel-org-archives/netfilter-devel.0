From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Cleanup ttl match option parsing
Date: Mon, 23 Aug 2004 12:57:17 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040823195717.GA1854@linuxace.com>
References: <20040822173856.GA20772@linuxace.com> <412A3D6F.8070801@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <412A3D6F.8070801@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 23, 2004 at 08:54:39PM +0200, Patrick McHardy wrote:
> Phil Oester wrote:
> 
> >The below patch allows the ttl match to be used with other matches
> >without assuming it 'owns' all options.  For example, this command
> >currently causes the '...TTL option twice error':
> >
> >iptables -A foo -d 1.2.3.4 -m ttl --ttl-eq 1 -m state --state NEW -j ACCEPT
> >
> >But works with the below patch.
> >
> >This fixes bugzilla #183
> > 
> >
> I get rejects with this patch, please send it again as attachment.

Indeed -- appologies.

Attached

Phil

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ttl

diff -ru ipt-orig/extensions/libipt_ttl.c ipt-new/extensions/libipt_ttl.c
--- ipt-orig/extensions/libipt_ttl.c	2002-05-29 09:08:16.000000000 -0400
+++ ipt-new/extensions/libipt_ttl.c	2004-08-23 15:55:07.886209960 -0400
@@ -40,10 +40,6 @@
 	check_inverse(optarg, &invert, &optind, 0);
 	value = atoi(argv[optind-1]);
 
-	if (*flags) 
-		exit_error(PARAMETER_PROBLEM, 
-				"Can't specify TTL option twice");
-
 	if (!optarg)
 		exit_error(PARAMETER_PROBLEM,
 				"ttl: You must specify a value");
@@ -56,8 +52,6 @@
 
 			/* is 0 allowed? */
 			info->ttl = value;
-			*flags = 1;
-
 			break;
 		case '3':
 			if (invert) 
@@ -66,8 +60,6 @@
 
 			info->mode = IPT_TTL_LT;
 			info->ttl = value;
-			*flags = 1;
-
 			break;
 		case '4':
 			if (invert)
@@ -76,14 +68,17 @@
 
 			info->mode = IPT_TTL_GT;
 			info->ttl = value;
-			*flags = 1;
-
 			break;
 		default:
 			return 0;
 
 	}
 
+	if (*flags) 
+		exit_error(PARAMETER_PROBLEM, 
+				"Can't specify TTL option twice");
+	*flags = 1;
+
 	return 1;
 }
 

--vkogqOf2sHV7VnPd--
