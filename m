From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] iptables namespaces
Date: Sat, 8 Sep 2007 09:26:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709080924090.25942@fbirervta.pbzchgretzou.qr>
References: <20070907180204.GA460@ekonomika.be>
	<20070907184642.GA4728@outback.rfc2324.org>
	<20070907190601.GA18714@ekonomika.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070907190601.GA18714@ekonomika.be>
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


On Sep 7 2007 19:06, Steven Van Acker wrote:
>> > The result is that for 1 minute, some traffic can get through the firewall rules
>> > while other can not. We have had problems with spam getting through to 
>> > mailservers behind the firewall, because not all firewall rules were loaded.
>> 
>> That problem can be solved.
>> man iptables-restore
>
>iptables-restore takes a file as input, not a series of iptables
>commands.

Yes, it takes a file. And if you looked at it, yes, it takes iptables
commands! (besides the table and counter markers)

>This means I would have to edit the file manually, not
>something I want to do with 7000 firewall rules.

Where is the difference between...

	iptables -A INPUT -m foobar -j FOOBAR

and adding

	-A INPUT -m foobar -j FOOBAR

to the

	*filter

section? (Otherwise, write a script, as suggested, or use a GUI ;-)



	Jan
-- 
