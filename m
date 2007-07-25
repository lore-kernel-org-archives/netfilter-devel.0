From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: 2.6.23-rc1: ipv4_get_l4proto: Frag of proto 17
Date: Wed, 25 Jul 2007 19:13:13 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0707251912150.31124@wlug.westbo.se>
References: <56054.81.207.0.53.1185319467.squirrel@secure.samage.net>
	<46A76A0E.8050100@trash.net>
	<44953.81.207.0.53.1185379973.squirrel@secure.samage.net>
	<46A7778C.2040609@trash.net>
	<35590.81.207.0.53.1185382934.squirrel@secure.samage.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Indan Zupancic <indan@nul.nu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <35590.81.207.0.53.1185382934.squirrel@secure.samage.net>
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

On Wed, 25 Jul 2007, Indan Zupancic wrote:

>> Thanks. One more question: are you running nfs?
>
> Yes, but only for the host, I'm not using it locally. And it's v3, so should be
> using TCP. (rpc.mountd --no-nfs-version 1 --no-nfs-version 2.)

I think it still uses UDP as default unless you specify tcp as a mount 
option.

/Martin
