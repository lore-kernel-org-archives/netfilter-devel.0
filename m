From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: pending/69_amanda-helpers.patch does not apply to 2.4.22?
Date: Sun, 12 Oct 2003 12:52:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1065955978.29179.67.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0310112315200.14720-100000@filer.marasystems.com>
	 <1065913241.29186.4.camel@tux.rsn.bth.se>  <3F88C9AB.5010306@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F88C9AB.5010306@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2003-10-12 at 05:25, Patrick McHardy wrote:

> >Patrick, do you think you could fix it up?
> >
> 
> This should do it.

Almost, I still have a reject in ip_nat_amanda.c

-- 
/Martin
