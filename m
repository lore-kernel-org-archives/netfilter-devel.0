From: Fabrice MARIE <fabrice-marie-sec@ifrance.com>
Subject: Re: German translation of the netfilter-extension-HOWTO
Date: Thu, 10 Oct 2002 19:10:56 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200210101910.56677.fabrice-marie-sec@ifrance.com>
References: <20021010105020.GA26751@mail.maxrelax.de>
Reply-To: fabrice-marie-sec@ifrance.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Knop <tknop@maxrelax.de>, netfilter-devel@lists.netfilter.org
In-Reply-To: <20021010105020.GA26751@mail.maxrelax.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello Thomas,

On Thursday 10 October 2002 18:50, Thomas Knop wrote:
> Dear netfilter developers,
> i am glad to present you today a german translation of the
> netfilter-extension-HOWTO. Hopefully you will publish it on your famous
> webpage.

Thanks for your translation work. Much appreciated :)

> length Patch:
> Ther is a +/- 1 error. If we want to drop all the pings with a packet size
> *greater* than 85 bytes and ranges are inclusive, the roule must be:
> iptables -A INPUT -p icmp --icmp-type echo-request -m length --length
> 86:65535 -j DROP
> [..]

Thanks I modified the original document to fix the problem the way you mentioned.

BTW, did you forget to attach your patch or URL ? You haven't told us where to
find your document for inclusion :)

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown
