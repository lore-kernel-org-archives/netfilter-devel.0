From: Ozgur Akan <akan@aiqa.com>
Subject: Re: argv[optind-1] == optarg
Date: Mon, 24 May 2004 08:26:17 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B18779.8010606@aiqa.com>
References: <40AF9F99.7070305@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040807000602020602030700"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>,
 Harald Welte <laforge@netfilter.org>
In-Reply-To: <40AF9F99.7070305@aiqa.com>
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
--------------040807000602020602030700
Content-Type: multipart/alternative;
 boundary="------------050407090102020108010203"


--------------050407090102020108010203
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
I attached the patch file for optarg. It includes patches for iptables.c 
and ip6tables.c.

regards,
Ozgur Akan

Ozgur Akan wrote:

> Hi,
>
> I think using optarg instead of argv[optind-1] will be better. In 
> iptables.c; while parsing iptables options with getopt_long, 
> argv[optind-1] is used in 8 places.
>
> optarg (option argument) gives us the value of the option we are 
> parsing. So when we do something with the argument of (for example) A 
> option the easiest way to get the value of A`s argument is using 
> optarg. optarg is designed to be used with getopt_long.
>
> Using optind (option index) is more tricky because optind starts from 
> 1 and when we are parsing an option with an index of value n of argv 
> array it shows n+2. That`s why we substract 1 from optind.
>
> best wishes,
> Ozgur Akan


--------------050407090102020108010203
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-9">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
Hi,<br>
I attached the patch file for optarg. It includes patches for
iptables.c and ip6tables.c.<br>
<br>
regards,<br>
Ozgur Akan<br>
<br>
Ozgur Akan wrote:<br>
<blockquote type="cite" cite="mid40AF9F99.7070305@aiqa.com">
  <meta http-equiv="Content-Type" content="text/html;">
  <title></title>
  <span style="font-family: microsoft-verdana-iso10646-1;">Hi,<br>
  <br>
  </span><span style="font-family: microsoft-verdana-iso10646-1;"> I
think using optarg instead of argv[optind-1] will be better. </span><span
 style="font-family: microsoft-verdana-iso10646-1;">In iptables.c;
while parsing iptables options with getopt_long, argv[optind-1] is used
in 8 places.<br>
  <br>
optarg (option argument) gives us the value of the option we are
parsing. So when we do something with the argument of (for example) A
option the easiest way to get the value of A`s argument is using
optarg. optarg is designed to be used with getopt_long.<br>
  <br>
Using optind (option index) is more tricky because optind starts from 1
and when we are parsing an option with an index of value n of argv
array it shows n+2. That`s why we substract 1 from optind.<br>
  <br>
best wishes,</span><br>
Ozgur Akan<br>
</blockquote>
</body>
</html>

--------------050407090102020108010203--

--------------040807000602020602030700
Content-Type: text/plain;
 name="optarg.PATCH"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="optarg.PATCH"

diff -Naur iptables/ip6tables.c iptables_dev/ip6tables.c
--- iptables/ip6tables.c	2004-05-24 08:07:59.782220912 +0300
+++ iptables_dev/ip6tables.c	2004-05-24 08:16:48.830793304 +0300
@@ -1853,10 +1853,10 @@
 				   invert);
 
 			/* Canonicalize into lower case */
-			for (protocol = argv[optind-1]; *protocol; protocol++)
+			for (protocol = optarg; *protocol; protocol++)
 				*protocol = tolower(*protocol);
 
-			protocol = argv[optind-1];
+			protocol = optarg;
 			if ( strcmp(protocol,"ipv6-icmp") == 0)
 				protocol = icmp6p;
 			fw.ipv6.proto = parse_protocol(protocol);
@@ -1873,7 +1873,7 @@
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_SOURCE, &fw.ipv6.invflags,
 				   invert);
-			shostnetworkmask = argv[optind-1];
+			shostnetworkmask = optarg;
 			fw.nfcache |= NFC_IP6_SRC;
 			break;
 
@@ -1881,7 +1881,7 @@
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_DESTINATION, &fw.ipv6.invflags,
 				   invert);
-			dhostnetworkmask = argv[optind-1];
+			dhostnetworkmask = optarg;
 			fw.nfcache |= NFC_IP6_DST;
 			break;
 
@@ -1911,7 +1911,7 @@
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEIN, &fw.ipv6.invflags,
 				   invert);
-			parse_interface(argv[optind-1],
+			parse_interface(optarg,
 					fw.ipv6.iniface,
 					fw.ipv6.iniface_mask);
 			fw.nfcache |= NFC_IP6_IF_IN;
@@ -1921,7 +1921,7 @@
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ipv6.invflags,
 				   invert);
-			parse_interface(argv[optind-1],
+			parse_interface(optarg,
 					fw.ipv6.outiface,
 					fw.ipv6.outiface_mask);
 			fw.nfcache |= NFC_IP6_IF_OUT;
@@ -1961,7 +1961,7 @@
 			if (invert)
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
-			*table = argv[optind-1];
+			*table = optarg;
 			break;
 
 		case 'x':
@@ -2100,7 +2100,7 @@
 				if (!m)
 					exit_error(PARAMETER_PROBLEM,
 						   "Unknown arg `%s'",
-						   argv[optind-1]);
+						   optarg);
 			}
 		}
 		invert = FALSE;
diff -Naur iptables/iptables.c iptables_dev/iptables.c
--- iptables/iptables.c	2004-05-24 08:08:00.804065568 +0300
+++ iptables_dev/iptables.c	2004-05-24 08:11:02.797398376 +0300
@@ -1850,10 +1850,10 @@
 				   invert);
 
 			/* Canonicalize into lower case */
-			for (protocol = argv[optind-1]; *protocol; protocol++)
+			for (protocol = optard; *protocol; protocol++)
 				*protocol = tolower(*protocol);
 
-			protocol = argv[optind-1];
+			protocol = optarg;
 			fw.ip.proto = parse_protocol(protocol);
 
 			if (fw.ip.proto == 0
@@ -1867,7 +1867,7 @@
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_SOURCE, &fw.ip.invflags,
 				   invert);
-			shostnetworkmask = argv[optind-1];
+			shostnetworkmask = optarg;
 			fw.nfcache |= NFC_IP_SRC;
 			break;
 
@@ -1875,7 +1875,7 @@
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_DESTINATION, &fw.ip.invflags,
 				   invert);
-			dhostnetworkmask = argv[optind-1];
+			dhostnetworkmask = optarg;
 			fw.nfcache |= NFC_IP_DST;
 			break;
 
@@ -1905,7 +1905,7 @@
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEIN, &fw.ip.invflags,
 				   invert);
-			parse_interface(argv[optind-1],
+			parse_interface(optarg,
 					fw.ip.iniface,
 					fw.ip.iniface_mask);
 			fw.nfcache |= NFC_IP_IF_IN;
@@ -1915,7 +1915,7 @@
 			check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ip.invflags,
 				   invert);
-			parse_interface(argv[optind-1],
+			parse_interface(optarg,
 					fw.ip.outiface,
 					fw.ip.outiface_mask);
 			fw.nfcache |= NFC_IP_IF_OUT;
@@ -1962,7 +1962,7 @@
 			if (invert)
 				exit_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
-			*table = argv[optind-1];
+			*table = optarg;
 			break;
 
 		case 'x':
@@ -2100,7 +2100,7 @@
 				if (!m)
 					exit_error(PARAMETER_PROBLEM,
 						   "Unknown arg `%s'",
-						   argv[optind-1]);
+						   optarg);
 			}
 		}
 		invert = FALSE;

--------------040807000602020602030700--
