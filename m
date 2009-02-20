From: Ralf <rm@amitrader.com>
Subject: Re: Syntax errors in man and help regarding rulenum placement
Date: Fri, 20 Feb 2009 17:51:30 +0100
Message-ID: <gnmn2j$mvh$1@ger.gmane.org>
References: <gnmh9h$vt7$1@ger.gmane.org> <alpine.LSU.2.00.0902201640001.27281@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:36323 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBTQvs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:51:48 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LaYbG-0000HQ-1O
	for netfilter-devel@vger.kernel.org; Fri, 20 Feb 2009 16:51:42 +0000
Received: from p57a2fbdf.dip.t-dialin.net ([87.162.251.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 16:51:42 +0000
Received: from rm by p57a2fbdf.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 16:51:42 +0000
In-Reply-To: <alpine.LSU.2.00.0902201640001.27281@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2009-02-20 16:12, Ralf wrote:
> 
>> man iptables of v1.4.2 gives these 2 different syntaxes
>> for example for the -I option: 
>> iptables [-t table] -I [rulenum] rule-specification [options...]
>>
>> iptables [-t table] -I chain [rulenum] rule-specification
>>
>>
>> And iptables --help gives these:
>>
>> iptables -[RI] chain rulenum rule-specification [options]
>>
>> --insert  -I chain [rulenum]
>>
>> This is all irritating, don't you think so?
>> Which of them is the officially correct one
>> regarding the placement (location) of the rulenum?
 
Hmm. Jan, I'm afraid there is more to fix because of the fact
that rulenum is mostly optional...
The main question here is: must rulenum come before OR after the chain?


 
> parent 6db2ded2f22a7e78743c86af523b8430876582e9 (v1.4.3-rc1-81-g6db2ded)
> commit 26128f4386b9eb202d9288e7b414cb3ae43819f9
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Fri Feb 20 16:39:54 2009 +0100
> 
> doc: resynchronize manpage with in-code help
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  ip6tables.8.in |    6 +++---
>  ip6tables.c    |    3 ++-
>  iptables.8.in  |    6 +++---
>  iptables.c     |    3 ++-
>  4 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/ip6tables.8.in b/ip6tables.8.in
> index 3d19a4c..a31887e 100644
> --- a/ip6tables.8.in
> +++ b/ip6tables.8.in
> @@ -30,16 +30,16 @@ ip6tables - IPv6 packet filter administration
>  \fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain
>  rule-specification\fP [\fIoptions...\fP]
>  .PP
> -\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP [\fIrulenum\fP]
> +\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP \fIchain\fP [\fIrulenum\fP]
>  \fIrule-specification\fP [\fIoptions...\fP]
>  .PP
> -\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIrulenum
> +\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIchain rulenum
>  rule-specification\fP [\fIoptions...\fP]
>  .PP
>  \fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-D\fP \fIchain rulenum\fP
>  [\fIoptions...\fP]
>  .PP
> -\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-S\fP [\fIchain\fP]
> +\fBip6tables\fP [\fB\-t\fP \fItable\fP] \fB\-S\fP [\fIchain\fP [\fIrulenum\fP]]
>  .PP
>  \fBip6tables\fP [\fB\-t\fP \fItable\fP] {\fB\-F\fP|\fB\-L\fP|\fB\-Z\fP}
>  [\fIchain\fP] [\fIoptions...\fP]
> diff --git a/ip6tables.c b/ip6tables.c
> index 06c0a60..21a0a4e 100644
> --- a/ip6tables.c
> +++ b/ip6tables.c
> @@ -240,7 +240,8 @@ exit_printhelp(struct xtables_rule_match *matches)
>  
>  	printf("%s v%s\n\n"
>  "Usage: %s -[AD] chain rule-specification [options]\n"
> -"       %s -[RI] chain rulenum rule-specification [options]\n"
> +"       %s -I chain [rulenum] rule-specification [options]\n"
> +"       %s -R chain rulenum rule-specification [options]\n"
>  "       %s -D chain rulenum [options]\n"
>  "       %s -[LS] [chain [rulenum]] [options]\n"
>  "       %s -[FZ] [chain] [options]\n"
> diff --git a/iptables.8.in b/iptables.8.in
> index 2bbd9a7..10dcb73 100644
> --- a/iptables.8.in
> +++ b/iptables.8.in
> @@ -27,13 +27,13 @@ iptables - administration tool for IPv4 packet filtering and NAT
>  .SH SYNOPSIS
>  \fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-A\fP|\fB\-D\fP} \fIchain\fP \fIrule-specification\fP
>  .PP
> -\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP [\fIrulenum\fP] \fIrule-specification\fP
> +\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-I\fP \fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP
>  .PP
> -\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIrulenum rule-specification\fP
> +\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-R\fP \fIchain rulenum rule-specification\fP
>  .PP
>  \fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-D\fP \fIchain rulenum\fP
>  .PP
> -\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-S\fP [\fIchain\fP]
> +\fBiptables\fP [\fB\-t\fP \fItable\fP] \fB\-S\fP [\fIchain\fP [\fIrulenum\fP]]
>  .PP
>  \fBiptables\fP [\fB\-t\fP \fItable\fP] {\fB\-F\fP|\fB\-L\fP|\fB\-Z\fP} [\fIchain\fP] [\fIoptions...\fP]
>  .PP
> diff --git a/iptables.c b/iptables.c
> index a8e97c7..56b46b8 100644
> --- a/iptables.c
> +++ b/iptables.c
> @@ -254,7 +254,8 @@ exit_printhelp(struct xtables_rule_match *matches)
>  
>  	printf("%s v%s\n\n"
>  "Usage: %s -[AD] chain rule-specification [options]\n"
> -"       %s -[RI] chain rulenum rule-specification [options]\n"
> +"       %s -I chain [rulenum] rule-specification [options]\n"
> +"       %s -R chain rulenum rule-specification [options]\n"
>  "       %s -D chain rulenum [options]\n"
>  "       %s -[LS] [chain [rulenum]] [options]\n"
>  "       %s -[FZ] [chain] [options]\n"

