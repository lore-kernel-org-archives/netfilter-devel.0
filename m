From: "David S. Miller" <davem@redhat.com>
Subject: Re: [BUG] active ftp doesn't work since 2.6.9-rc1
Date: Fri, 1 Oct 2004 15:30:42 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041001153042.15ed4a82.davem@redhat.com>
References: <20041001111201.GA23033@pc11.op.pod.cz>
	<20041001132248.GG27499@sunbeam.de.gnumonks.org>
	<20041001141050.GH27499@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	samel@mail.cz
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041001141050.GH27499@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 1 Oct 2004 16:10:50 +0200
Harald Welte <laforge@netfilter.org> wrote:

> On Fri, Oct 01, 2004 at 03:22:48PM +0200, Harald Welte wrote:
> > On Fri, Oct 01, 2004 at 01:12:01PM +0200, Vitezslav Samel wrote:
> > > 	Hi!
> > > 
> > >   After upgrade to 2.6.9-rc3 on the firewall (with NAT), active ftp stopped
> > > working. The first kernel, which doesn't work is 2.6.9-rc1.
> > > Sympotms: passive ftp works O.K., active FTP doesn't open data
> > > stream (and in logs there entries about invalid packets - using
> > > iptables ... -m state --state INVALID -j LOG)
> 
> Please use the following (attached) fix:
> 
> DaveM: Please apply and push to Linus:

Will do, thanks Harald.
