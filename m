From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Suggestion for RETURN target
Date: Thu, 4 Dec 2003 22:02:07 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312042157310.26536-100000@filer.marasystems.com>
References: <3FCF875C.FDCAB795@info-link.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Brad Fisher <brad@info-link.net>
In-Reply-To: <3FCF875C.FDCAB795@info-link.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 4 Dec 2003, Brad Fisher wrote:

> I have tested your patch, and it seems to work well.  Attached you will find a modified
> version which patches iptables-save, and iptables -L.  It seems a little funny to me to
> add the IPT_F_GOTO flag into the ip flags, but it makes sense to make use of the unused
> space.  I would think it would make more logical sense to have it attached to the target
> structure, but that would break binary compatibility, which I think is important to
> preserve.

Well.. it is not really a target but part of the iptables core so the flag
is fine I think. And not breaking binary compatibility is very desireable 
for a change like this.

On the down side the kernel does not verify the flag fields content, so it 
is possible to use a new binary on a old kernel and it will still accept 
goto rules but will process them like ordinary jumps. This might not be 
all desireable but a acceptable compromise I think.

> I apppreciate the time you put into it and hope that it at least gets
> included in patch-o-matic :)

I would certainly not mind have it included.

As noted in my message I tried to make the userspace changes in such way 
that it is source compatible with kernel includes both with and without 
the changed iptables includes, but requires the updated headers to enable 
the goto flag

Regards
Henrik
