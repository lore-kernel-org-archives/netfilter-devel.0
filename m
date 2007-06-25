From: Patrick McHardy <kaber@trash.net>
Subject: Re: [bug+patch] SCTP and chunk types over 0x1f
Date: Mon, 25 Jun 2007 15:40:27 +0200
Message-ID: <467FC5CB.9080608@trash.net>
References: <20070622151940.GA20467@artesyncp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Stephane Chazelas <stephane@artesyncp.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070622151940.GA20467@artesyncp.com>
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

Stephane Chazelas wrote:
> There seems to be several bugs in the iptable and the kernel
> code that prevent the filtering on SCTP chunks of type above 31
> to work.
> 
> Below is a patch for iptables, the corresponding header files
> in the kernel would have to be updated the same way.
> 
> The problems:
> - the values for the ASCONF and ASCONF_ACK types were incorrect
>   (30, 31 instead of 0x80 or 0xC0), I've also added the FTSN
>   chunk (RFC 3758)
> 
> - the chunkmap, which is a bitmap of which chunk is selected is
>   defined as an array of 256 / 4 u32s, that is 256 * 8 bits,
>   256 / 32 is enough (256 bits).


We can't change that since it breaks userspace compatibility.

> - the macros like SCTP_CHUNKMAP_SET_ALL... use
>   ELEMCOUNT/ARRAY_SIZE to loop through the u32s of the chunkmap.
>   But those macros are sometimes called with a u_int32_t*
>   instead of a u_int32_t[8], so that it loops only on the first
>   u32.

Nice catch.

> - bug in print_chunk(), see below.
> 
> both the kernel and iptables need to be updated, at least to
> take into account the new size of the chunkmap. That patch
> doesn't try to be smart wrt to compatibility. It would be nice
> to be able to specify chunk using their numerical value (to take
> into account future SCTP extensions).

Unfortunately this missed the 1.3.8 release since I didn't
notice it before.

Could you please resend without the chunkmap changes? Thanks.
