From: Patrick Schaaf <bof@bof.de>
Subject: Re: disturbing MTU experiment
Date: Tue, 8 Apr 2003 20:40:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030408184051.GB14357@oknodo.bof.de>
References: <20030408154101.13919.89741.Mailman@kashyyyk> <16018.64600.149601.372694@isis.cs3-inc.com> <20030408174753.GA8158@pc.ilinx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030408174753.GA8158@pc.ilinx>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > 3. Are links with MTU < 1500 are extremely rare in the internet?
> 
> Good question.

They are increasingly common. PPPoE DSL links run at 1496, and all kinds
of tunneling results in even smaller MTU, e.g. 1454 for maximally
conservative L2TP links.

> > 4. What can be done about it?
> 
> There was/is a project on the Internet to identify and notify owners
> of PMTU blackholes.  I don't recall the URL however.

http://mss.phildev.net/
http://lartc.org/howto/lartc.cookbook.mtu-mss.html

best regards
  Patrick
