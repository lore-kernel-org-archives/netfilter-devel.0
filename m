From: Amin Azez <azez@ufomechanic.net>
Subject: Re: connbytes & 64bit counters
Date: Wed, 01 Nov 2006 15:08:48 +0000
Message-ID: <4548B880.1090107@ufomechanic.net>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>	<453FE325.1040502@trash.net>	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
	<45462043.5010207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45462043.5010207@trash.net>
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

* Patrick McHardy wrote, On 30/10/06 15:54:
> We can't make the API depend on config options (and I don't
> like all those ifdefs). For now I would suggest to keep the
> ctnetlink interface as it is and use 64 bit counters either
> unconditionally or only when the connbytes match is enabled.

I like: unconditionally.
In my experience we can save more kernel space by reducing the default
conntrack timeout than by reducing counter size.

Sam
(who remembered to remove the gmane newsgroup to avoid posting twice)
