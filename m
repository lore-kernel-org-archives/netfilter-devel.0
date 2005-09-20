From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: buffer overflow in ip_ct_{ftp,tftp,irc}
Date: Tue, 20 Sep 2005 16:11:57 +0900 (JST)
Message-ID: <200509200711.j8K7Bwif002183@toshiba.co.jp>
References: <431F7B26.4040302@netfilter.org> <431F7C38.50206@netfilter.org>
	<432213E5.4000200@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	sbellabes@mandriva.com, davem@davemloft.net, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <432213E5.4000200@trash.net>
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


From: Patrick McHardy <kaber@trash.net>
Date: Sat, 10 Sep 2005 00:59:49 +0200

> > -static int ports[MAX_PORTS];
> > +static short ports[MAX_PORTS];
> > static int ports_c;
> > -module_param_array(ports,int, &ports_c, 0400);
> > +module_param_array(ports, short, &ports_c, 0400);
> 
> I agree, I've applied this patch instead. Thanks.

Why don't you use u_int16_t and ushort instead of short ?

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
