From: Patrick McHardy <kaber@trash.net>
Subject: Re: MARK target extension
Date: Thu, 27 May 2004 11:53:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B5BA84.5040601@trash.net>
References: <20040526205915.M56972@metal.art.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Grzegorz Nosek <blackfire@metal.art.pl>
In-Reply-To: <20040526205915.M56972@metal.art.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Grzegorz Nosek wrote:
> Hello all!
> 
> I've extended the MARK target (ipv4 only currently) to allow partial
> modification of nfmark values instead of replacing. As in:
> 
> ... -j MARK --set-mark 0x80
> ... -j MARK --set-mark 0x8000 --mask 0xff00
> 
> sets the resulting mark value to 0x8080. Note that it isn't a logical OR:
> 
> ... -j MARK --set-mark 0xffff
> ... -j MARK --set-mark 0 --mask 0xff
> 
> would change the mark to 0xff00.
> 
> This way you can use the nfmark as a bit field (testing individual
> bits can be done already). Patches included are based on
> iptables-1.2.9 (from debian sarge source) and kernel 2.4.26, somewhat
> patched (nothing related to nfmark, though, so it should apply cleanly
> to a vanilla kernel too). What do you think? IMNSHO it would be useful
> to include in standard kernel/iptables especially as it breaks no
> existing applications (default mask is 0xffffffff), is no code bloat
> and might actually be useful to somebody besides me. Note that it's my
> first public kernel patch so be gentle.

We already have a similar patch, MARK-operations, in pom-ng.
Unfortunately it can't be included in the stable series because
it breaks userspace compatibility.

Regards
Patrick

> 
> Regards,
>  Greg
