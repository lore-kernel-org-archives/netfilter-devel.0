From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: oops in tftp helper
Date: Mon, 29 Sep 2003 15:30:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030929133012.GA4084@balabit.hu>
References: <20030929130509.GA4010@balabit.hu> <Pine.LNX.4.33.0309291520000.2237-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0309291520000.2237-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Sep 29, 2003 at 03:22:54PM +0200, Jozsef Kadlecsik wrote:
> On Mon, 29 Sep 2003, Balazs Scheidler wrote:
> 
> > We have encountered the following oops when trying to use the TFTP conntrack
> > helper. We do not use NAT, only connection tracking. The culprit seems to be
> > this code in init_conntrack():
> 
> What is the kernel version? Could you write down exactly when the oops
> happens, I mean what actions are going on in the tftp session?

Nothing special, I've loaded the tftp helper, added the rules and were
trying to initiate tftp sessions. and as it didn't work I started tcpdump
several times to see what happens. After one of my tcpdump commands the box
froze and displayed the oops I've included in my previous message.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
