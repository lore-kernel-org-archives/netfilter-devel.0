From: Stephen Lee <mukansai@emailplus.org>
Subject: Re: iptables/extensions/libipt_time.c missing include
Date: Wed, 28 Jan 2004 03:13:53 +0900
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040128031228.0625.MUKANSAI@emailplus.org>
References: <20040123095234.GA4595@wavehammer.waldi.eu.org> <20040127105745.GG11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Stephen Lee <mukansai@emailplus.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040127105745.GG11761@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte <laforge@netfilter.org> wrote:
> On Fri, Jan 23, 2004 at 10:52:34AM +0100, Bastian Blank wrote:
> > On Fri, Jan 23, 2004 at 03:06:45AM +0100, laurent.ml@linuxfr.org wrote:
> > > Tell me if I'm wrong, it seems an include is missing in
> > > extensions/libipt_time.c from iptables cvs.
> > > (line 302 : offsetof)
> > 
> > You should use <stddef.h> instead of <linux/stddef.h>.
> 
> At least on my debian machines /usr/include/stddef.h doesn't exist.
> 
> Thus, I'm accepting the patch.

On my debian machine stddef.h is in
/usr/lib/gcc-lib/i486-linux/3.3.3/include/ and gcc can find it with
<stddef.h> when compiling normally.  Not sure
about when compiling a kernel.

Stephen
