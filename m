From: Paul Wouters <paul@xelerance.com>
Subject: Re: [Openswan dev]
Date: Sat, 14 Jan 2006 06:48:55 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0601140646280.12872@tla.xelerance.com>
References: <1cafb3070601122124l11f06130i@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: dev@openswan.org
Return-path: <dev-bounces@openswan.org>
To: lepton <ytht.net@gmail.com>
In-Reply-To: <1cafb3070601122124l11f06130i@mail.gmail.com>
cc: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <http://lists.openswan.org/mailman/listinfo/dev>,
	<mailto:dev-request@openswan.org?subject=unsubscribe>
List-Archive: <http://lists.openswan.org/pipermail/dev>
List-Post: <mailto:dev@openswan.org>
List-Help: <mailto:dev-request@openswan.org?subject=help>
List-Subscribe: <http://lists.openswan.org/mailman/listinfo/dev>,
	<mailto:dev-request@openswan.org?subject=subscribe>
Sender: dev-bounces@openswan.org
Errors-To: dev-bounces@openswan.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 13 Jan 2006, lepton wrote:

> The following patch will fix this, How do you think about this?
> Thanks
>
> diff -pru linux-2.6.14-orig/include/linux/skbuff.h

I believe 2.6.15 just got Patrick's patches integrated from patch-o-matic
that accomplish the same.

Paul
