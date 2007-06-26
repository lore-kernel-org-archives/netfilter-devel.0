From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables: "getsockopt failed strangely"
Date: Tue, 26 Jun 2007 11:27:47 +0200
Message-ID: <4680DC13.2000708@trash.net>
References: <467FE504.6040606@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Joseph Jezak <josejx@gentoo.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467FE504.6040606@gentoo.org>
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

Joseph Jezak wrote:
> Hi,
> 
> On PowerPC, with a binary compiled statically, we're seeing the error
> message in the topic when simply running the iptables binary.
> For more information, the Gentoo bug is available here:
> http://bugs.gentoo.org/show_bug.cgi?id=136813
> 
> Basically, the issue arises from a missing check for the result from the
> module request located in /usr/src/linux/net/ipv4/netfilter/iptables.c
> 
> A patch to add a check for -ENOENT and printing out the missing module
> name then return -EPROTONOSUPPORT instead of -ENOENT is attached and
> "fixes" the bug for me.


Not sure if I understood the report correctly. It states iptables
would return -EPROTONOSUPPORT when requesting the version of a
non-loaded module. Thats not correct since the module will be
loaded previously by do_ipt_get_ctl.

Its possible though that you use an old iptables version, we've
had a bug that corrupted errno with some crap before printing
the error.
