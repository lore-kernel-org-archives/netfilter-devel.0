From: Rich Felker <dalias@libc.org>
Subject: Re: [PATCH iptables RFC 4/4] libxt_TCPOPTSTRIP: Use local
 copy of TCPOPTS constants
Date: Tue, 16 Jun 2015 15:28:47 -0400
Message-ID: <20150616192847.GI1173@brightrain.aerifal.cx>
References: <20150616192504.GF3247@euler>
Reply-To: musl@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org, musl@lists.openwall.com
Return-path: <musl-return-7962-gllmg-musl=m.gmane.org@lists.openwall.com>
List-Post: <mailto:musl@lists.openwall.com>
List-Help: <mailto:musl-help@lists.openwall.com>
List-Unsubscribe: <mailto:musl-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:musl-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20150616192504.GF3247@euler>
Sender: Rich Felker <dalias@aerifal.cx>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jun 16, 2015 at 09:25:04PM +0200, Felix Janda wrote:
> musl does not provide these constants in <netinet/tcp.h>
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>
> ---
> It is not clear to me whether these constants belong to iptables or musl's
> netinet/tcp.h. So this message is CC'd to the musl list.
> 
> In the code indexed by debian code search I have only found iptables and
> traceroute using them without having a local copy of tcp.h.
> 
> Note that this patch is incomplete: utils/nfsynproxy.c uses them as well

I'm not sure either. I'd like to hear from someone who has a good
argument one way or the other.

Rich
