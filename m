From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: SVN web problems?
Date: Tue, 13 Dec 2005 11:16:57 +0300
Message-ID: <20051213081657.GA29330@2ka.mipt.ru>
References: <20051209211331.GA2897@2ka.mipt.ru>
	<20051212204554.GF3420@sunbeam.de.gnumonks.org>
	<20051212211524.GA25477@2ka.mipt.ru>
	<20051213081334.GI3420@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	PatriK McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <20051213081334.GI3420@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Dec 13, 2005 at 09:13:34AM +0100, Harald Welte (laforge@netfilter.org) wrote:
> On Tue, Dec 13, 2005 at 12:15:25AM +0300, Evgeniy Polyakov wrote:
> > On Mon, Dec 12, 2005 at 09:45:54PM +0100, Harald Welte (laforge@netfilter.org) wrote:
> > > On Sat, Dec 10, 2005 at 12:13:31AM +0300, Evgeniy Polyakov wrote:
> > > > I've just read bugzilla about OSF module and found, that it's 2.4
> > > > version does not support connector option, so I decided to download
> > > > header file [URL:
> > > > http://cvs.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/osf/linux/include/linux/netfilter_ipv4/ipt_osf.h?view=markup], 
> > > 
> > > try with
> > > http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/patchlets/osf/linux/include/linux/netfilter_ipv4/ipt_osf.h?view=markup
> > > 
> > > where did you get that old URL from?
> > 
> > From
> > 
> > http://cvs.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/osf/linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h?rev=3079&view=log
> 
> really strange.  I'm removing the old 'cvs' hostname, since we don't
> have CVS for ages.

Probably removing old directory structure is a good idea too, since it
can confuse people with old bookmarks.

> -- 
> - Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie



-- 
	Evgeniy Polyakov
