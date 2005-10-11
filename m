From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: x_tables vs. nf-hipac
Date: Tue, 11 Oct 2005 17:18:49 +0000
Message-ID: <1129051129.3378.22.camel@localhost.localdomain>
References: <434A4B11.4030103@gmx.net>  <20051010163442.GC5627@rama>
	<1128983497.3377.4.camel@localhost.localdomain>
	<Pine.LNX.4.61.0510111426270.2051@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0510111426270.2051@filer.marasystems.com>
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

Op di, 11-10-2005 te 14:27 +0200, schreef Henrik Nordstrom:
> On Mon, 10 Oct 2005, Bart De Schuymer wrote:
> 
> > Nice to see this move forward. If you want to put the arptables
> > userspace tool into the netfilter tree
> 
> How different is the arptables userspace tool from the iptables userspace 
> tool?

It doesn't differ much, most code was copied without changes from
iptables. This was done a lot of months ago, so all changes to iptables
since then are not reflected in arptables. One thing though is that it
needs to distinguish between 2.4 and 2.6 kernels (the latter having the
arptables FORWARD chain).

cheers,
Bart
