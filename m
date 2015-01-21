From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 7/9] rhashtable: Per bucket locks & deferred
 expansion/shrinking
Date: Tue, 20 Jan 2015 21:36:20 -0800
Message-ID: <20150121053620.GZ9719@linux.vnet.ibm.com>
References: <063D6719AE5E284EB5DD2968C1650D6D1CACADAF@AcuExch.aculab.com>
 <20150116165302.GE15052@casper.infradead.org>
 <20150116183626.GS30132@acer.localdomain>
 <20150116191831.GA26730@casper.infradead.org>
 <20150116193557.GU30132@acer.localdomain>
 <20150116204644.GA2232@salvia>
 <20150119090121.GG9719@linux.vnet.ibm.com>
 <20150121052333.GA23382@gondor.apana.org.au>
 <20150121052907.GY9719@linux.vnet.ibm.com>
 <20150121053025.GA23481@gondor.apana.org.au>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Thomas Graf <tgraf@suug.ch>,
	David Laight <David.Laight@ACULAB.COM>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"edumazet@google.com" <edumazet@google.com>,
	"john.r.fastabend@intel.com" <john.r.fastabend@intel.com>,
	"josh@joshtriplett.org" <josh@joshtriplett.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150121053025.GA23481@gondor.apana.org.au>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 21, 2015 at 04:30:25PM +1100, Herbert Xu wrote:
> On Tue, Jan 20, 2015 at 09:29:07PM -0800, Paul E. McKenney wrote:
> > 
> > Well, you -could- batch them up, so that a single snapshot covered
> > several users, and once that set was done and memory reclaimed, a second
> > snapshot could cover any additional users that requested dumps/walks in
> > the meantime.  Or are users allowed to walk arbitrarily slowly through
> > the table?
> 
> Yes they can.  You could CTRL-Z a dumper quite easily.

OK, never mind, then!  ;-)

							Thanx, Paul
