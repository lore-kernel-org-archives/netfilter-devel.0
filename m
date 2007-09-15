From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: u32 extension
Date: Sat, 15 Sep 2007 17:28:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709151723500.23681@fbirervta.pbzchgretzou.qr>
References: <46E50BE5.80401@trash.net>
	<Pine.LNX.4.64.0709101227020.11640@fbirervta.pbzchgretzou.qr>
	<46E51D7D.9000003@trash.net>
	<Pine.LNX.4.64.0709101238110.11640@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0709101238110.11640@fbirervta.pbzchgretzou.qr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 10 2007 12:39, Jan Engelhardt wrote:
>On Sep 10 2007 12:33, Patrick McHardy wrote:
>>Jan Engelhardt wrote:
>>> On Sep 10 2007 11:18, Patrick McHardy wrote:
>>>>
>>>>I just noticed the u32 extension is missing from iptables.
>>>>Could you send me your latest version please.
>>> 
>>> Adds u32 to iptables.
>>
>>Applied, thanks Jan.
>>
>>>  symlink extensions/libip6t_u32.man -> extensions/libipt_u32.man
>>
>>I copied it and fixed a bunch of warnings on 64 bit:
>>
>>extensions/libxt_u32.c: In function 'u32_parse':
>>extensions/libxt_u32.c:146: warning: format '%u' expects type 'unsigned
>>int', but argument 3 has type 'long int'
>
>argument 3 is actually of type ptrdiff_t, but whatever :)
>Yeah should be %lu.

Ha, not! On i586 (iptables-svn7047) I now get:

warning: format '%ld' expects type 'long int', but argument 3 has type 'int'.

Oh well, oh well. Patch below.
===


With %u alone, you would get "but arg-start is long" warnings on x64.
With %lu, you would get "but arg-start is int" on x86.
Fix it up by explicitly deciding for one (%u and cast to unsigned int)
and using that.

---
 extensions/libxt_u32.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: iptables/extensions/libxt_u32.c
===================================================================
--- iptables.orig/extensions/libxt_u32.c
+++ iptables/extensions/libxt_u32.c
@@ -142,8 +142,8 @@ static int u32_parse(int c, char **argv,
 
 			if (testind > XT_U32_MAXSIZE)
 				exit_error(PARAMETER_PROBLEM,
-				           "u32: at char %ld: too many \"&&\"s",
-				           arg - start);
+				           "u32: at char %u: too many \"&&\"s",
+				           (unsigned int)(arg - start));
 			return 1;
 		}
 
@@ -155,9 +155,9 @@ static int u32_parse(int c, char **argv,
 			if (*arg == '=') {
 				if (locind == 0) {
 					exit_error(PARAMETER_PROBLEM,
-					           "u32: at char %ld: "
+					           "u32: at char %u: "
 					           "location spec missing",
-					           arg - start);
+					           (unsigned int)(arg - start));
 				} else {
 					++arg;
 					state = 1;
@@ -170,18 +170,18 @@ static int u32_parse(int c, char **argv,
 					} else if (*arg == '<') {
 						if (*++arg != '<')
 							exit_error(PARAMETER_PROBLEM,
-								   "u32: at char %ld: a second < expected", arg - start);
+								   "u32: at char %u: a second '<' was expected", (unsigned int)(arg - start));
 						ct->location[locind].nextop = XT_U32_LEFTSH;
 					} else if (*arg == '>') {
 						if (*++arg != '>')
 							exit_error(PARAMETER_PROBLEM,
-								   "u32: at char %ld: a second > expected", arg - start);
+								   "u32: at char %u: a second '>' was expected", (unsigned int)(arg - start));
 						ct->location[locind].nextop = XT_U32_RIGHTSH;
 					} else if (*arg == '@') {
 						ct->location[locind].nextop = XT_U32_AT;
 					} else {
 						exit_error(PARAMETER_PROBLEM,
-							"u32: at char %ld: operator expected", arg - start);
+							"u32: at char %u: operator expected", (unsigned int)(arg - start));
 					}
 					++arg;
 				}
@@ -190,7 +190,7 @@ static int u32_parse(int c, char **argv,
 					parse_number(&arg, arg - start);
 				if (++locind > XT_U32_MAXSIZE)
 					exit_error(PARAMETER_PROBLEM,
-						   "u32: at char %ld: too many operators", arg - start);
+						   "u32: at char %u: too many operators", (unsigned int)(arg - start));
 			}
 		} else {
 			/*
@@ -201,17 +201,17 @@ static int u32_parse(int c, char **argv,
 			if (*arg == '&') {
 				if (*++arg != '&')
 					exit_error(PARAMETER_PROBLEM,
-						   "u32: at char %ld: a second & was expected", arg - start);
+						   "u32: at char %u: a second '&' was expected", (unsigned int)(arg - start));
 				if (valind == 0) {
 					exit_error(PARAMETER_PROBLEM,
-						   "u32: at char %ld: value spec missing", arg - start);
+						   "u32: at char %u: value spec missing", (unsigned int)(arg - start));
 				} else {
 					ct->nnums   = locind;
 					ct->nvalues = valind;
 					ct = &data->tests[++testind];
 					if (testind > XT_U32_MAXSIZE)
 						exit_error(PARAMETER_PROBLEM,
-							   "u32: at char %ld: too many \"&&\"s", arg - start);
+							   "u32: at char %u: too many \"&&\"s", (unsigned int)(arg - start));
 					++arg;
 					state  = 0;
 					locind = 0;
@@ -221,7 +221,7 @@ static int u32_parse(int c, char **argv,
 				if (valind > 0) { /* need , before number */
 					if (*arg != ',')
 						exit_error(PARAMETER_PROBLEM,
-							   "u32: at char %ld: expected , or &&", arg - start);
+							   "u32: at char %u: expected \",\" or \"&&\"", (unsigned int)(arg - start));
 					++arg;
 				}
 				ct->value[valind].min =
@@ -241,7 +241,7 @@ static int u32_parse(int c, char **argv,
 
 				if (++valind > XT_U32_MAXSIZE)
 					exit_error(PARAMETER_PROBLEM,
-						   "u32: at char %ld: too many \",\"s", arg - start);
+						   "u32: at char %u: too many \",\"s", (unsigned int)(arg - start));
 			}
 		}
 	}
