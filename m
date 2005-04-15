From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [patch] Fix ipt_ACCOUNT for large networks - 2nd try
Date: Fri, 15 Apr 2005 10:29:39 +0200
Message-ID: <200504151029.39597.thomas.jarosch@intra2net.com>
References: <200504050948.51387.thomas.jarosch@intra2net.com>
	<425F0053.2050302@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <425F0053.2050302@gmx.net>
Content-Disposition: inline
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

> > +static int ipt_acc_handle_copy_data(void *to_user, u_int32_t
> > *to_user_pos, +                                  u_int32_t *tmpbuf_pos,
> >                                      struct ipt_acc_mask_24 *data,
> >                                      u_int32_t net_ip, u_int32_t
> > net_OR_mask) {
>
> You seem to like u_int32_t as a type. That causes interesting behaviour
> on 64bit machines. Is there any design objective dictating that?
> I have a patch available changing most occurences of u_int32_t to
> something more generic (of course not for IPs, netmasks and such) which
> may make sense if you ever want to use your module on 64bit machines.

Yep, I think for pointers this change is necessary on 64bit platforms.
Please base your patch on the locking patch I just sent.

Thomas
