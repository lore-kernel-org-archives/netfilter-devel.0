From: Imre Gergely <imre.gergely@astral.ro>
Subject: Re: hashlimit module parameters
Date: Tue, 27 Sep 2005 18:06:59 +0300
Message-ID: <43396013.1060201@astral.ro>
References: <43329209.8040607@astral.ro>
	<20050922215104.GU26520@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050922215104.GU26520@sunbeam.de.gnumonks.org>
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


hi

how does this hashlimit behave above rate 5000/sec ? and how it is
supposed to behave? i tried something like this:

iptables -A limit_udp -p udp -m hashlimit --hashlimit 5000/sec
--hashlimit-mode dstip --hashlimit-name limit_udp -j RETURN;

iptables -A limit_udp -p udp -m limit --limit 1/sec -j LOG
--log-prefix='limit_udp: '

i have some dstip to with traffic is around 500pps, but it still appears
in the logs, that means the second rule matches, while it shouldn't
according to hashlimit 5000/sec.

and another thing. if i try with a rate above 5000 (say 6k, 8k) it
always puts 10k in. why is that?
thx.

config: iptables-1.3.2, kernel 2.6.13, dual Intel Xeon CPU 2.40GHz

(pls reply in private too.)

Harald Welte wrote:
> On Thu, Sep 22, 2005 at 02:14:17PM +0300, Imre Gergely wrote:
> 
>>hi
>>
>>i was wondering about something. i want to use this hashlimit module,
>>and the doc says the --hashlimit parameter is just like the one in the
>>limit match, but when i want to do
>>
>>/usr/local/iptables-1.3.3-20050921/sbin/iptables -A INPUT -s 1.1.1.1 -m
>>hashlimit --hashlimit ! 5/sec --hashlimit-mode srcip --hashlimit-name
>>test -j ACCEPT
>>
>>it gives me an error:
>>
>>iptables v1.3.3-20050921: hashlimit does not support invert
>>Try `iptables -h' or 'iptables --help' for more information.
>>
>>is there a way to specify an invert to this ?
> 
> 
> I don't think so, sorry :(  Seems like I forgot to take care of limit
> inversion.  Patches welcome.
> 
