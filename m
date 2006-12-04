From: Steven Van Acker <deepstar@singularity.be>
Subject: Re: iptables 1.3.6 compilation issues in libipt_iprange.c
	(non-existant __be32 type)
Date: Mon, 4 Dec 2006 17:52:50 +0100
Message-ID: <20061204165250.GA1730@ekonomika.be>
References: <20061204154845.GA21750@ekonomika.be> <45744680.5080702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	kulnet@kulnet.kuleuven.be
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <45744680.5080702@trash.net>
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

On Mon, Dec 04, 2006 at 05:02:08PM +0100, Patrick McHardy wrote:
> I've already uploaded a 1.3.7 release to ftp.netfilter.org to fix this
> issue (please test :), once the webpage has been updated I'll send out
> the announcement.

1.3.7 compiles and works nicely with a 2.6.19 kernel on my system.
Thanks :)

I'm still wondering why <linux/types.h> is not used though. Is it to
avoid complications with older kernels ?

kinds regards,
-- Steven

-- 
My amazon wishlist:
http://www.amazon.com/gp/registry/1DB4XNEIEQBPB
