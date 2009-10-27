From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: xt_ACCOUNT and big endian machines
Date: Tue, 27 Oct 2009 11:49:10 +0100
Message-ID: <200910271149.10969.thomas.jarosch@intra2net.com>
References: <200910231623.42725.thomas.jarosch@intra2net.com> <200910261003.01234.thomas.jarosch@intra2net.com> <alpine.LSU.2.00.0910271038170.13188@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:60738 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZJ0KtJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2009 06:49:09 -0400
In-Reply-To: <alpine.LSU.2.00.0910271038170.13188@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Jan,

On Tuesday, 27. October 2009 11:04:38 Jan Engelhardt wrote:
> On Monday 2009-10-26 10:03, Thomas Jarosch wrote:
> >On Friday, 23. October 2009 17:48:04 you wrote:
> >> >I'm wondering if this is the best approach to support big endian
> >> > machines with all those #ifdefs?
> >>
> >> The second is ok, though I dunno why he did not chose to do the
> >> same in the first. Hence:
> >
> >Thanks for the fix! What about the left shift operations f.e. in
> >ipt_acc_handle_get_data()? The original patch touched those, too.
> 
> Adding this in.

Thanks! See one little remark below.

> @@ -817,7 +817,7 @@ static int ipt_acc_handle_get_data(uint32_t handle,
>  void *to_user) struct ipt_acc_mask_24 *network =
>  					network_16->mask_24[b];
>  				if (ipt_acc_handle_copy_data(to_user, &to_user_pos,
> -				    &tmpbuf_pos, network, net_ip, (b << 16)))
> +				    &tmpbuf_pos, network, ntohl(net_ip), (b << 16)))
>  					return -1;
>  			}
>  		}

I'm starting to get my mind ready for endian issues :)
The "net_OR_mask" is in host order if I understood it correctly,
so shouldn't this read "(b << 8)"?

Cheers,
Thomas
