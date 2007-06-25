From: Stephane Chazelas <stephane@artesyncp.com>
Subject: Re: [bug+patch] SCTP and chunk types over 0x1f
Date: Mon, 25 Jun 2007 15:08:39 +0100
Message-ID: <20070625140839.GW20467@artesyncp.com>
References: <20070622151940.GA20467@artesyncp.com> <467FC5CB.9080608@trash.net>
	<20070625135040.GV20467@artesyncp.com> <467FCA13.5050401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <467FCA13.5050401@trash.net>
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

On Mon, Jun 25, 2007 at 03:58:43PM +0200, Patrick McHardy wrote:
[...]
> > That's just a matter of removing the first change:
> 
> 
> Does it stay completely compatible (modulo fixed bugs) then?

AFAICT, yes (though I've not tested it). I don't know if the
kernel needs to be rebuilt for the bug to be fixed (that is, I
don't know whether in the kernel code there are some calls to
the SCTP_CHUNKMAP_IS_ALL_SET and cie macros with non-array
arguments, I don't think there are).

I've changed:

-#define bytes(type) (sizeof(type) * 8)
-
-		chunkmap[type / bytes(u_int32_t)] |= 	\
-			1 << (type % bytes(u_int32_t));	\

to:

+		chunkmap[type / 32] |= 	\
+			1 << (type % 32);	\

Because, I think by definition a u_int32_t has 32 bits while
sizeof() is not meant to return the number of 8bit units (though
it probably does on all the architectures supported by Linux).

In practice, it shouldn't make any difference.

Best regards,
Stephane
