From: Roberto Nibali <ratz@tac.ch>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Mon, 04 Jul 2005 10:20:33 +0200
Message-ID: <42C8F151.9080708@tac.ch>
References: <42C2C053.3040707@tac.ch>
	<20050629154049.GA17717@oknodo.bof.de>	<20050629160923.GF3331@eychenne.org>	<20050703123650.GW3186@sunbeam.de.gnumonks.org>	<20050703220525.GA3331@eychenne.org>
	<20050704055541.GA29624@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Herve Eychenne <rv@wallfire.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050704055541.GA29624@oknodo.bof.de>
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

>>Trying to insert potentially many LOG rules to empirically determine
>>the maximum prefix length is far less complex, that's for sure. ;-)
> 
> Do we already have indeterminate log prefix length? I thought we had
> one, fixed size, no probing neccessary. Am I wrong?

No, it's fix. And "probing" can easily be done with a large sized prefix,
although I'm a bit astonished as to why someone wouldn't know the prefix size
when loading the packet filter ruleset.

>>For now, that's the only way an upper-level tool will produce valid
>>LOG rules in all cases.
>  
> The way to produce valid log rules in all cases, is to keep this
> fancy long long stuff in user level, and set pointer / index values
> or whatever small token can be used, for a log prefix in the kernel.

This does not work in environments where you need high speed logging since
having a pointer, or hashmap value, would require an intermediate process to
translate it into parsable strings again. This is from an architectural point of
view and from a performance point of view not possible, at least not in our
environment.

> Any scheme which probes the possible length, will also need some
> fallback when kernel length is smaller than user desire. If your
> goal is 'valid in all cases'. Right? Then you'll need such a
> token/pointer approach anyway!

The fallback is as it always was, exit with return value 2. Nothing changes. The
token/pointer approach is not something the netfilter architecture can provide
for you. That's something each packet filter software would have to provide by
itself. Example:

# A filter rule could expand into a ruleset where on of the rules could be
iptables -t filter -A INPUT -j LOG -i eth0 --log-level info --log-prefix
'ptr_666' -p icmp --icmp-type 8 -s 172.23.120.30/32 -d 172.23.120.120 -m state
--state NEW

# The ptr_666 is a pointer which can be translated again into human readable
# or log parsable strings.
ptr_666="pf rule set, ABI/55: icmp_from_fw [666] a:ACCEPT s:NEW f:INPUT TRACK
sub referenced as group"

>>Maybe you don't like /proc, but the kernel still has to provide a way
>>to inform userspace about the fixed size of some of its data (as
>>kernelspace doesn't like dynamic things very much...). If you see a
>>better way, that's ok, but the need is still there.
>  
> If getsockopt is good to communicate iptables rules and other stuff,
> it must be good enough to also communicate 'length of X is Y'...

Well, good enough is a relative term :), but the netfilter core team is working
extra hours on the netlink integration which could help a lot in this
perspective. It would be a lot more fun to get the connection tracking table
filled with thousands of entries in less than 2 Minutes, so the monitoring
system does not have so many spikes. Customers often ask if the system is
malfunctioning or down every 5-15 Minutes :).

Regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
