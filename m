From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack resync with 2.6.11-rc4
Date: Thu, 17 Feb 2005 22:56:42 +0900 (JST)
Message-ID: <200502171356.j1HDuhRH026138@toshiba.co.jp>
References: <20050215124751.GZ3829@sunbeam.de.gnumonks.org>
	<200502151615.23463.michal@rokos.info>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
To: michal@rokos.info
In-Reply-To: <200502151615.23463.michal@rokos.info>
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


Hi, Michal,

I applied your patch. Thanks a lot.

And I found other missing changes by using sed & diff technology ;)
I'll commit them latter.

Regards,

From: Michal Rokos <michal@rokos.info>
Date: Tue, 15 Feb 2005 16:15:23 +0100

> Hello Harald,
> 
> On Tuesday 15 February 2005 13:47, Harald Welte wrote:
> > Since lots of changes went into ip_conntrack over the last months, I
> > went through the pain of re-synchronizing nf_conntrack with
> > ip_conntrack, hopefully this was the last time.
> 
> isn't this one missing?
> 
>  Michal
> 
> -- 
>         Michal Rokos
> 
>  email: <michal AT rokos DOT info>    
> jabber: <majkl AT jabber DOT cz>
>    icq: 36118339 
