From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH 4/6] ipset: Rework the "fake" argument parsing for ipset restore.
Date: Thu, 19 Sep 2013 16:56:20 +0200
Message-ID: <3741696.TYR9IgWk1Y@gentoovm>
References: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1379423605-22777-5-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <alpine.DEB.2.00.1309182016290.21599@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:41183 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3ISO4b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Sep 2013 10:56:31 -0400
In-Reply-To: <alpine.DEB.2.00.1309182016290.21599@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 18 September 2013 20:22:41 Jozsef Kadlecsik wrote:
> On Tue, 17 Sep 2013, Oliver wrote:
<snip>
> > -	newargv[newargc++] = ptr;
> > +	newargv[newargc] = calloc(strlen(ptr) + 1, sizeof(*ptr));
> > +	ipset_strlcpy(newargv[newargc++], ptr, strlen(ptr) + 1);
> > 
> >  	while ((ptr = strtok(NULL, " \t\r\n")) != NULL) {
> > 
> > -		if ((newargc + 1) < (int)(sizeof(newargv)/sizeof(char *)))
> > -			newargv[newargc++] = ptr;
> > -		else {
> > +		if ((newargc + 1) < (int)(sizeof(newargv)/sizeof(char *))) {
> > +			tmp = newargv[newargc] = calloc(strlen(ptr) + 1,
> > +							sizeof(*ptr));
> > +			if(*ptr == '"') {
> > +				ipset_strlcpy(tmp, ptr + 1, (strlen(ptr) + 1) *
> > +					      sizeof(*ptr));
> > +				ipset_strlcat(tmp, " ", (strlen(ptr) + 1) *
> > +					      sizeof(*ptr));
> > +				while((ptr = strtok(NULL, "\"")) != NULL) {
> > +					if(*ptr == '\n' || *ptr == '\r')
> > +						continue;
> > +					tmp = realloc(tmp, (strlen(tmp) +
> > +						      strlen(ptr) + 1) *
> > +						      sizeof(*ptr));
> > +					ipset_strlcat(tmp, ptr, (strlen(tmp) +
> > +						      strlen(ptr) + 1) *
> > +						      sizeof(*ptr));
> > +				}
> 
> Why is there the inside while loop? We look for a single closing quote.
> Also, I'd better like to see an error reported if the closing quote is
> missing instead of silently accepting it.
So, I've come to the conclusion that is is all horribly ugly and strtok is 
more of a hinderance than a help here, so... I've redone it in a very similar 
vein to that of the iptables_restore code.

Kind Regards,
Oliver
