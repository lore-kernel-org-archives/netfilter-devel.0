From: Ramin Dousti <ramin@cannon.eng.us.uu.net>
Subject: Re: TTL patch buggy?
Date: Thu, 8 Jan 2004 15:56:51 -0500
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <20040108205651.GD22229@cannon.eng.us.uu.net>
References: <20040107221614.GE20346@cannon.eng.us.uu.net> <Pine.LNX.4.44.0401080812490.13863-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, netfilter@lists.netfilter.org,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0401080812490.13863-100000@filer.marasystems.com>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 08, 2004 at 08:14:14AM +0100, Henrik Nordstrom wrote:

> On Wed, 7 Jan 2004, Ramin Dousti wrote:
> 
> > Absolutely. For a sec I forgot all about the dense mode. Thanks, Henrik.
> > However, I still don't see any "danger" about this.
> 
> The danger is in if you forget about this and set the TTL on multicast as 
> if it was normal traffic. You then allow this multicast traffic to be 
> distributed widely outside your network even if the originator had taken 
> care to make sure distribution is not allowed far beyond the local 
> networks.

OK, agreed. But in general when multicasting private data, meant only
for the local nets, one must not rely on the TTL (set by the originator)
to limit the distribution. And I'm sure a well-guarded corporation
doesn't do that.

Now I'm going to shut up and learn from you, gods of the linux tcp/ip
security subsystem.

Thanks again for sharing the knowledge.

Ramin

> Regards
> Henrik
