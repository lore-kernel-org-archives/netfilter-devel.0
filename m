From: "Grzegorz Nosek" <blackfire@metal.art.pl>
Subject: Re: MARK target extension
Date: Sun, 6 Jun 2004 00:06:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040605205623.M81946@metal.art.pl>
References: <20040526205915.M56972@metal.art.pl> <40B5BA84.5040601@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-2
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <40B5BA84.5040601@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 May 2004 11:53:08 +0200, Patrick McHardy wrote
> We already have a similar patch, MARK-operations, in pom-ng.
> Unfortunately it can't be included in the stable series because
> it breaks userspace compatibility.
> 
> Regards
> Patrick
> 

I had a look at the patch and it's indeed similar but supports only
single AND and OR operations and I think that it should allow more
flexibility. If you don't like the idea of adding another parameter,
maybe something like this would do:
--set-mark overrides all, without further questions
--and-mark and --or-mark are performed in sequence (thus more than one
allowed), so that (in my proposed syntax)
    --set-mark 0x1234 --mask 0xffff
(leaving top 16 bits untouched) could be expressed as
    --and-mark 0xffff0000 --or-mark 0x1234
It shouldn't break any existing applications either (they're using
only one of the parameters now).

It certainly is possible to get the same result using two consecutive
rules but it seems inefficient.

Regards,
 Greg
