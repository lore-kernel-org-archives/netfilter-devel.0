From: Cory Visi <merlin@gentoo.org>
Subject: Re: patchlets patch submission
Date: Mon, 12 Sep 2005 16:41:27 +0000
Message-ID: <20050912164127.GC15843@toucan.gentoo.org>
References: <20050912162938.GB15843@toucan.gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20050912162938.GB15843@toucan.gentoo.org>
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

Please ignore the trailing MPLS work in this patch. It's not relevant to 
this list and I did not mean to include it.

Thanks,
Cory

On Mon, Sep 12, 2005 at 04:29:38PM +0000, Cory Visi wrote:
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
> - pptp (only the conntrack part)
> - nat-hook symbols missing in quake3 and talk conntrack
> 
> I made some attempt at both of these, but I'm not sure how well I did. You 
> should obviously check my work.
> 
> I'm willing to do more, so just let me know what I can do and how I did so 
> far.
> 
> Thanks,
> Cory
