From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] ipt_osf: fix ipt_osf compilation on some distros.
Date: Sun, 27 Feb 2005 20:10:20 +0300
Message-ID: <20050227201020.289d1cbe@zanzibar.2ka.mipt.ru>
References: <1109308057.6728.54.camel@uganda>
	<4221F609.3060305@trash.net>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4221F609.3060305@trash.net>
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

On Sun, 27 Feb 2005 17:32:09 +0100
Patrick McHardy <kaber@trash.net> wrote:

> Evgeniy Polyakov wrote:
> > Some distros have magical header mess, which leads to undefined struct
> > tcphdr, 
> > when net/tcp.h is not included directly.
> > Following patch workarounds it.
> 
> You should include linux/tcp.h for struct tcphdr. You probably also
> don't need the other net/ includes, for struct iphdr use linux/ip.h,
> sock.h shouldn't be needed at all.

net/ip.h is needed due to IP_DF bit.
linux/sock.h is not needed but instead ipt_osf.c requires inetdevice.h
due to in_dev_get() usage.

> > 
> > P.S. Should I resend lost patch with Subject line 
> > "[1/1] libipt_osf: fix iptables-1.3.0rc1 compilation.", which moves
> > kernel headers in ipt_osf.h into appropriate ifdef/endif?
> 
> Yes, please.

Both patches will be sent in 2 next e-mails.
 
> Regards
> Patrick


	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
