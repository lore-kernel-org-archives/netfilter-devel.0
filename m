From: "Retesh Chadha" <retesh.chadha@gmail.com>
Subject: Re: Parsing ULOG message received on netlink socket
Date: Thu, 5 Oct 2006 12:41:16 +0530
Message-ID: <b322db070610050011v457fd0e2ie3e88d71504653c6@mail.gmail.com>
References: <b322db070609272111o4e0b097cw9ee64dc4614810dc@mail.gmail.com>
	<451D225B.6030908@trash.net>
	<1159538859.451d28ac01159@www.domainfactory-webmail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Maik Hentsche" <netfilter@mm-double.de>
In-Reply-To: <1159538859.451d28ac01159@www.domainfactory-webmail.de>
Content-Disposition: inline
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

Hi
I am able to parse the ULOG message (raw buffer) by skipping the
netlink header and a few more bytes(fixed size around - 160 bytes) to
get the IP header. This works for me for UDP, ICMP and TCP.

Rgds
Retesh

On 9/29/06, Maik Hentsche <netfilter@mm-double.de> wrote:
> Zitat von Patrick McHardy <kaber@trash.net>:
>
> > Check out ulogd or nfnetlink_log and libnfnetlink.
>
> ulogd seems to be abandoned, so specter
> (http://joker.linuxstuff.pl/specter/) might be the better advice. Both
> specter and ulogd already have plugins for parsing the raw data. Having
> written an output plugin (to log into prelude) for both I feel this is
> easier for specter because of the better defined structure of the
> passed values. If Retesh ever feels, his (or her? can't tell from the
> name, sorry) work should become open source, the chance to get a new
> plugin into specter seems to be far better then getting one into ulogd
> since the author of the former does answer mails and the author of the
> later does not.
>
> Just my 2 =A2.
>
> so long
> Maik
>
>
