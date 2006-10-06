From: Jens Laas <jens.laas@data.slu.se>
Subject: [PATCH] new disable command to effectively disable all filters
Date: Fri, 6 Oct 2006 11:03:46 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0610061002360.3013@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


My usage of iptables mainly consists of turning everything off.
In the event that Im not alone in this and others also would prefer a=20
quick way to accomplish this I implemented this command.

Its pretty straightforward but could probably benefit from the eyes of=20
experienced iptables developers.

Cheers,
Jens

The -Q --disable command removes all user-defined chains, flushes all=20
remaining rules and sets the default policies to ACCEPT.

--- iptables-1.3.6/iptables.c	2006-09-28 18:40:36.000000000 +0200
+++ iptables-1.3.6-jel/iptables.c	2006-10-06 09:58:27.000000000 +0200
@@ -80,9 +80,10 @@
  #define CMD_DELETE_CHAIN	0x0200U
  #define CMD_SET_POLICY		0x0400U
  #define CMD_RENAME_CHAIN	0x0800U
-#define NUMBER_OF_CMD	13
+#define CMD_DISABLE		0x1000U
+#define NUMBER_OF_CMD	14
  static const char cmdflags[] =3D { 'I', 'D', 'D', 'R', 'A', 'L', 'F', '=
Z',
-				 'N', 'X', 'P', 'E' };
+				 'N', 'X', 'P', 'E', 'Q' };

  #define OPTION_OFFSET 256

@@ -111,6 +112,7 @@
  	{ "list", 2, 0,  'L' },
  	{ "flush", 2, 0,  'F' },
  	{ "zero", 2, 0,  'Z' },
+	{ "disable", 0, 0,  'Q' },
  	{ "new-chain", 1, 0,  'N' },
  	{ "delete-chain", 2, 0,  'X' },
  	{ "rename-chain", 1, 0,  'E' },
@@ -172,7 +174,8 @@
  /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
  /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
  /*CHECK*/     {'x','+','+','+','x',' ','x',' ',' ',' ','x','x'},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'}
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*DISABLE*/   {'x','x','x','x','x',' ','x','x','x','x','x','x'}
  };

  static int inverse_for_options[NUMBER_OF_OPT] =3D
@@ -386,12 +389,13 @@
  "       %s -D chain rulenum [options]\n"
  "       %s -[LFZ] [chain] [options]\n"
  "       %s -[NX] chain\n"
+"       %s -Q\n"
  "       %s -E old-chain-name new-chain-name\n"
  "       %s -P chain target [options]\n"
  "       %s -h (print this help information)\n\n",
  	       program_name, program_version, program_name, program_name,
  	       program_name, program_name, program_name, program_name,
-	       program_name, program_name);
+	       program_name, program_name, program_name);

  	printf(
  "Commands:\n"
@@ -415,7 +419,9 @@
  "  --rename-chain\n"
  "            -E old-chain new-chain\n"
  "				Change chain name, (moving any references)\n"
-
+"  --disable -Q                 Removes all user-defined chains.\n"
+"                               Flushes all rules on the remaining chain=
s.\n"
+"                               Sets policy for INPUT,FORWARD,OUPUT to A=
CCEPT.\n"
  "Options:\n"
  "  --proto	-p [!] proto	protocol: by number or name, eg. `tcp'\n"
  "  --source	-s [!] address[/mask]\n"
@@ -1962,7 +1968,7 @@
  	opterr =3D 0;

  	while ((c =3D getopt_long(argc, argv,
-	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
+	   "-A:D:R:I:L::M:F::Z::N:X::E:P:QVh::o:p:s:d:j:i:fbvnt:m:xc:g:",
  					   opts, NULL)) !=3D -1) {
  		switch (c) {
  			/*
@@ -2049,6 +2055,11 @@
  			chain =3D optarg;
  			break;

+		case 'Q':
+			add_command(&command, CMD_DISABLE, CMD_NONE,
+				    invert);
+			break;
+
  		case 'X':
  			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
  				    invert);
@@ -2545,6 +2556,14 @@
  	case CMD_FLUSH:
  		ret =3D flush_entries(chain, options&OPT_VERBOSE, handle);
  		break;
+	case CMD_DISABLE:
+		ret =3D delete_chain(NULL, options&OPT_VERBOSE, handle);
+		if(ret) ret =3D flush_entries(NULL, options&OPT_VERBOSE, handle);
+		if(ret) ret =3D iptc_set_policy("INPUT", "ACCEPT", NULL, handle);
+		if(ret) ret =3D iptc_set_policy("OUTPUT", "ACCEPT", NULL, handle);
+		if(ret) ret =3D iptc_set_policy("FORWARD", "ACCEPT", NULL, handle);
+		if(ret) ret =3D zero_entries(NULL, options&OPT_VERBOSE, handle);
+		break;
  	case CMD_ZERO:
  		ret =3D zero_entries(chain, options&OPT_VERBOSE, handle);
  		break;

-----------------------------------------------------------------------
     'In theory, there is no difference between theory and practice.
      But, in practice, there is.'
-----------------------------------------------------------------------
     Jens L=E5=E5s                              Email: jens.laas@data.slu=
.se
     Department of Computer Services, SLU   Phone: +46 18 67 35 15
     Vindbrov=E4gen 1
     P.O. Box 7079
     S-750 07 Uppsala
     SWEDEN
-----------------------------------------------------------------------
