From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]Re: NAT before IPsec with 2.6
Date: Fri, 20 Feb 2004 02:43:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40356624.6050209@trash.net>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 Henrik Nordstrom <hno@marasystems.com>,
 Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20040218220337.GA3193@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Willy,

Willy Tarreau wrote:
> 
> Judging by the fact that I saw no reply to your previous mail,
> I suspect that we all are a bit busy. Regarding your previous
> question about a possible asymetry, I was starting to draw a
> flow diagram to check what I understood correctly and that
> we could use as a base to comment on, but I finally didn't have
> time to work on it anymore. In fact, I see how a packet passes
> through the tables and chains without ipsec, I have a few doubts
> about what changes with ipsec and your patches (eg: I don't
> remember if the decapsulated packet goes through mgl:PRE or not),
> and I'm yet less certain about what is known about the sessions
> at different stages. If I find time to come up with a diagram
> (even if it's plain wrong), I'll post it here.

Thanks a lot! Decapsulated packets go the usual way, in fact the
patch doesn't change anything for tunnel mode except that
it drops the conntrack reference before packets are posted into
the stack again. For transport mode packets it's a bit different,
and I too am not entirely sure if the packet is always in valid
state with the emulate_nf_hooks stuff, especially when
NAT-Traversal is used. I'm investigating this after I fix a
bug Michal and a second tester reported. Regarding hooks passed,
packets SNATed in POST_ROUTING which have a matching policy
afterwards won't pass the SELINUX and CONNTRACK hooks.
The mangle table may also cause problems when something causes
rerouting, I haven't thought about the possible effects yet.
Other than that I can currently not think of more problems ..

Best regards,
Patrick

> 
> Cheers,
> Willy
> 
