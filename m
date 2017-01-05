From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [-stable 4.8.y] Revert NAT conversion to rhashtable
Date: Thu, 5 Jan 2017 12:45:37 +0100
Message-ID: <20170105114537.GA8859@kroah.com>
References: <20161219164333.GA2811@salvia>
 <20170104173036.GA30083@kroah.com>
 <20170105105207.GA1962@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org,
        fw@strlen.int, davem@davemloft.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170105105207.GA1962@salvia>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 05, 2017 at 11:52:07AM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 04, 2017 at 06:30:36PM +0100, Greg Kroah-Hartman wrote:
> > On Mon, Dec 19, 2016 at 05:43:33PM +0100, Pablo Neira Ayuso wrote:
> > > Hi Greg,
> > > 
> > > Please revert the following two patches from 4.8.y:
> > > 
> > > 870190a9ec9075205c0fa795a09fa931694a3ff1 ("netfilter: nat: convert nat
> > > bysrc hash to rhashtable")
> > > 
> > > 7c9664351980aaa6a4b8837a314360b3a4ad382a ("netfilter: move nat
> > > hlist_head to nf_conn")
> > > 
> > > There are incremental fixes in 4.9 to resolve the problems in these
> > > two, but they also require the new rhlist interface not available
> > > there.
> > 
> > Now reverted, thanks!
> 
> thanks a lot Greg.
> 
> I have more updates for you, will be sending them asap.

If they are for 4.8, don't worry too much about that kernel, it will go
end-of-life in another release.  But patches for 4.4 and 4.9 are greatly
appreciated if you have them.

thanks,

greg k-h
