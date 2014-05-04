From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RESEND PATCH 2/2] nfacct: adding quota capabilities
Date: Sun, 4 May 2014 14:30:43 +0200
Message-ID: <20140504123043.GA26519@localhost>
References: <1398041896-8479-1-git-send-email-mathieu.poirier@linaro.org>
 <1398041896-8479-2-git-send-email-mathieu.poirier@linaro.org>
 <20140428085625.GA18836@localhost>
 <20140428102033.GA3842@localhost>
 <CANLsYky2jcZF=hxMaXaYj_7jjn1GjtqTEXbSv9mBJ_Vn8sdJ4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	John Stultz <john.stultz@linaro.org>
To: Mathieu Poirier <mathieu.poirier@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41211 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbaEDMas (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 May 2014 08:30:48 -0400
Content-Disposition: inline
In-Reply-To: <CANLsYky2jcZF=hxMaXaYj_7jjn1GjtqTEXbSv9mBJ_Vn8sdJ4w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 30, 2014 at 02:30:22PM -0600, Mathieu Poirier wrote:
> On 28 April 2014 04:20, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Apr 28, 2014 at 10:56:25AM +0200, Pablo Neira Ayuso wrote:
> >> > @@ -526,28 +569,93 @@ static int nfacct_cmd_help(int argc, char *argv[])
> >> >
> >> >  static int nfacct_cmd_restore(int argc, char *argv[])
> >> >  {
> >> > -   uint64_t pkts, bytes;
> >> > -   char name[512];
> >> > -   char buffer[512];
> >> > -   int ret;
> >> > +   uint64_t pkts, bytes, quota;
> >> > +   char name[512], mode[512], buffer[512];
> >> > +   int ret, flags;
> >> >
> >> >     while (fgets(buffer, sizeof(buffer), stdin)) {
> >> >             char *semicolon = strchr(buffer, ';');
> >> > +
> >> >             if (semicolon == NULL) {
> >> >                     nfacct_perror("invalid line");
> >> >                     return -1;
> >> >             }
> >> > +
> >> > +           /* a single ';' terminates the input */
> >> > +           if (strncmp(buffer, ";", 1) == 0)
> >> > +                   break;
> >>
> >> This chunk seems new, why is it needed there?
> >
> > I have applied this patch, we can clarify this or remove it in a
> > follow up patch.
> 
> I've investigated this a little more to find out that my EOF character
> wasn't coming in properly on my target.  After correction the original
> code works properly and as such the highlighted chunk is not needed.
> 
> I can send a new patch or you can edit it out directly - pls get back
> to me with that you prefer.

Please, send me a follow up patch. This is already in master. Thanks.
