From: Ben Reser <ben@reser.org>
Subject: Re: MIME Patches (was [PATCH] ROUTE target : bug fixes)
Date: Fri, 21 Jun 2002 10:56:24 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020621175624.GF2355@titanium.brain.org>
References: <1024582362.2418.30.camel@descartes> <20020621191526.G2543@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020621191526.G2543@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jun 21, 2002 at 07:15:26PM +0200, Harald Welte wrote:
> Please try to send patches as mime attachment to ensure no corruption 
> occurs.

Okay this is confusing.  Your scoreboard guidelines
(http://www.netfilter.org/scoreboard/) say that you should include
patches "straight in the body of the message, not MIME'd."  Honestly
I've always found this policy bizzare.

It wasn't but a week ago that Henrik was asking that someone resend a
MIME'd patch in plain text.
(http://lists.samba.org/pipermail/netfilter-devel/2002-June/004760.html)
Yes I understand that one was base64'ed but some people may not have
complete control over how their MIME implementation works.

If the argument against MIME is that the mailing list archives can't
handle it.  Perhaps those people should switch to using
marc.theaimsgroup.com.  For instance the very message Henrik was
complaining about not being readable because it was base64 is handled
properly here:
http://marc.theaimsgroup.com/?l=netfilter-devel&m=102389029101252&w=2

Either way we should pick a standard and follow it.  Frankly MIME is a
common standard and attaching patch is intuitive.  So I think we should
go that route.  

-- 
Ben Reser <ben@reser.org>
http://ben.reser.org

We tend to see all wars through the lens of the current conflict, and we
mine history for lessons convenient to the present purpose.
- Brian Hayes
