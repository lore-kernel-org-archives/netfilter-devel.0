From: "Jeff Chua" <jeff.chua.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cups slow on linux-2.6.24
Date: Tue, 29 Jan 2008 07:55:59 +0800
Message-ID: <b6a2187b0801281555w479ae9b5pa1c3b05cffe2f9f4@mail.gmail.com>
References: <Pine.LNX.4.64.0801290635001.23096@boston.corp.fedex.com>
	<Pine.LNX.4.64.0801282348440.30640@bizon.gios.gov.pl>
Reply-To: "Mirror of cups.bugs Newsgroup" <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jozsef Kadlecsik <kadlec-K40Dz/62t/MgiyqX0sVFJYdd74u8MsAO@public.gmane.org>,
	Patrick McHardy <kaber-dcUjhNyLwpNeoWH0uzbU5w@public.gmane.org>, cups-bugs <cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
To: "Krzysztof Oledzki" <ole-gcSpNFQc7Gg@public.gmane.org>
Return-path: <cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.0801282348440.30640-2hlNpRK6mjE3b3fIMdp3XWZHpeb/A1Y/@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=unsubscribe>
List-Post: <mailto:cups-bugs-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org>
List-Help: <mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=help>
List-Subscribe: <http://lists.easysw.com/mailman/listinfo/cups-bugs>,
	<mailto:cups-bugs-request-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org?subject=subscribe>
Sender: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
Errors-To: cups-bugs-bounces-B9D8k9nSxTHQT0dZR+AlfA@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

2008/1/29 Krzysztof Oledzki <ole-gcSpNFQc7Gg@public.gmane.org>:

> Strange. You stated that 2.6.23.12 is OK, however above patch
> was included in 2.6.23.4:
> Are you 100% sure that 2.6.23.12 is OK?

Sorry, my mistake. I had another system on 2.6.23.12 and was not OK,
so I bisected starting from 2.6.23.

git bisect good bbf25010f1a6b761914430f5fca081ec8c7accd1        # 2.6.23

So, 2.6.23.12 is not ok.

Thanks for pointing this out.

Jeff.
