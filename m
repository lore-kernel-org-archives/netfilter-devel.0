From: David Stes <stes@pandora.be>
Subject: Re:
Date: Mon, 12 Sep 2005 22:02:10 +0200
Message-ID: <20050912220210.A7355@dD5E02985.access.telenet.be>
References: <20050912163005.023FF14F583@ladon.telenet-ops.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050912163005.023FF14F583@ladon.telenet-ops.be>;
	from netfilter-devel-request@lists.netfilter.org on Mon, Sep 12,
	2005 at 06:30:05PM +0200
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

> Date: Mon, 12 Sep 2005 16:29:38 +0000
> From: Cory Visi <merlin@gentoo.org>
> Subject: patchlets patch submission
> To: netfilter-devel@lists.netfilter.org
> Message-ID: <20050912162938.GB15843@toucan.gentoo.org>
> Content-Type: text/plain; charset="us-ascii"
> 
> I did some work on fixing the conntrack pom addons for the lockhelp.h 
> patch (2.6.13 support essentially). I think I got everything setup except 
> for 2 files.
> 
> Attached is all my work in patch form against a full kernel source. I have 
> a feeling you'd prefer I sent this in some other format or in some other 
> structure of a diff. This is my first time contributing so just let me 
> know how you'd prefer this in the future.
> 
> What's left is:
> - rtsp (part of rsh)

Did you also do the RPC modules ? (RPC for UDP/TCP)

I wonder whether the author(s) of RSH/RPC modules are still reading this list.

If they are, then maybe your 2.6.13 patch (and my older 2.6.12 patches)
could be incorporated.  If they are not, then maybe it's time to see how
future changes to these modules can be coordinated.
