From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 1/2] ulogd: Perform nice() before giving up root
Date: Fri, 17 May 2013 10:28:41 +0200
Message-ID: <1368779321.4634.0.camel@tiger2>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
	 <1368291713-40132-2-git-send-email-bootc@bootc.net>
	 <5195DD75.7040609@bootc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:48942 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab3EQIcX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 May 2013 04:32:23 -0400
In-Reply-To: <5195DD75.7040609@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, 2013-05-17 at 08:34 +0100, Chris Boot wrote:
> On 11/05/13 18:01, Chris Boot wrote:
> > The daemon code currently tries to nice(-1) just after having given up root
> > privileges, which fails. This patch moves the nice(-1) call to just before
> > the code that gives up the required privileges.
> >
> > Signed-off-by: Chris Boot <bootc@bootc.net>
> > ---
> >  src/ulogd.c |   14 +++++++-------
> >  1 file changed, 7 insertions(+), 7 deletions(-)
> >
> > diff --git a/src/ulogd.c b/src/ulogd.c
> > index b28d0f8..8a144e3 100644
> > --- a/src/ulogd.c
> > +++ b/src/ulogd.c
> > @@ -1235,6 +1235,13 @@ int main(int argc, char* argv[])
> >  		warn_and_exit(daemonize);
> >  	}
> >  
> > +	errno = 0;
> > +	if (nice(-1) == -1) {
> > +		if (errno != 0)
> > +			ulogd_log(ULOGD_ERROR, "Could not nice process: %s\n",
> > +				  strerror(errno));
> > +	}
> > +
> >  	if (change_uid) {
> >  		ulogd_log(ULOGD_NOTICE, "Changing UID / GID\n");
> >  		if (setgid(gid)) {
> > @@ -1261,13 +1268,6 @@ int main(int argc, char* argv[])
> >  		}
> >  	}
> >  
> > -	errno = 0;
> > -	if (nice(-1) == -1) {
> > -		if (errno != 0)
> > -			ulogd_log(ULOGD_ERROR, "Could not nice process: %s\n",
> > -				  strerror(errno));
> > -	}
> > -
> >  
> >  	if (daemonize){
> >  		if (fork()) {
> 
> Hi all,
> 
> I have had no comments about this patch since I submitted it; is it
> likely to get pulled into ulogd?

Yes, it seems ok. I will give it some tests but it should be applied.

BR,

> 
> Cheers,
> Chris
> 

-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

