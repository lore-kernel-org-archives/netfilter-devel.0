From: Phil Oester <kernel@linuxace.com>
Subject: Re: ip6tables-save LOG target output is different to iptables-save
Date: Sat, 6 Jul 2013 08:56:01 -0700
Message-ID: <20130706155601.GA31065@linuxace.com>
References: <CAC+BxFrOpO8UWdd4xa146AsZN52A2hSOmaTiyvOmQK-qktzVPg@mail.gmail.com>
 <20130706044121.GA15084@linuxace.com>
 <CAC+BxFovBteFJQ=K7LHPX47CxAAbGpBuzCvdTdsU00AvxJ-pag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Scott Baillie <scott.a.baillie@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46000 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3GFP4B (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Jul 2013 11:56:01 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so2818445pdj.28
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Jul 2013 08:56:01 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAC+BxFovBteFJQ=K7LHPX47CxAAbGpBuzCvdTdsU00AvxJ-pag@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 06, 2013 at 03:07:15PM +1000, Scott Baillie wrote:
> It just makes it a little bit harder to parse the output , because
> both tools should produce the same output
> wherever possible in my opinion.

Agreed.  Patch follows which makes the two tools consistent, however
they will now both not quote the prefix if only one word is present.

libipt_LOG is using the xtables_save_string func, which escapes unsafe
characters as needed.  libip6t_LOG should do the same.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ip6ts-log

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 2b1ae28..4639268 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -146,8 +146,10 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 	const struct ip6t_log_info *loginfo
 		= (const struct ip6t_log_info *)target->data;
 
-	if (strcmp(loginfo->prefix, "") != 0)
-		printf(" --log-prefix \"%s\"", loginfo->prefix);
+	if (strcmp(loginfo->prefix, "") != 0) {
+		printf(" --log-prefix");
+		xtables_save_string(loginfo->prefix);
+	}
 
 	if (loginfo->level != LOG_DEFAULT_LEVEL)
 		printf(" --log-level %d", loginfo->level);

--Qxx1br4bt0+wmkIi--
