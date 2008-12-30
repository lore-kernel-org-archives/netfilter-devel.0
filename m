From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables-restore: remove unused --binary flag
Date: Tue, 30 Dec 2008 12:08:19 +0100
Message-ID: <495A0123.3020509@netfilter.org>
References: <alpine.LNX.1.10.0812242031570.514@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55759 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751557AbYL3LI3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Dec 2008 06:08:29 -0500
In-Reply-To: <alpine.LNX.1.10.0812242031570.514@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 67f4e55f28abf2f666c0a0aa874d9421e91d6184
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Dec 24 20:30:47 2008 +0100
> 
> iptables-restore: remove unused --binary flag
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  ip6tables-restore.c |    7 +------
>  iptables-restore.c  |    7 +------
>  iptables-save.c     |   12 ++----------
>  3 files changed, 4 insertions(+), 22 deletions(-)
> 
> diff --git a/ip6tables-restore.c b/ip6tables-restore.c
> index 01bccf7..0920760 100644
> --- a/ip6tables-restore.c
> +++ b/ip6tables-restore.c
> @@ -26,11 +26,10 @@
>  #define DEBUGP(x, args...)
>  #endif
>  
> -static int binary = 0, counters = 0, verbose = 0, noflush = 0;
> +static int counters = 0, verbose = 0, noflush = 0;
>  
>  /* Keeping track of external matches and targets.  */
>  static const struct option options[] = {
> -	{.name = "binary",   .has_arg = false, .val = 'b'},
>  	{.name = "counters", .has_arg = false, .val = 'c'},
>  	{.name = "verbose",  .has_arg = false, .val = 'v'},
>  	{.name = "test",     .has_arg = false, .val = 't'},
> @@ -45,7 +44,6 @@ static void print_usage(const char *name, const char *version) __attribute__((no
>  static void print_usage(const char *name, const char *version)
>  {
>  	fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-t] [-h]\n"
> -			"	   [ --binary ]\n"
>  			"	   [ --counters ]\n"
>  			"	   [ --verbose ]\n"
>  			"	   [ --test ]\n"
> @@ -144,9 +142,6 @@ int main(int argc, char *argv[])
>  
>  	while ((c = getopt_long(argc, argv, "bcvthnM:", options, NULL)) != -1) {
>  		switch (c) {
> -			case 'b':
> -				binary = 1;
> -				break;

I doubt that someone is using this option, anyhow I think that it would
be better to output a warning message to stderr that says "-b is
deprecated, fix your scripts". Later, we can remove it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
