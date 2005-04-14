From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2005@gmx.net>
Subject: Re: [patch] Fix ipt_ACCOUNT for large networks - 2nd try
Date: Fri, 15 Apr 2005 01:44:19 +0200
Message-ID: <425F0053.2050302@gmx.net>
References: <200504050948.51387.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
In-Reply-To: <200504050948.51387.thomas.jarosch@intra2net.com>
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

Thomas Jarosch schrieb:
> Hi Patrick,
> 
> attached is a patch to fix the ACCOUNT target for large networks.
> This time for good ;-) Discard the patch I sent yesterday.
> 
> It runs stable now on a network with ~1300 active clients. Quoting the user:
> "Nevertheless, from performance point of view, ipt_ACCOUNT rocks. I have a
> distribution for routers (Route Hat) and last night switched from ipt_account
> to ipt_ACCOUNT completely. What took half a minute before now takes 300ms
> i.e. 100 times faster, same router, same net. Gr8 work :-)"
> 
> Cheers,
> Thomas
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
> 
> diff -u -r -b ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c ACCOUNT.1.4/linux/net/ipv4/netfilter/ipt_ACCOUNT.c
> --- ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c      2004-06-13 22:41:21.000000000 +0200
> +++ ACCOUNT.1.4/linux/net/ipv4/netfilter/ipt_ACCOUNT.c  2005-04-05 09:33:52.000000000 +0200
> @@ -694,7 +694,8 @@
>  /* Copy 8 bit network data into a prepared buffer.
>     We only copy entries != 0 to increase performance.
>  */
> -static int ipt_acc_handle_copy_data(void *to_user, int *pos,
> +static int ipt_acc_handle_copy_data(void *to_user, u_int32_t *to_user_pos,
> +                                  u_int32_t *tmpbuf_pos,
>                                      struct ipt_acc_mask_24 *data,
>                                      u_int32_t net_ip, u_int32_t net_OR_mask)
>  {

You seem to like u_int32_t as a type. That causes interesting behaviour
on 64bit machines. Is there any design objective dictating that?
I have a patch available changing most occurences of u_int32_t to
something more generic (of course not for IPs, netmasks and such) which
may make sense if you ever want to use your module on 64bit machines.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
