From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ip_pool -x not working.
Date: Thu, 11 Dec 2003 23:58:54 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312112358300.4649-100000@filer.marasystems.com>
References: <3FCF9AE8.3010506@fabricadeideias.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rodrigo Severo <rodrigo@fabricadeideias.com>
In-Reply-To: <3FCF9AE8.3010506@fabricadeideias.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I posted a patch implementing these some week ago. See the archives.

Regards
Henrik

On Thu, 4 Dec 2003, Rodrigo Severo wrote:

> Dear list,
> 
> 
> I am testing the ip pool match and target.
> 
> I'm having problems with the ippool userspace support tool.
> 
> I can't make neither -x nor the -X POOL options work. I always get a 
> "IP_POOL_DESTROY POOL failed: Device or resource busy" message. The POOL 
> isn't used yet anywhere, I'm justing testing pool creation by now.
> 
> Is it a bug or am I doing something wrong?
> 
> I am not sure there is someone working on the ip pool functionality.
> 
> I wrote Patrick Schaaf, the former maintainer of this patch. He told me 
> that he never implemented pool destruction. He also mentioned that 
> Joackim Axelsson probably is the ip pool man presently.
> 
> Is there anybody working on it? I'm willing to help.
> 
> BTW, I'm messing with ip pool based on the assumption that using an ip 
> pool would give me faster results than having circa 180 rules for 
> different ip addresses as I have now. Am I right?
> 
> 
> Thanks in advance for your attention,
> 
> Rodrigo Severo
> 
> 
