From: Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>
Subject: Re: cups slow on linux-2.6.24
Date: Tue, 5 Feb 2008 09:16:29 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802050909220.32232@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0802050913560.6704@boston.corp.fedex.com>
Reply-To: "Mirror of cups.bugs Newsgroup" <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Krzysztof Piotr Oledzki <ole-gcSpNFQc7Gg@public.gmane.org>,
	Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>,
	Netfilter Development Mailinglist <netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, cups-bugs <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
To: Jeff Chua <jeff.chua.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.0802050913560.6704-2K9XAwmnW1wYQUuIRqa960M9+F4ksjoh@public.gmane.org>
List-Unsubscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
Errors-To: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 5 Feb 2008, Jeff Chua wrote:

> On Feb 5, 2008 4:17 AM, Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org> wrote:
> 
> > Actively closed connections are not handled properly, i.e. the initiator of
> > the active close should not be taken into account. So could you give a try
> > to the patch below? Does it just suppress the 'invalid packed ignored' and
> > all other kernel messages or both suppresses them and produces normal
> > printing speed?
> 
> Amazing! You fixed it. No more 'invalid packed ignored', and speed back to
> normal (continues after approx. 20 seconds of pausing after 503 prints).

Great! Thank you for the testing!
 
> I used the latest git, and have to modify your patch slightly to make it work
> (changing "conntrack" to "ct").

Patrick, I suppose you need a patch against the latest git, don't you?

Best regards,
Jozsef
-
E-mail  : kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org, kadlec-tC8PEuNsDRr1hxmkv4H60w@public.gmane.org
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
