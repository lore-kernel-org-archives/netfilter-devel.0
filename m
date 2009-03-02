From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libxt_string: fix undefined behavior/incorrect patlen calculation
Date: Mon, 02 Mar 2009 11:48:57 +0100
Message-ID: <49ABB999.80709@netfilter.org>
References: <20090301223735.GA25389@safeTpin.homeunix.org> <alpine.LSU.2.00.0903020324590.10419@fbirervta.pbzchgretzou.qr> <49ABA3D0.1060906@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010708020102000001080301"
Cc: Jan Engelhardt <jengelh@medozas.de>, pud <pud@subnet666.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59035 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755406AbZCBKtK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:49:10 -0500
In-Reply-To: <49ABA3D0.1060906@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010708020102000001080301
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

John Haxby wrote:
> Jan Engelhardt wrote:
>> On Sunday 2009-03-01 23:37, pud wrote:
>>  
>>> (sorry, msg-id lost)
>>>
>>>    
>>>> commit 19b0cd770d1e042c85bf0b278261a61d4cea8193
>>>> Author: Jan Engelhardt <jeng...@medozas.de>
>>>> Date: Thu Feb 12 01:18:35 2009 +0100
>>>>       
>>> ...
>>>    
>>>> - stringinfo->patlen=strlen((char *)&stringinfo->pattern);
>>>> + stringinfo->patlen = strnlen((char *)&stringinfo->pattern,
>>>> +                           sizeof(stringinfo->patlen));
>>>>       
>>> sorry, this doesn't work here, did you mean
>>> sizeof(stringinfo->pattern)?
>>>     
>>
>> What do you mean "doesnot work"?
>>   
> 
> It looks very weird to me as well.   I may well be confused, but
> 
>    stringinfo->patlen = strnlen((char *)&stringinfo->pattern,
> sizeof(stringinfo->patlen))
> 
> looks like something roughly equivalent to this:
> 
>    char pattern[256];
>    int patlen;
>    patlen = strlen(pattern, 4);
> 
> The "4" is sizeof(int) rather than the size of "pattern"

Indeed. This was broken in:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commitdiff;h=37b4bde745698bf140d74e59a2561f34deeb8726;hp=41f03ba382dfd26e7db939fd02447058b1c56f7b

Fix is attached.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010708020102000001080301
Content-Type: text/x-diff;
 name="fix-string.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-string.patch"

string: fix wrong pattern length calculation

This fixes a problem introduced in 37b4bde745698bf140d74e59a2561f34deeb8726
that leads to the wrong calculation of the pattern length in the
string match.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 extensions/libxt_string.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 5ea529e..ba4b720 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -64,9 +64,10 @@ static void string_init(struct xt_entry_match *m)
 static void
 parse_string(const char *s, struct xt_string_info *info)
 {	
+	/* xt_string does not need \0 at the end of the pattern */
 	if (strlen(s) <= XT_STRING_MAX_PATTERN_SIZE) {
 		strncpy(info->pattern, s, XT_STRING_MAX_PATTERN_SIZE);
-		info->patlen = strlen(s);
+		info->patlen = strnlen(s, XT_STRING_MAX_PATTERN_SIZE);
 		return;
 	}
 	xtables_error(PARAMETER_PROBLEM, "STRING too long \"%s\"", s);
@@ -75,7 +76,8 @@ parse_string(const char *s, struct xt_string_info *info)
 static void
 parse_algo(const char *s, struct xt_string_info *info)
 {
-	if (strlen(s) <= XT_STRING_MAX_ALGO_NAME_SIZE) {
+	/* xt_string needs \0 for algo name */
+	if (strlen(s) < XT_STRING_MAX_ALGO_NAME_SIZE) {
 		strncpy(info->algo, s, XT_STRING_MAX_ALGO_NAME_SIZE);
 		return;
 	}
@@ -208,8 +210,6 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 			else
 				stringinfo->u.v1.flags |= XT_STRING_FLAG_INVERT;
 		}
-		stringinfo->patlen = strnlen((char *)&stringinfo->pattern,
-			sizeof(stringinfo->patlen));
 		*flags |= STRING;
 		break;
 

--------------010708020102000001080301--
