From: Jonathan Cooper <netfilter@jonc.me.uk>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Thu, 11 Mar 2004 16:50:37 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040311165037.GA1615@finarfin.cooper.xfnet>
References: <20040311160401.GA1565@finarfin.cooper.xfnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040311160401.GA1565@finarfin.cooper.xfnet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

* Jonathan Cooper <netfilter@jonc.me.uk> [2004-03-11 16:18]:
> Under the 2.4.23 and 2.4.24 kernels my machine would oops on reboot (just
> after killing syslog) after the message had occurred. This has not (yet)
> happened on 2.4.25. One common feature, that has occurred once under
> 2.4.23 and once under 2.4.25 is that after several occurrences of this
> message the computer froze solid, with no keyboard, mouse or network
> response.

Update: only one occurrence of the message is required to trigger a
freeze, it seems, although the freeze occurred some time after the
message. Looks suspiciously like random memory corruption...

> I have experienced no problems of this nature with Debian's 2.4.22
> kernel.

The config of which is now available at
<http://jonc.me.uk/stuff/config-2.4.22>.

Jonathan.

-- 
Jonathan Cooper        MSN: msn@jonc.me.uk        jonc.me.uk/

Health: The slowest possible rate of dying.
