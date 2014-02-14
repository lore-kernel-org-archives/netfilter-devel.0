From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 nft] scanner: fix parsing of tc handle
Date: Fri, 14 Feb 2014 11:59:04 +0100
Message-ID: <20140214105904.GA21451@localhost>
References: <1392291672-7885-1-git-send-email-pablo@netfilter.org>
 <1392291672-7885-2-git-send-email-pablo@netfilter.org>
 <20140213115112.GA30397@macbook.localnet>
 <20140213130102.GB4223@macbook.localnet>
 <20140213133137.GA9181@localhost>
 <20140213133638.GB5467@macbook.localnet>
 <20140213141709.GA6456@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36845 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaBNK7K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:59:10 -0500
Content-Disposition: inline
In-Reply-To: <20140213141709.GA6456@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 13, 2014 at 02:17:09PM +0000, Patrick McHardy wrote:
> On Thu, Feb 13, 2014 at 01:36:38PM +0000, Patrick McHardy wrote:
> > On Thu, Feb 13, 2014 at 02:31:37PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Feb 13, 2014 at 01:01:03PM +0000, Patrick McHardy wrote:
> > > > On Thu, Feb 13, 2014 at 11:51:12AM +0000, Patrick McHardy wrote:
> > > > 
> > > > I think we might be able to do something with flex "trailing contexts",
> > > > though I didn't manage to figure it out yet.
> > > > 
> > > > Generally it seems like using a ':' in maps might not be the best idea
> > > > after all, its used for too many other things already. This might be
> > > > the reason why I initially used =>, not sure anymore.
> > > > 
> > > > Is there a reasonable alternative to ':' with a single character?
> > > 
> > > Everything seems pretty overloaded, and I still like that python uses
> > > this for dictionaries.
> > 
> > I also thing this would be the nicest way to express this.
> > 
> > > I think even bash and gcc provide bad error reporting if one space is
> > > missing in a for/while statement or a missing bracket is left out.
> > > 
> > > Let's check if that trailing context can help us to fix it, if not,
> > > just document it.
> > 
> > I think I almost got it using:
> > 
> > {priostring}/[ \t\n:]   {
> > 
> > Only thing missing is EOF handling, IOW when the priostring is the last
> > expression on the command line (not in files) it fails.
> > 
> > I also changed priostring to:
> > 
> > priostring      ({hexdigit}{1,4}:{hexdigit}{0,4})|({hexdigit}{0,4}:{hexdigit}{1,4})
> > 
> > since it otherwise also matches a single ':'. I'll try again later, have
> > to take care of other things first.
> 
> This is what I'm currently testing. Seems to work alright, it even
> recognizes
> 
> filter output meta priority { ffff:ffff:accept }
> 
> correctly.

This patch works here after some testing. Thanks Patrick!

> diff --git a/src/erec.c b/src/erec.c
> index 4930085..5bb8141 100644
> --- a/src/erec.c
> +++ b/src/erec.c
> @@ -84,6 +84,7 @@ void erec_print(FILE *f, const struct error_record *erec)
>  	case INDESC_BUFFER:
>  	case INDESC_CLI:
>  		line = indesc->data;
> +		*strchrnul(line, '\n') = '\0';
>  		break;
>  	case INDESC_FILE:
>  		memset(buf, 0, sizeof(buf));
> diff --git a/src/main.c b/src/main.c
> index 9d50577..56e2ecd 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -307,12 +307,13 @@ int main(int argc, char * const *argv)
>  		for (len = 0, i = optind; i < argc; i++)
>  			len += strlen(argv[i]) + strlen(" ");
>  
> -		buf = xzalloc(len + 1);
> +		buf = xzalloc(len + 2);
>  		for (i = optind; i < argc; i++) {
>  			strcat(buf, argv[i]);
>  			if (i + 1 < argc)
>  				strcat(buf, " ");
>  		}
> +		strcat(buf, "\n");
>  		parser_init(&state, &msgs);
>  		scanner = scanner_init(&state);
>  		scanner_push_buffer(scanner, &indesc_cmdline, buf);
> diff --git a/src/scanner.l b/src/scanner.l
> index cd68534..07f0810 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -109,7 +109,7 @@ digit		[0-9]
>  hexdigit	[0-9a-fA-F]
>  decstring	{digit}+
>  hexstring	0[xX]{hexdigit}+
> -range		({decstring}?:{decstring}?)
> +priostring	({hexdigit}{1,4}:{hexdigit}{0,4})|({hexdigit}{0,4}:{hexdigit}{1,4})
>  letter		[a-zA-Z]
>  string		({letter})({letter}|{digit}|[/\-_\.])*
>  quotedstring	\"[^"]*\"
> @@ -449,6 +449,13 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  				return STRING;
>  			}
>  
> +{priostring}/[ \t\n:]	{
> +				printf("priostring %s\n", yytext);
> +				yylval->string = xstrdup(yytext);
> +				return STRING;
> +			}
> +
> +
>  \\{newline}		{
>  				reset_pos(yyget_extra(yyscanner), yylloc);
>  			}
