From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC][PATCH-2.4] fix NF_REPEAT (take 2)
Date: Mon, 27 Oct 2003 10:20:09 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310271015280.26647-100000@blackhole.kfki.hu>
References: <20031025123510.GA2717@pcw.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	<marcelo.tosatti@cyclades.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy TARREAU <willy@w.ods.org>
In-Reply-To: <20031025123510.GA2717@pcw.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Willy,

On Sat, 25 Oct 2003, Willy TARREAU wrote:

> here come two patches to fix the NF_REPEAT bug ; the first one based upon
> your suggestion (your patch was for 2.6), but against ip_conntrack_core.c
> in 2.4, which is the same in standard kernel and tcp_window_tracking, and
> the second one is only targetted at a window_tracking enabled kernel.
>
> I have verified that they fix the reported problem. Could you please check
> them so that Marcelo can merge it before 2.4.23-final ?

The patches are all right. I'll create p-o-m patches from them and then
Harald can submit the first part for kernel inclusion. (I'd like a TCP
window tracking patch completed with the other pending fixes issued at the
same time.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
