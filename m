From: Patrick Schaaf <bof@bof.de>
Subject: Re: Iptables - disable statefull inspection?
Date: Mon, 16 Dec 2002 12:23:51 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021216112351.GA24258@oknodo.bof.de>
References: <000001c2a1cf$55f818a0$2864a8c0@pcjka>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jan Kaastrup <jka@protego.dk>
Content-Disposition: inline
In-Reply-To: <000001c2a1cf$55f818a0$2864a8c0@pcjka>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I want to disable the connections in ip_conntrack, because it completely
> kills the CPU because ip_conntrack reach Maximum connection.

That's simple: answer 'N' to the relevant kernel questions, then build and
boot that kernel. Without ip_conntrack compiled, it will certainly not
interfere with your testing.

If you already did build ip_conntrack as a module, remove the ip_conntrack.o
file under /lib/modules/`uname -r`, and reboot. The system will then not
be able to load ip_conntrack, and consequently fail loading of all components
which rely on ip_conntrack's presence (nat table, state match).

Easy, isn't it? The hard part comes when you want to load-test some
component (like NAT) which does require ip_conntrack...

best regards
  Patrick
