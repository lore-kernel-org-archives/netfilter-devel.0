From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RESEND PATCH 2/2] nfacct: adding quota capabilities
Date: Mon, 28 Apr 2014 12:20:33 +0200
Message-ID: <20140428102033.GA3842@localhost>
References: <1398041896-8479-1-git-send-email-mathieu.poirier@linaro.org>
 <1398041896-8479-2-git-send-email-mathieu.poirier@linaro.org>
 <20140428085625.GA18836@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	john.stultz@linaro.org
To: mathieu.poirier@linaro.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46528 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbaD1KVg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:21:36 -0400
Content-Disposition: inline
In-Reply-To: <20140428085625.GA18836@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 28, 2014 at 10:56:25AM +0200, Pablo Neira Ayuso wrote:
> > @@ -526,28 +569,93 @@ static int nfacct_cmd_help(int argc, char *argv[])
> >  
> >  static int nfacct_cmd_restore(int argc, char *argv[])
> >  {
> > -	uint64_t pkts, bytes;
> > -	char name[512];
> > -	char buffer[512];
> > -	int ret;
> > +	uint64_t pkts, bytes, quota;
> > +	char name[512], mode[512], buffer[512];
> > +	int ret, flags;
> >  
> >  	while (fgets(buffer, sizeof(buffer), stdin)) {
> >  		char *semicolon = strchr(buffer, ';');
> > +
> >  		if (semicolon == NULL) {
> >  			nfacct_perror("invalid line");
> >  			return -1;
> >  		}
> > +
> > +		/* a single ';' terminates the input */
> > +		if (strncmp(buffer, ";", 1) == 0)
> > +			break;
> 
> This chunk seems new, why is it needed there?

I have applied this patch, we can clarify this or remove it in a
follow up patch.
