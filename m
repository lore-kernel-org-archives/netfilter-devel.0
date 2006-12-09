From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [ANNOUNCE] Release of iptables-1.3.7
Date: Sat, 09 Dec 2006 09:12:49 +0000
Message-ID: <457A7E11.4060200@ufomechanic.net>
References: <45769244.3060508@netfilter.org>
	<200612071235.kB7CZ89c016474@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200612071235.kB7CZ89c016474@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Hi,
>
> DO_MULTI=1 causes build error because iptables-xml.c has same symbols
> in ip[6]tables.c.
>   
Thanks for the patch
> BTW, why we need to combine iptables-xml with other commands ? It doesn't
> use any feature in ip[6]tables then binary size wouldn't be smaller
> so much. Or anyone has plan to implement XML style output to
> matches/targets ?
>   
I do. I'll give it a little longer for anyone to feedback on the xml format.

Sam
