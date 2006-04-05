From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip_conntrack section mismatch warning fix
Date: Wed, 05 Apr 2006 17:28:24 +0200
Message-ID: <4433E218.3060100@trash.net>
References: <20060404113233.4de507d3@dxpl.pdx.osdl.net>
	<4433D496.2090706@trash.net>
	<20060405152306.GG20558@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Stephen Hemminger <shemminger@osdl.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060405152306.GG20558@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Wed, Apr 05, 2006 at 04:30:46PM +0200, Patrick McHardy wrote:
> 
>>I think this might still fail without forced inlining. Our init
>>functions look like crap anyway, and the reason mostly seems to
>>be mass-registration of hooks, so I guess I'll clean that up
>>with a small helper function and then just split them.
> 
> 
> still I actually think of the shared init/cleanup functions as a big
> feature rather than something that needs to be 'cleaned up'.  

I think they make the cleanup code quite unreadable because the
heavy mix with labels. I'm already half way through and the
seperated cleanup functions really are a lot more readable.
Besides that the split also allows to throw the init part away
after initializing, so it makes the binary smaller.
