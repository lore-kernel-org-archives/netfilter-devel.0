From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: manual connection adding to ip_conntrack hash table
Date: Fri, 16 Jan 2004 18:03:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1074272620.22839.46.camel@nienna.balabit>
References: <Pine.LNX.4.44.0401161721460.30706-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Konrad D." <darnok@post.pl>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401161721460.30706-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Fri, 2004-01-16 at 17:53, Henrik Nordstrom wrote:
> > I'm in the course of writing my thesis about connection tracking in netfilter,
> > it's sad but I need help. So I'm asking for help you, the netfilter developers.
> > Topic of my thesis is High Availability Firewall.
> 
> There has been several projects aiming to add connection tracking
> synchronisation/failover to netfiler, but so far it is not completed.
> 
> The most current and active is netfilter-ha which can be browsed at
> http://cvs.netfilter.org/netfilter-ha/ with mailinglist at 
> http://lists.netfilter.org/mailman/listinfo/netfilter-failover

  I can recommend reading Harald's paper on Netfilter failover, which
can be found in the proceedings of OLS 2002
(http://www.linux.org.uk/~ajh/ols2002_proceedings.pdf.gz). I also have a
thesis in Hungarian, largely based on Haralds paper, but I don't think
that it would be of much help for you. Browsing the archives of the
netfilter-failover list can also provide you with the basic ideas behind
the latest approach, which has some not completed code in the CVS.

  And of course, feel free to ask, either here or on netfilter-failover.

-- 
 Regards,
   Krisztian KOVACS
