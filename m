From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: Re: [NETFILTER]: H.323 helper: fix parser error propagation
Date: Tue, 23 May 2006 00:31:42 -0400
Message-ID: <BAY109-DAV1160F4A122ECD3188B56E2B39B0@phx.gbl>
References: <44719682.4000907@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="ISO-8859-15";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>,
	"Jing Min Zhao" <zhaojingmin@users.sourceforge.net>
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

Patrick,

I reviewed this patch, it's correct. Thank you for your time and please 
apply it.

Jing Min Zhao


----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Jing Min Zhao" <zhaojingmin@users.sourceforge.net>
Cc: "Netfilter Development Mailinglist" 
<netfilter-devel@lists.netfilter.org>
Sent: Monday, May 22, 2006 6:46 AM
Subject: [NETFILTER]: H.323 helper: fix parser error propagation


>I found the reason for the last crash caused by the PROTOS
> testsuite, turns out to be annoyingly simple for the amount
> of time I needed to find it.
>
> Please review these two patches, we need to get this fixed
> before 2.6.17.
>
>


--------------------------------------------------------------------------------


> [NETFILTER]: H.323 helper: fix parser error propagation
>
> The condition "> H323_ERROR_STOP" can never be true since H323_ERROR_STOP
> is positive and is the highest possible return code, while real errors are
> negative, fix the checks. Also check only abort on real errors in some
> spots that were just interpreting any return value != 0 as error.
>
> Fixes crashes caused by use of stale data after a parsing error occured:
>
> BUG: unable to handle kernel paging request at virtual address bfffffff
> printing eip:
> c01aa0f8
> *pde = 1a801067
> *pte = 00000000
> Oops: 0000 [#1]
> PREEMPT
> Modules linked in: ip_nat_h323 ip_conntrack_h323 nfsd exportfs sch_sfq 
> sch_red cls_fw sch_hfsc xt_length ipt_owner xt_MARK iptable_mangle nfs 
> lockd sunrpc pppoe pppoxx
> CPU:    0
> EIP:    0060:[<c01aa0f8>]    Not tainted VLI
> EFLAGS: 00210646   (2.6.17-rc4 #8)
> EIP is at memmove+0x19/0x22
> eax: d77264e9   ebx: d77264e9   ecx: e88d9b17   edx: d77264e9
> esi: bfffffff   edi: bfffffff   ebp: de6a7680   esp: c0349db8
> ds: 007b   es: 007b   ss: 0068
> Process asterisk (pid: 3765, threadinfo=c0349000 task=da068540)
> Stack: <0>00000006 c0349e5e d77264e3 e09a2b4e e09a38a0 d7726052 d7726124 
> 00000491
>       00000006 00000006 00000006 00000491 de6a7680 d772601e d7726032 
> c0349f74
>       e09a2dc2 00000006 c0349e5e 00000006 00000000 d76dda28 00000491 
> c0349f74
> Call Trace:
> [<e09a2b4e>] mangle_contents+0x62/0xfe [ip_nat]
> [<e09a2dc2>] ip_nat_mangle_tcp_packet+0xa1/0x191 [ip_nat]
> [<e0a2712d>] set_addr+0x74/0x14c [ip_nat_h323]
> [<e0ad531e>] process_setup+0x11b/0x29e [ip_conntrack_h323]
> [<e0ad534f>] process_setup+0x14c/0x29e [ip_conntrack_h323]
> [<e0ad57bd>] process_q931+0x3c/0x142 [ip_conntrack_h323]
> [<e0ad5dff>] q931_help+0xe0/0x144 [ip_conntrack_h323]
> ...
>
> Found by the PROTOS c07-h2250v4 testsuite.
>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
>
> ---
> commit 27ce42efc29f421d4238c426769f057dd384bd14
> tree 451c3d3d9b1b2803bf74fe02423372a3afc5f26b
> parent f1adad78dd2fc8edaa513e0bde92b4c64340245c
> author Patrick McHardy <kaber@trash.net> Mon, 22 May 2006 12:33:36 +0200
> committer Patrick McHardy <kaber@trash.net> Mon, 22 May 2006 12:33:36 
> +0200
>
> net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c |   32 
> +++++++++++---------
> 1 files changed, 18 insertions(+), 14 deletions(-)
>
> diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c 
> b/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c
> index 355a53a..5f4d114 100644
> --- a/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c
> +++ b/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c
> @@ -528,14 +528,15 @@ int decode_seq(bitstr_t * bs, field_t *
>
>  /* Decode */
>  if ((err = (Decoders[son->type]) (bs, son, base,
> -   level + 1)) >
> -     H323_ERROR_STOP)
> +   level + 1)) <
> +     H323_ERROR_NONE)
>  return err;
>
>  bs->cur = beg + len;
>  bs->bit = 0;
>  } else if ((err = (Decoders[son->type]) (bs, son, base,
> - level + 1)))
> + level + 1)) <
> +    H323_ERROR_NONE)
>  return err;
>  }
>
> @@ -584,8 +585,8 @@ int decode_seq(bitstr_t * bs, field_t *
>  beg = bs->cur;
>
>  if ((err = (Decoders[son->type]) (bs, son, base,
> -   level + 1)) >
> -     H323_ERROR_STOP)
> +   level + 1)) <
> +     H323_ERROR_NONE)
>  return err;
>
>  bs->cur = beg + len;
> @@ -660,17 +661,19 @@ int decode_seqof(bitstr_t * bs, field_t
>    i <
>    effective_count ?
>    base : NULL,
> -   level + 1)) >
> -     H323_ERROR_STOP)
> +   level + 1)) <
> +     H323_ERROR_NONE)
>  return err;
>
>  bs->cur = beg + len;
>  bs->bit = 0;
>  } else
> -     if ((err = (Decoders[son->type]) (bs, son,
> -       i < effective_count ?
> -       base : NULL,
> -       level + 1)))
> + if ((err = (Decoders[son->type]) (bs, son,
> +   i <
> +   effective_count ?
> +   base : NULL,
> +   level + 1)) <
> +     H323_ERROR_NONE)
>  return err;
>
>  if (base)
> @@ -735,13 +738,14 @@ int decode_choice(bitstr_t * bs, field_t
>  }
>  beg = bs->cur;
>
> - if ((err = (Decoders[son->type]) (bs, son, base, level + 1)) >
> -     H323_ERROR_STOP)
> + if ((err = (Decoders[son->type]) (bs, son, base, level + 1)) <
> +     H323_ERROR_NONE)
>  return err;
>
>  bs->cur = beg + len;
>  bs->bit = 0;
> - } else if ((err = (Decoders[son->type]) (bs, son, base, level + 1)))
> + } else if ((err = (Decoders[son->type]) (bs, son, base, level + 1)) <
> +    H323_ERROR_NONE)
>  return err;
>
>  return H323_ERROR_NONE;
> 
