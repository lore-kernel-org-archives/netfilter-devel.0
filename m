From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: locking issue in ip_conntrack_alter_reply
Date: Mon, 3 May 2004 15:25:13 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405031523560.15193-100000@filer.marasystems.com>
References: <40964395.7010403@eurodev.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <40964395.7010403@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 3 May 2004, Pablo Neira wrote:

> Hi Patrick,
> 
> Patrick McHardy wrote:
> 
> > Jozsef Kadlecsik wrote:
> >
> >> The assertion is right, because we alter unconfirmed packets when 
> >> setting
> >> up nat info. And you're also right, write-locking is unnecessary: the
> >> entry is not in the hash table yet, so nobody else can grab and 
> >> modify the
> >> conntrack entry. [And it is overlooked in the per bucket locking 
> >> patch too.]
> >
> >
> > I've ported your conntrack patches to 2.6, I will include this change
> > before adding them to CVS.
> 
> 
> Attached the patch to fix this.

Isn't there a LOCK/UNLOCK imbalance in your patch?

Regards
Henrik
